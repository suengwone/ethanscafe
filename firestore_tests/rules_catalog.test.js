const test = require('node:test');
const {assertFails, assertSucceeds} = require('@firebase/rules-unit-testing');
const {doc, getDoc, setDoc, updateDoc} = require('firebase/firestore');

const {testEnvironment, seed, admin, user, guest} = require('./helpers');

let env;

test.before(async () => {
  env = await testEnvironment('catalog');
});

test.after(async () => {
  await env.cleanup();
});

test.beforeEach(async () => {
  await env.clearFirestore();
});

// 앱을 열자마자 보이는 것들. 로그인 전에도 읽히고, 고치는 것은 매장만 한다.
for (const collection of ['menus', 'beans', 'banners', 'notices', 'stores']) {
  test(`${collection}는 누구나 읽고 관리자만 쓴다`, async () => {
    await seed(env, (db) => setDoc(doc(db, `${collection}/d1`), {name: '아메리카노'}));

    await assertSucceeds(getDoc(doc(guest(env).firestore(), `${collection}/d1`)));
    await assertFails(
      updateDoc(doc(user(env, 'me').firestore(), `${collection}/d1`), {
        name: '공짜',
      }),
    );
    await assertSucceeds(
      updateDoc(doc(admin(env).firestore(), `${collection}/d1`), {
        name: '라떼',
      }),
    );
  });
}

test('리뷰는 로그인하면 남의 것도 읽지만 쓰는 것은 본인뿐이다', async () => {
  await seed(env, (db) => setDoc(doc(db, 'reviews/other'), {reviews: []}));

  await assertSucceeds(
    getDoc(doc(user(env, 'me').firestore(), 'reviews/other')),
  );
  await assertFails(getDoc(doc(guest(env).firestore(), 'reviews/other')));
  await assertFails(
    updateDoc(doc(user(env, 'me').firestore(), 'reviews/other'), {reviews: []}),
  );
  await assertSucceeds(
    setDoc(doc(user(env, 'me').firestore(), 'reviews/me'), {reviews: []}),
  );
});

test('규칙에 없는 컬렉션은 관리자에게도 닫혀 있다', async () => {
  await seed(env, (db) => setDoc(doc(db, 'secrets/s1'), {token: 'x'}));

  await assertFails(getDoc(doc(admin(env).firestore(), 'secrets/s1')));
  await assertFails(getDoc(doc(user(env, 'me').firestore(), 'secrets/s1')));
  await assertFails(
    setDoc(doc(admin(env).firestore(), 'secrets/s2'), {token: 'x'}),
  );
});
