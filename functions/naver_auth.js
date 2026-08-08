const NAVER_PROFILE_URL = 'https://openapi.naver.com/v1/nid/me';

function validateNaverSignInRequest(data) {
  const accessToken = data && data.accessToken;

  if (typeof accessToken !== 'string' || accessToken.trim().length === 0) {
    throw new Error('accessToken이 올바르지 않습니다.');
  }
  return {accessToken: accessToken.trim()};
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
  validateNaverSignInRequest,
  extractNaverProfile,
  naverUid,
  toUserRecordFields,
};
