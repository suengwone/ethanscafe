const test = require('node:test');
const assert = require('node:assert/strict');

const {
  CHARGE_BONUSES,
  validateChargeRequest,
  chargeBonus,
  chargeHistoryEntry,
  chargeResultPayload,
  newMembershipId,
} = require('./points_charge');

test('올바른 충전 요청은 필드를 그대로 반환한다', () => {
  const result = validateChargeRequest({
    paymentKey: 'pk-123',
    orderId: 'charge-1700000000000-abcd',
    amount: 30000,
  });

  assert.deepEqual(result, {
    paymentKey: 'pk-123',
    orderId: 'charge-1700000000000-abcd',
    amount: 30000,
  });
});

test('paymentKey가 없으면 거부한다', () => {
  assert.throws(() =>
    validateChargeRequest({orderId: 'charge-123456', amount: 10000}),
  );
});

test('충전용 orderId 형식이 아니면 거부한다', () => {
  for (const orderId of ['bean-1700000000000-abcd', '충전!', 'charge-']) {
    assert.throws(() =>
      validateChargeRequest({paymentKey: 'pk', orderId, amount: 10000}),
    );
  }
});

test('정의되지 않은 충전 금액은 거부한다', () => {
  for (const amount of [0, -100, 15000, 1.5, '10000', null, 20000]) {
    assert.throws(() =>
      validateChargeRequest({
        paymentKey: 'pk',
        orderId: 'charge-123456',
        amount,
      }),
    );
  }
});

test('충전 금액별 보너스를 계산한다', () => {
  assert.equal(chargeBonus(10000), 0);
  assert.equal(chargeBonus(30000), 1000);
  assert.equal(chargeBonus(50000), 2500);
  assert.equal(chargeBonus(100000), 7000);
});

test('충전 상품 표는 4종이다', () => {
  assert.equal(Object.keys(CHARGE_BONUSES).length, 4);
});

test('보너스가 있는 충전 히스토리 항목을 만든다', () => {
  const entry = chargeHistoryEntry({
    orderId: 'charge-123456',
    paymentKey: 'pk-123',
    amount: 30000,
    bonus: 1000,
    createdAt: 'now',
  });

  assert.deepEqual(entry, {
    id: 'charge-123456',
    type: 'charge',
    description: '선불권 충전',
    amount: 31000,
    paymentAmount: 30000,
    bonusAmount: 1000,
    paymentKey: 'pk-123',
    createdAt: 'now',
  });
});

test('보너스가 없으면 bonusAmount를 기록하지 않는다', () => {
  const entry = chargeHistoryEntry({
    orderId: 'charge-123456',
    paymentKey: 'pk-123',
    amount: 10000,
    bonus: 0,
    createdAt: 'now',
  });

  assert.equal(entry.amount, 10000);
  assert.ok(!('bonusAmount' in entry));
});

test('충전 결과 페이로드를 만든다', () => {
  const result = chargeResultPayload({
    paymentKey: 'pk-123',
    orderId: 'charge-123456',
    amount: 50000,
    bonus: 2500,
    method: '카드',
    balance: 53750,
  });

  assert.deepEqual(result, {
    paymentKey: 'pk-123',
    orderId: 'charge-123456',
    amount: 50000,
    bonus: 2500,
    charged: 52500,
    method: '카드',
    balance: 53750,
  });
});

test('method가 문자열이 아니면 카드로 대체한다', () => {
  const result = chargeResultPayload({
    paymentKey: 'pk',
    orderId: 'charge-123456',
    amount: 10000,
    bonus: 0,
    method: null,
    balance: 10000,
  });

  assert.equal(result.method, '카드');
});

test('새 멤버십 ID 형식을 만든다', () => {
  assert.match(newMembershipId(), /^MEMBER-\d{8}$/);
});
