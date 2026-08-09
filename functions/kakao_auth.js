const KAKAO_TOKEN_URL = 'https://kauth.kakao.com/oauth/token';

function validateKakaoSignInRequest(data) {
  const code = data && data.code;
  const redirectUri = data && data.redirectUri;
  if (
    typeof code !== 'string' ||
    code.trim().length === 0 ||
    typeof redirectUri !== 'string' ||
    !/^https?:\/\//.test(redirectUri.trim())
  ) {
    throw new Error('code 또는 redirectUri가 올바르지 않습니다.');
  }
  return {code: code.trim(), redirectUri: redirectUri.trim()};
}

function buildKakaoTokenBody({clientId, clientSecret, code, redirectUri}) {
  const params = new URLSearchParams({
    grant_type: 'authorization_code',
    client_id: clientId,
    redirect_uri: redirectUri,
    code,
  });
  if (typeof clientSecret === 'string' && clientSecret.length > 0) {
    params.set('client_secret', clientSecret);
  }
  return params.toString();
}

function extractKakaoTokens(body) {
  if (
    !body ||
    typeof body.id_token !== 'string' ||
    body.id_token.length === 0
  ) {
    throw new Error('카카오 토큰 응답이 올바르지 않습니다.');
  }
  const tokens = {idToken: body.id_token};
  if (
    typeof body.access_token === 'string' &&
    body.access_token.length > 0
  ) {
    tokens.accessToken = body.access_token;
  }
  return tokens;
}

module.exports = {
  KAKAO_TOKEN_URL,
  validateKakaoSignInRequest,
  buildKakaoTokenBody,
  extractKakaoTokens,
};
