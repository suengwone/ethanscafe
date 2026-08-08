const NAVER_PROFILE_URL = 'https://openapi.naver.com/v1/nid/me';
const NAVER_TOKEN_URL = 'https://nid.naver.com/oauth2.0/token';

function validateNaverSignInRequest(data) {
  const accessToken = data && data.accessToken;
  if (typeof accessToken === 'string' && accessToken.trim().length > 0) {
    return {accessToken: accessToken.trim()};
  }

  const code = data && data.code;
  const state = data && data.state;
  if (
    typeof code === 'string' &&
    code.trim().length > 0 &&
    typeof state === 'string' &&
    state.trim().length > 0
  ) {
    return {code: code.trim(), state: state.trim()};
  }

  throw new Error('accessToken 또는 code/state가 올바르지 않습니다.');
}

function buildTokenRequestUrl({clientId, clientSecret, code, state}) {
  const params = new URLSearchParams({
    grant_type: 'authorization_code',
    client_id: clientId,
    client_secret: clientSecret,
    code,
    state,
  });
  return `${NAVER_TOKEN_URL}?${params.toString()}`;
}

function extractAccessToken(body) {
  if (
    !body ||
    typeof body.access_token !== 'string' ||
    body.access_token.length === 0
  ) {
    throw new Error('네이버 토큰 응답이 올바르지 않습니다.');
  }
  return body.access_token;
}

function extractNaverProfile(body) {
  if (
    !body ||
    body.resultcode !== '00' ||
    !body.response ||
    typeof body.response.id !== 'string' ||
    body.response.id.length === 0
  ) {
    throw new Error('네이버 프로필 응답이 올바르지 않습니다.');
  }
  return body.response;
}

function naverUid(profile) {
  return `naver:${profile.id}`;
}

function toUserRecordFields(profile) {
  const fields = {};
  const displayName = profile.nickname || profile.name;
  if (typeof displayName === 'string' && displayName.length > 0) {
    fields.displayName = displayName;
  }
  if (
    typeof profile.profile_image === 'string' &&
    profile.profile_image.length > 0
  ) {
    fields.photoURL = profile.profile_image;
  }
  if (typeof profile.email === 'string' && profile.email.length > 0) {
    fields.email = profile.email;
  }
  return fields;
}

module.exports = {
  NAVER_PROFILE_URL,
  NAVER_TOKEN_URL,
  validateNaverSignInRequest,
  buildTokenRequestUrl,
  extractAccessToken,
  extractNaverProfile,
  naverUid,
  toUserRecordFields,
};
