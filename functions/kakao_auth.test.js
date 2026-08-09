const test = require('node:test');
const assert = require('node:assert/strict');

const {
  validateKakaoSignInRequest,
  buildKakaoTokenBody,
  extractKakaoTokens,
} = require('./kakao_auth');

test('올바른 요청은 code와 redirectUri를 반환한다', () => {
  const result = validateKakaoSignInRequest({
    code: ' c-1 ',
    redirectUri: ' https://example.com/auth/kakao/callback ',
  });

  assert.deepEqual(result, {
    code: 'c-1',
    redirectUri: 'https://example.com/auth/kakao/callback',
  });
});

test('code나 redirectUri가 올바르지 않으면 거부한다', () => {
  const bodies = [
    null,
    {},
    {code: '', redirectUri: 'https://example.com'},
    {code: 'c-1'},
    {code: 'c-1', redirectUri: ''},
    {code: 'c-1', redirectUri: 'javascript:alert(1)'},
    {code: 1, redirectUri: 'https://example.com'},
  ];
  for (const data of bodies) {
    assert.throws(() => validateKakaoSignInRequest(data));
  }
});

test('토큰 교환 요청 본문을 만든다', () => {
  const body = buildKakaoTokenBody({
    clientId: 'id-1',
    clientSecret: 'secret-1',
    code: 'c-1',
    redirectUri: 'https://example.com/auth/kakao/callback',
  });

  const params = new URLSearchParams(body);
  assert.equal(params.get('grant_type'), 'authorization_code');
  assert.equal(params.get('client_id'), 'id-1');
  assert.equal(params.get('client_secret'), 'secret-1');
  assert.equal(params.get('code'), 'c-1');
  assert.equal(
    params.get('redirect_uri'),
    'https://example.com/auth/kakao/callback',
  );
});

test('clientSecret이 없으면 본문에서 제외한다', () => {
  const body = buildKakaoTokenBody({
    clientId: 'id-1',
    clientSecret: '',
    code: 'c-1',
    redirectUri: 'https://example.com/auth/kakao/callback',
  });

  assert.equal(new URLSearchParams(body).has('client_secret'), false);
});

test('토큰 응답에서 id_token과 access_token을 추출한다', () => {
  assert.deepEqual(
    extractKakaoTokens({id_token: 'it-1', access_token: 'at-1'}),
    {idToken: 'it-1', accessToken: 'at-1'},
  );
  assert.deepEqual(extractKakaoTokens({id_token: 'it-1'}), {idToken: 'it-1'});
});

test('id_token이 없으면 거부한다', () => {
  for (const body of [null, {}, {id_token: ''}, {access_token: 'at-1'}]) {
    assert.throws(() => extractKakaoTokens(body));
  }
});
