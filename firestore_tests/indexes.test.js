const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');

const root = path.join(__dirname, '..');

/**
 * 파일 안에서 이름 하나에 문자열 하나가 묶인 상수를 모은다.
 *
 * 컬렉션 이름은 대개 `static const collectionPath = 'active_orders'`처럼 상수로
 * 두고 쓴다. 이걸 못 따라가면 쿼리를 한 건도 못 찾고, 그러면 이 검사가 초록불인
 * 채로 아무것도 지키지 않는다.
 */
function stringConstants(source) {
  const constants = new Map();
  const pattern =
      /(?:static\s+)?const\s+([A-Za-z_$][\w$]*)\s*=\s*['"`]([\w-]+)['"`]/g;
  for (const [, name, value] of source.matchAll(pattern)) {
    constants.set(name, value);
  }
  return constants;
}

/**
 * `const {COLLECTION: ALIAS} = require('./x')` 로 들여온 이름을 원본 모듈에서 찾는다.
 */
function requiredConstants(source, file) {
  const constants = new Map();
  const pattern = /const\s*\{([^}]*)\}\s*=\s*require\(\s*['"`]\.\/([\w-]+)['"`]\s*\)/g;
  for (const [, names, moduleName] of source.matchAll(pattern)) {
    const modulePath = path.join(path.dirname(file), `${moduleName}.js`);
    if (!fs.existsSync(modulePath)) {
      continue;
    }
    const exported = stringConstants(fs.readFileSync(modulePath, 'utf8'));
    for (const entry of names.split(',')) {
      const [original, alias] = entry.split(':').map((part) => part.trim());
      if (exported.has(original)) {
        constants.set(alias || original, exported.get(original));
      }
    }
  }
  return constants;
}

/**
 * 복합 색인이 필요한 쿼리를 소스에서 찾는다.
 *
 * Firestore는 조건이 둘 이상 걸린 쿼리에 복합 색인을 요구한다. 색인이 없으면
 * 배포는 멀쩡히 끝나고 그 화면을 처음 연 사람이 오류를 본다. 트리거에서 나면
 * 아무도 못 본 채 기능만 조용히 멈춘다.
 *
 * 정규식으로 읽으므로 완벽하진 않다. `.collection(...)` 뒤에 이어지는 `.where`·
 * `.orderBy` 사슬만 본다. 놓치는 쪽으로 틀리게 두고, 잡은 것은 확실히 잡는다.
 */
function compositeQueries(source, file) {
  const names = new Map([
    ...stringConstants(source),
    ...requiredConstants(source, path.join(root, file)),
  ]);
  const found = [];
  const pattern =
      /\.collection\(\s*(['"`][\w-]+['"`]|[A-Za-z_$][\w$]*)\s*\)((?:\s*\.\s*(?:where|orderBy)\([^;]*?\))+)/g;
  for (const match of source.matchAll(pattern)) {
    const [, rawCollection, chain] = match;
    const collection = /^['"`]/.test(rawCollection) ?
      rawCollection.slice(1, -1) :
      names.get(rawCollection);
    if (!collection) {
      continue;
    }
    const fields =
        [...chain.matchAll(/\.\s*(where|orderBy)\(\s*['"`]([\w.]+)['"`]/g)]
            .map((m) => m[2]);
    if (fields.length < 2) {
      continue;
    }
    const line = source.slice(0, match.index).split('\n').length;
    found.push({collection, fields, where: `${file}:${line}`});
  }
  return found;
}

function sourceFiles() {
  const files = [];
  const walk = (dir, accept) => {
    for (const entry of fs.readdirSync(dir, {withFileTypes: true})) {
      const full = path.join(dir, entry.name);
      if (entry.isDirectory()) {
        if (entry.name !== 'node_modules') {
          walk(full, accept);
        }
      } else if (accept(entry.name)) {
        files.push(full);
      }
    }
  };
  walk(path.join(root, 'lib'), (name) =>
    name.endsWith('.dart') && !name.endsWith('.g.dart') &&
      !name.endsWith('.freezed.dart'));
  walk(path.join(root, 'functions'), (name) =>
    name.endsWith('.js') && !name.endsWith('.test.js'));
  return files;
}

function declaredIndexes() {
  const config = JSON.parse(
      fs.readFileSync(path.join(root, 'firestore.indexes.json'), 'utf8'));
  return config.indexes.map((index) => ({
    collection: index.collectionGroup,
    fields: index.fields.map((field) => field.fieldPath),
  }));
}

function isDeclared(query, indexes) {
  return indexes.some((index) =>
    index.collection === query.collection &&
      query.fields.every((field) => index.fields.includes(field)));
}

test('복합 색인이 필요한 쿼리는 전부 선언돼 있다', () => {
  const indexes = declaredIndexes();
  const missing = [];

  for (const file of sourceFiles()) {
    const source = fs.readFileSync(file, 'utf8');
    for (const query of compositeQueries(source, path.relative(root, file))) {
      if (!isDeclared(query, indexes)) {
        missing.push(`${query.where} — ${query.collection}(${query.fields})`);
      }
    }
  }

  assert.deepEqual(
      missing,
      [],
      `firestore.indexes.json에 없는 쿼리:\n  ${missing.join('\n  ')}`,
  );
});

test('선언한 색인은 실제로 쓰이는 것뿐이다', () => {
  // 아무도 쓰지 않는 색인은 쓰기를 느리게 만들고, 왜 있는지 아무도 모르게 된다.
  const queries = sourceFiles().flatMap((file) =>
    compositeQueries(fs.readFileSync(file, 'utf8'), path.relative(root, file)));

  const unused = declaredIndexes().filter((index) =>
    !queries.some((query) =>
      query.collection === index.collection &&
        query.fields.every((field) => index.fields.includes(field))));

  assert.deepEqual(
      unused.map((index) => `${index.collection}(${index.fields})`),
      [],
  );
});

test('쿼리 사슬을 읽어 낸다', () => {
  const source = `
    firestore.collection('active_orders')
        .where('orderType', '==', 'pickup')
        .where('storeId', '==', storeId)
  `;
  assert.deepEqual(compositeQueries(source, 'x.js'), [
    {collection: 'active_orders', fields: ['orderType', 'storeId'],
      where: 'x.js:2'},
  ]);
});

test('컬렉션 이름이 상수여도 따라간다', () => {
  // 실제 코드는 전부 이 모양이다. 못 따라가면 이 검사는 빈 통과가 된다.
  const source = `
    static const collectionPath = 'active_orders';
    _firestore.collection(collectionPath)
        .where('orderType', isEqualTo: orderType)
        .orderBy('createdAt')
  `;
  assert.deepEqual(compositeQueries(source, 'x.dart'), [
    {collection: 'active_orders', fields: ['orderType', 'createdAt'],
      where: 'x.dart:3'},
  ]);
});

test('찾은 쿼리가 하나도 없으면 검사가 의미 없다', () => {
  // 첫 판에서 실제로 이렇게 비어 있었다. 빈 통과를 막는 안전핀이다.
  const queries = sourceFiles().flatMap((file) =>
    compositeQueries(fs.readFileSync(file, 'utf8'), path.relative(root, file)));
  assert.ok(queries.length > 0, '소스에서 복합 쿼리를 한 건도 찾지 못했다');
});

test('조건이 하나뿐인 쿼리는 색인을 요구하지 않는다', () => {
  const source = `firestore.collection('notices').orderBy('createdAt')`;
  assert.deepEqual(compositeQueries(source, 'x.js'), []);
});
