const test = require('node:test');
const assert = require('node:assert/strict');

const {abortPlacedOrder, pendingPaymentOf} = require('./index');
const {PAYMENT_ALREADY_USED_MESSAGE} = require('./order_checkout');

/** 취소·기록 호출을 받아 적는 가짜 한 벌. */
function spies({cancelSucceeds = true} = {}) {
  const cancelled = [];
  const recorded = [];
  return {
    cancelled,
    recorded,
    cancelPayment: async (paymentKey) => {
      cancelled.push(paymentKey);
      return cancelSucceeds;
    },
    recordFailure: async (entry) => {
      recorded.push(entry);
    },
  };
}

const payment = {
  paymentKey: 'pay_1',
  orderId: 'order_1',
  amount: 12000,
  orderType: 'bean',
};

test('품절로 주문이 막히면 이미 승인된 결제를 취소한다', async () => {
  // 품절 검사는 결제를 확인하기 전에 던진다. 예전에는 이 구간에서 낸 돈이
  // 아무 기록도 없이 남았다.
  const effects = spies();
  const thrown = await abortPlacedOrder({
    uid: 'u1',
    error: new Error('품절된 상품이 포함되어 있습니다. 장바구니를 다시 확인해 주세요.'),
    pendingPayment: payment,
    ...effects,
  });

  assert.deepEqual(effects.cancelled, ['pay_1']);
  assert.deepEqual(effects.recorded, []);
  assert.equal(thrown.code, 'aborted');
  assert.match(thrown.message, /자동 취소/);
});

test('취소까지 실패하면 매장이 볼 수 있게 남긴다', async () => {
  const effects = spies({cancelSucceeds: false});
  const thrown = await abortPlacedOrder({
    uid: 'u1',
    error: new Error('적용할 수 없는 쿠폰입니다.'),
    pendingPayment: payment,
    ...effects,
  });

  assert.deepEqual(effects.cancelled, ['pay_1']);
  assert.equal(effects.recorded.length, 1);
  assert.equal(effects.recorded[0].uid, 'u1');
  assert.equal(effects.recorded[0].orderType, 'bean');
  assert.equal(effects.recorded[0].order.paymentKey, 'pay_1');
  // 주문이 서지 못했으니 결제의 orderId가 매장이 대조할 유일한 번호다.
  assert.equal(effects.recorded[0].order.id, 'order_1');
  assert.equal(effects.recorded[0].order.totalAmount, 12000);
  assert.equal(thrown.code, 'internal');
});

test('이미 다른 주문이 쓰는 결제는 취소하지 않는다', async () => {
  // 중복 제출이다. 취소하면 멀쩡히 성립한 주문의 돈만 돌려주게 된다.
  const effects = spies();
  const thrown = await abortPlacedOrder({
    uid: 'u1',
    error: new Error(PAYMENT_ALREADY_USED_MESSAGE),
    pendingPayment: payment,
    ...effects,
  });

  assert.deepEqual(effects.cancelled, []);
  assert.deepEqual(effects.recorded, []);
  assert.equal(thrown.message, PAYMENT_ALREADY_USED_MESSAGE);
});

test('결제 없는 주문은 취소할 것이 없다', async () => {
  const effects = spies();
  const thrown = await abortPlacedOrder({
    uid: 'u1',
    error: new Error('장바구니가 비어 있습니다.'),
    pendingPayment: null,
    ...effects,
  });

  assert.deepEqual(effects.cancelled, []);
  assert.equal(thrown.code, 'failed-precondition');
  assert.equal(thrown.message, '장바구니가 비어 있습니다.');
});

test('기록에 실패해도 고객에게는 안내가 간다', async () => {
  const effects = spies({cancelSucceeds: false});
  const thrown = await abortPlacedOrder({
    uid: 'u1',
    error: new Error('품절된 상품이 포함되어 있습니다.'),
    pendingPayment: payment,
    cancelPayment: effects.cancelPayment,
    recordFailure: async () => {
      throw new Error('Firestore 쓰기 실패');
    },
  });

  assert.equal(thrown.code, 'internal');
  assert.match(thrown.message, /고객센터/);
});

test('요청에서 결제 정보를 꺼낸다', () => {
  assert.deepEqual(
      pendingPaymentOf({
        orderType: 'pickup',
        payment: {paymentKey: 'pay_9', orderId: 'o9', amount: 5000},
      }),
      {paymentKey: 'pay_9', orderId: 'o9', amount: 5000, orderType: 'pickup'},
  );
  assert.equal(pendingPaymentOf({}), null);
  assert.equal(pendingPaymentOf({payment: {paymentKey: ''}}), null);
  assert.equal(pendingPaymentOf(null), null);
});
