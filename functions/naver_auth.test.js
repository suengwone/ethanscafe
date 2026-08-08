const test = require('node:test');
const assert = require('node:assert/strict');

const {
  validateNaverSignInRequest,
  extractNaverProfile,
  naverUid,
  toUserRecordFields,
} = require('./naver_auth');

test('올바른 요청은 accessToken을 반환한다', () => {
  const result = validateNaverSignInRequest({accessToken: ' token-123 '});

  assert.deepEqual(result, {accessToken: 'token-123'});
});

test('accessToken이 없거나 비어 있으면 거부한다', () => {
  for (const data of [null, {}, {accessToken: ''}, {accessToken: '   '}, {accessToken: 1}]) {
    assert.throws(() => validateNaverSignInRequest(data));
  }
});

test('정상 프로필 응답에서 프로필을 추출한다', () => {
  const profile = extractNaverProfile({
    resultcode: '00',
    message: 'success',
    response: {id: 'abc123', nickname: '홍길동'},
  });

  assert.equal(profile.id, 'abc123');
  assert.equal(profile.nickname, '홍길동');
});

test('실패 응답이나 id 누락 시 거부한다', () => {
  const bodies = [
    null,
    {},
    {resultcode: '024', message: 'Authentication failed'},
    {resultcode: '00', response: {}},
    {resultcode: '00', response: {id: ''}},
  ];
  for (const body of bodies) {
    assert.throws(() => extractNaverProfile(body));
  }
});

test('네이버 프로필 id로 uid를 만든다', () => {
  assert.equal(naverUid({id: 'abc123'}), 'naver:abc123');
});

test('프로필을 사용자 레코드 필드로 변환한다', () => {
  const fields = toUserRecordFields({
    id: 'abc123',
    nickname: '홍길동',
    email: 'hong@naver.com',
    profile_image: 'https://example.com/p.png',
  });

  assert.deepEqual(fields, {
    displayName: '홍길동',
    photoURL: 'https://example.com/p.png',
    email: 'hong@naver.com',
  });
});

test('nickname이 없으면 name을 displayName으로 사용한다', () => {
  const fields = toUserRecordFields({id: 'abc123', name: '홍길동'});

  assert.deepEqual(fields, {displayName: '홍길동'});
});

test('비어 있는 프로필은 빈 필드를 반환한다', () => {
  assert.deepEqual(toUserRecordFields({id: 'abc123'}), {});
});
