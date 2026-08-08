const test = require('node:test');
const assert = require('node:assert/strict');

const {
  validateConfirmRequest,
  toApprovalPayload,
  basicAuthHeader,
} = require('./toss_payment');

test('올바른 승인 요청은 필드를 그대로 반환한다', () => {
  const result = validateConfirmRequest({
    paymentKey: 'pk-123',
    orderId: 'bean-1700000000000-abcd',
    amount: 59000,
  });

  assert.deepEqual(result, {
    paymentKey: 'pk-123',
    orderId: 'bean-1700000000000-abcd',
    amount: 59000,
  });
});

test('paymentKey가 없으면 거부한다', () => {
  assert.throws(() =>
    validateConfirmRequest({orderId: 'bean-123456', amount: 1000}),
  );
});

test('orderId 형식이 틀리면 거부한다', () => {
  assert.throws(() =>
    validateConfirmRequest({
      paymentKey: 'pk',
      orderId: '주문!',
      amount: 1000,
    }),
  );
});

test('금액이 정수가 아니거나 0 이하면 거부한다', () => {
  for (const amount of [0, -100, 1.5, '1000', null]) {
    assert.throws(() =>
      validateConfirmRequest({
        paymentKey: 'pk',
        orderId: 'bean-123456',
        amount,
      }),
    );
  }
});

test('승인 응답을 클라이언트 페이로드로 변환한다', () => {
  const payload = toApprovalPayload(
    {
      paymentKey: 'pk-123',
      orderId: 'bean-123456',
      totalAmount: 59000,
      method: '카드',
      approvedAt: '2026-08-08T10:00:00+09:00',
      receipt: {url: 'https://dashboard.tosspayments.com/receipt/1'},
    },
    59000,
  );

  assert.deepEqual(payload, {
    paymentKey: 'pk-123',
    orderId: 'bean-123456',
    amount: 59000,
    method: '카드',
    approvedAt: '2026-08-08T10:00:00+09:00',
    receiptUrl: 'https://dashboard.tosspayments.com/receipt/1',
  });
});

test('승인 금액이 요청 금액과 다르면 거부한다', () => {
  assert.throws(() =>
    toApprovalPayload({paymentKey: 'pk', totalAmount: 1000}, 2000),
  );
});

test('시크릿 키로 Basic 인증 헤더를 만든다', () => {
  assert.equal(
    basicAuthHeader('test_sk_abc'),
    'Basic ' + Buffer.from('test_sk_abc:').toString('base64'),
  );
});
