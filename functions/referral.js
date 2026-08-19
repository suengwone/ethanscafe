const REFERRAL_REWARD_POINTS = 3000;
const REFERRAL_INVITE_LIMIT = 10;
// 코드를 불러주고 받아적는 일이 잦으므로 0/O, 1/I처럼 헷갈리는 글자는 뺀다.
const REFERRAL_CODE_ALPHABET = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
const REFERRAL_CODE_LENGTH = 6;
const REFERRAL_INVITER_DESCRIPTION = '친구 초대 보상';
const REFERRAL_INVITEE_DESCRIPTION = '초대 코드 입력 보상';

function newReferralCode(random = Math.random) {
  let code = '';
  for (let i = 0; i < REFERRAL_CODE_LENGTH; i += 1) {
    const index = Math.floor(random() * REFERRAL_CODE_ALPHABET.length);
    code += REFERRAL_CODE_ALPHABET[index];
  }
  return code;
}

function normalizeReferralCode(value) {
  if (typeof value !== 'string') {
    throw new Error('초대 코드가 올바르지 않습니다.');
  }
  const normalized = value.toUpperCase().replace(/[^A-Z0-9]/g, '');
  if (normalized.length !== REFERRAL_CODE_LENGTH) {
    throw new Error(`초대 코드는 ${REFERRAL_CODE_LENGTH}자리입니다.`);
  }
  for (const letter of normalized) {
    if (!REFERRAL_CODE_ALPHABET.includes(letter)) {
      throw new Error('초대 코드에 사용할 수 없는 글자가 있습니다.');
    }
  }
  return normalized;
}

function validateRedeemRequest(data) {
  return {code: normalizeReferralCode(data && data.code)};
}

function normalizeReferral(data) {
  const raw = data || {};
  return {
    code: typeof raw.code === 'string' ? raw.code : '',
    invitedCount: Number.isInteger(raw.invitedCount) ? raw.invitedCount : 0,
    earnedPoints: Number.isInteger(raw.earnedPoints) ? raw.earnedPoints : 0,
    redeemedCode: typeof raw.redeemedCode === 'string' ? raw.redeemedCode : null,
  };
}

function assertRedeemable({inviterUid, inviteeUid, inviter, invitee}) {
  if (!inviterUid) {
    throw new Error('존재하지 않는 초대 코드입니다.');
  }
  if (inviterUid === inviteeUid) {
    throw new Error('본인의 초대 코드는 사용할 수 없습니다.');
  }
  if (normalizeReferral(invitee).redeemedCode) {
    throw new Error('초대 코드는 한 번만 입력할 수 있습니다.');
  }
  if (normalizeReferral(inviter).invitedCount >= REFERRAL_INVITE_LIMIT) {
    throw new Error(
      `초대 보상은 최대 ${REFERRAL_INVITE_LIMIT}명까지 받을 수 있습니다.`,
    );
  }
}

// 초대 보상은 결제가 없는 적립이므로 매장 적립과 같은 'earn' 항목으로 남긴다.
function referralRewardEntry({id, description, createdAt}) {
  return {
    id,
    type: 'earn',
    description,
    amount: REFERRAL_REWARD_POINTS,
    createdAt,
  };
}

function invitedReferral(referral) {
  const current = normalizeReferral(referral);
  return {
    ...current,
    invitedCount: current.invitedCount + 1,
    earnedPoints: current.earnedPoints + REFERRAL_REWARD_POINTS,
  };
}

function redeemedReferral(referral, code) {
  const current = normalizeReferral(referral);
  return {
    ...current,
    redeemedCode: code,
    earnedPoints: current.earnedPoints + REFERRAL_REWARD_POINTS,
  };
}

function referralSummaryPayload(referral) {
  const current = normalizeReferral(referral);
  return {
    code: current.code,
    invitedCount: current.invitedCount,
    earnedPoints: current.earnedPoints,
    redeemedCode: current.redeemedCode,
    reward: REFERRAL_REWARD_POINTS,
    inviteLimit: REFERRAL_INVITE_LIMIT,
  };
}

function redeemResultPayload({code, balance, summary}) {
  return {
    code,
    reward: REFERRAL_REWARD_POINTS,
    balance,
    summary: referralSummaryPayload(summary),
  };
}

module.exports = {
  REFERRAL_REWARD_POINTS,
  REFERRAL_INVITE_LIMIT,
  REFERRAL_CODE_ALPHABET,
  REFERRAL_CODE_LENGTH,
  REFERRAL_INVITER_DESCRIPTION,
  REFERRAL_INVITEE_DESCRIPTION,
  newReferralCode,
  normalizeReferralCode,
  validateRedeemRequest,
  normalizeReferral,
  assertRedeemable,
  referralRewardEntry,
  invitedReferral,
  redeemedReferral,
  referralSummaryPayload,
  redeemResultPayload,
};
