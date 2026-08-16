const CHARGE_BONUSES = {
  10000: 0,
  30000: 1000,
  50000: 2500,
  100000: 7000,
};

const CHARGE_ORDER_ID_PATTERN = /^charge-[A-Za-z0-9_-]{4,57}$/;

const CHARGE_DESCRIPTION = '선불권 충전';

function validateChargeRequest(data) {
  const paymentKey = data && data.paymentKey;
  const orderId = data && data.orderId;
  const amount = data && data.amount;

  if (typeof paymentKey !== 'string' || paymentKey.length === 0) {
    throw new Error('paymentKey가 올바르지 않습니다.');
  }
  if (typeof orderId !== 'string' || !CHARGE_ORDER_ID_PATTERN.test(orderId)) {
    throw new Error('orderId가 올바르지 않습니다.');
  }
  if (!Number.isInteger(amount) ||
      !Object.hasOwn(CHARGE_BONUSES, String(amount))) {
    throw new Error('충전 금액이 올바르지 않습니다.');
  }
  return {paymentKey, orderId, amount};
}

function chargeBonus(amount) {
  const bonus = CHARGE_BONUSES[amount];
  if (bonus === undefined) {
    throw new Error('충전 금액이 올바르지 않습니다.');
  }
  return bonus;
}

function chargeHistoryEntry({orderId, paymentKey, amount, bonus, createdAt}) {
  const entry = {
    id: orderId,
    type: 'charge',
    description: CHARGE_DESCRIPTION,
    amount: amount + bonus,
    paymentAmount: amount,
    paymentKey,
    createdAt,
  };
  if (bonus > 0) {
    entry.bonusAmount = bonus;
  }
  return entry;
}

function chargeResultPayload({paymentKey, orderId, amount, bonus, method, balance}) {
  return {
    paymentKey,
    orderId,
    amount,
    bonus,
    charged: amount + bonus,
    method: typeof method === 'string' ? method : '카드',
    balance,
  };
}

function newMembershipId(random = Math.random) {
  let digits = '';
  for (let i = 0; i < 8; i += 1) {
    digits += Math.floor(random() * 10);
  }
  return `MEMBER-${digits}`;
}

module.exports = {
  CHARGE_BONUSES,
  CHARGE_DESCRIPTION,
  validateChargeRequest,
  chargeBonus,
  chargeHistoryEntry,
  chargeResultPayload,
  newMembershipId,
};
