const test = require('node:test');
const assert = require('node:assert/strict');

const {USER_DATA_COLLECTIONS, userDataDocPaths} = require('./account_cleanup');

test('사용자별 데이터 문서 경로를 모두 생성한다', () => {
  const paths = userDataDocPaths('user-1');

  assert.equal(paths.length, USER_DATA_COLLECTIONS.length);
  for (const collection of USER_DATA_COLLECTIONS) {
    assert.ok(paths.includes(`${collection}/user-1`));
  }
});

test('빈 사용자 ID는 거부한다', () => {
  assert.throws(() => userDataDocPaths(''));
  assert.throws(() => userDataDocPaths('   '));
  assert.throws(() => userDataDocPaths(undefined));
});
