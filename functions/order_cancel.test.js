const test = require('node:test');
const assert = require('node:assert/strict');

const {
  resolveCancelTarget,
  assertCancellable,
  refundKeyOf,
  cancelledOrderOf,
  cancelReasonOf,
} = require('./order_cancel');

test('uid를 넘기지 않으면 본인 주문 취소로 본다', () => {
  assert.deepEqual(
      resolveCancelTarget({
        data: {orderType: 'pickup', orderId: 'o1'},
        uid: 'me',
        isAdmin: false,
      }),
      {orderType: 'pickup', orderId: 'o1', uid: 'me', byAdmin: false},
  );
});

test('관리자는 다른 회원의 주문을 지정할 수 있다', () => {
  assert.deepEqual(
      resolveCancelTarget({
        data: {orderType: 'bean', orderId: 'o1', uid: 'guest'},
        uid: 'staff',
        isAdmin: true,
      }),
      {orderType: 'bean', orderId: 'o1', uid: 'guest', byAdmin: true},
  );
});

test('관리자가 아니면 다른 회원의 주문을 지정할 수 없다', () => {
  assert.throws(
      () => resolveCancelTarget({
        data: {orderType: 'bean', orderId: 'o1', uid: 'victim'},
        uid: 'me',
        isAdmin: false,
      }),
      /다른 회원의 주문은 취소할 수 없습니다/,
  );
});

test('주문 유형과 주문 번호를 검사한다', () => {
  assert.throws(
      () => resolveCancelTarget({data: {orderType: 'gift', orderId: 'o1'}}),
      /주문 유형이 올바르지 않습니다/,
  );
  assert.throws(
      () => resolveCancelTarget({data: {orderType: 'pickup'}}),
      /주문 번호/,
  );
});

test('고객은 접수 상태만 취소할 수 있다', () => {
  assert.doesNotThrow(() => assertCancellable({
    orderType: 'pickup',
    order: {status: 'received'},
    byAdmin: false,
  }));
  assert.throws(
      () => assertCancellable({
        orderType: 'pickup',
        order: {status: 'preparing'},
        byAdmin: false,
      }),
      /제조가 시작된 주문은 취소할 수 없습니다/,
  );
  assert.throws(
      () => assertCancellable({
        orderType: 'bean',
        order: {status: 'roasting'},
        byAdmin: false,
      }),
      /로스팅이 시작된 주문은 취소할 수 없습니다/,
  );
});

test('관리자는 진행 중인 주문도 취소할 수 있다', () => {
  for (const status of ['received', 'preparing', 'roasting', 'ready']) {
    assert.doesNotThrow(() => assertCancellable({
      orderType: 'pickup',
      order: {status},
      byAdmin: true,
    }));
  }
});

test('전달이 끝난 주문은 관리자도 취소할 수 없다', () => {
  for (const status of ['pickedUp', 'delivered', 'shipped']) {
    assert.throws(
        () => assertCancellable({
          orderType: 'bean',
          order: {status},
          byAdmin: true,
        }),
        /고객에게 전달된 주문은 취소할 수 없습니다/,
    );
  }
});

test('이미 취소된 주문과 상태 없는 주문은 막는다', () => {
  assert.throws(
      () => assertCancellable({
        orderType: 'pickup',
        order: {status: 'cancelled'},
        byAdmin: true,
      }),
      /이미 취소된 주문입니다/,
  );
  assert.throws(
      () => assertCancellable({orderType: 'pickup', order: {}, byAdmin: true}),
      /현재 주문 상태를 알 수 없습니다/,
  );
});

test('결제 키가 있어야 환불 대상이다', () => {
  assert.equal(refundKeyOf({paymentKey: 'pk_1'}), 'pk_1');
  assert.equal(refundKeyOf({paymentKey: ''}), null);
  assert.equal(refundKeyOf({}), null);
});

test('환불 대상 주문만 환불 상태를 남긴다', () => {
  assert.deepEqual(
      cancelledOrderOf({id: 'o1', status: 'received', paymentKey: 'pk_1'}),
      {id: 'o1', status: 'cancelled', paymentKey: 'pk_1',
        refundStatus: 'pending'},
  );
  assert.deepEqual(
      cancelledOrderOf({id: 'o1', status: 'received', usedPoints: 5000}),
      {id: 'o1', status: 'cancelled', usedPoints: 5000},
  );
});

test('취소 사유에 주체와 주문 종류를 남긴다', () => {
  assert.equal(
      cancelReasonOf({byAdmin: true, orderType: 'pickup'}), '매장 픽업 주문 취소');
  assert.equal(
      cancelReasonOf({byAdmin: false, orderType: 'bean'}), '고객 원두 주문 취소');
});
