const test = require('node:test');
const assert = require('node:assert/strict');

const {
  REFERRAL_REWARD_POINTS,
  REFERRAL_INVITE_LIMIT,
  REFERRAL_CODE_ALPHABET,
  REFERRAL_CODE_LENGTH,
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
} = require('./referral');

test('초대 코드는 헷갈리는 글자 없이 6자리로 만든다', () => {
  const code = newReferralCode(() => 0.5);

  assert.equal(code.length, REFERRAL_CODE_LENGTH);
  for (const letter of code) {
    assert.ok(REFERRAL_CODE_ALPHABET.includes(letter));
  }
  for (const letter of ['0', 'O', '1', 'I']) {
    assert.ok(!REFERRAL_CODE_ALPHABET.includes(letter));
  }
});

test('입력한 코드는 대문자로 맞추고 구분 기호를 지운다', () => {
  assert.equal(normalizeReferralCode('fxp-2k9'), 'FXP2K9');
  assert.equal(normalizeReferralCode(' ab c2 34 '), 'ABC234');
});

test('길이가 다르거나 쓸 수 없는 글자가 있으면 거부한다', () => {
  for (const code of ['ABC12', 'ABCD123', 'ABC01D', 'ABCDIF', '', null, 12]) {
    assert.throws(() => normalizeReferralCode(code));
  }
});

test('사용 요청은 정규화한 코드만 남긴다', () => {
  assert.deepEqual(validateRedeemRequest({code: 'fxp-2k9', reward: 999999}), {
    code: 'FXP2K9',
  });
});

test('초대 문서가 비어 있으면 기본값으로 읽는다', () => {
  assert.deepEqual(normalizeReferral(undefined), {
    code: '',
    invitedCount: 0,
    earnedPoints: 0,
    redeemedCode: null,
  });
});

test('본인 코드는 사용할 수 없다', () => {
  assert.throws(
    () =>
      assertRedeemable({
        inviterUid: 'me',
        inviteeUid: 'me',
        inviter: {code: 'ABC234'},
        invitee: {code: 'ABC234'},
      }),
    /본인의 초대 코드/,
  );
});

test('없는 코드는 사용할 수 없다', () => {
  assert.throws(
    () =>
      assertRedeemable({
        inviterUid: null,
        inviteeUid: 'me',
        inviter: null,
        invitee: {},
      }),
    /존재하지 않는/,
  );
});

test('초대 코드는 한 번만 입력할 수 있다', () => {
  assert.throws(
    () =>
      assertRedeemable({
        inviterUid: 'friend',
        inviteeUid: 'me',
        inviter: {invitedCount: 0},
        invitee: {redeemedCode: 'XYZ789'},
      }),
    /한 번만/,
  );
});

test('초대 보상 한도를 채운 회원의 코드는 거부한다', () => {
  assert.throws(
    () =>
      assertRedeemable({
        inviterUid: 'friend',
        inviteeUid: 'me',
        inviter: {invitedCount: REFERRAL_INVITE_LIMIT},
        invitee: {},
      }),
    /최대 10명/,
  );
});

test('한도 직전까지는 사용할 수 있다', () => {
  assert.doesNotThrow(() =>
    assertRedeemable({
      inviterUid: 'friend',
      inviteeUid: 'me',
      inviter: {invitedCount: REFERRAL_INVITE_LIMIT - 1},
      invitee: {},
    }),
  );
});

test('초대 보상은 결제 없는 적립 항목으로 남는다', () => {
  const entry = referralRewardEntry({
    id: 'referral-1',
    description: '친구 초대 보상',
    createdAt: 'ts',
  });

  assert.deepEqual(entry, {
    id: 'referral-1',
    type: 'earn',
    description: '친구 초대 보상',
    amount: REFERRAL_REWARD_POINTS,
    createdAt: 'ts',
  });
  assert.equal(Object.hasOwn(entry, 'paymentAmount'), false);
});

test('초대한 쪽은 초대 수와 받은 보상이 함께 오른다', () => {
  assert.deepEqual(invitedReferral({code: 'ABC234', invitedCount: 2, earnedPoints: 6000}), {
    code: 'ABC234',
    invitedCount: 3,
    earnedPoints: 9000,
    redeemedCode: null,
  });
});

test('초대받은 쪽은 입력한 코드를 남기고 보상만 받는다', () => {
  assert.deepEqual(redeemedReferral({code: 'XYZ789'}, 'ABC234'), {
    code: 'XYZ789',
    invitedCount: 0,
    earnedPoints: REFERRAL_REWARD_POINTS,
    redeemedCode: 'ABC234',
  });
});

test('요약에는 보상 금액과 한도를 함께 실어 보낸다', () => {
  assert.deepEqual(referralSummaryPayload({code: 'ABC234', invitedCount: 1}), {
    code: 'ABC234',
    invitedCount: 1,
    earnedPoints: 0,
    redeemedCode: null,
    reward: REFERRAL_REWARD_POINTS,
    inviteLimit: REFERRAL_INVITE_LIMIT,
  });
});

test('사용 결과는 잔액과 갱신된 요약을 함께 돌려준다', () => {
  const result = redeemResultPayload({
    code: 'ABC234',
    balance: 5000,
    summary: {code: 'XYZ789', redeemedCode: 'ABC234', earnedPoints: 3000},
  });

  assert.equal(result.code, 'ABC234');
  assert.equal(result.reward, REFERRAL_REWARD_POINTS);
  assert.equal(result.balance, 5000);
  assert.equal(result.summary.redeemedCode, 'ABC234');
});
