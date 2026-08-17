const test = require('node:test');
const assert = require('node:assert/strict');

const {
  orderFlow,
  nextStatusOf,
  validateStatusTransition,
  validateUpdateOrderStatusRequest,
} = require('./order_transitions');

test('픽업 주문은 접수 → 제조 → 픽업대기 → 픽업완료 순서다', () => {
  assert.deepEqual(orderFlow('pickup', {}), [
    'received', 'preparing', 'ready', 'pickedUp',
  ]);
});

test('원두 배송 주문과 픽업 주문은 흐름이 다르다', () => {
  assert.deepEqual(orderFlow('bean', {fulfillmentMethod: 'delivery'}), [
    'received', 'roasting', 'shipped', 'delivered',
  ]);
  assert.deepEqual(orderFlow('bean', {fulfillmentMethod: 'pickup'}), [
    'received', 'roasting', 'ready', 'pickedUp',
  ]);
});

test('수령 방법이 없는 원두 주문은 배송 흐름으로 본다', () => {
  assert.deepEqual(orderFlow('bean', {}), [
    'received', 'roasting', 'shipped', 'delivered',
  ]);
});

test('다음 단계를 알려준다', () => {
  assert.equal(nextStatusOf('pickup', {status: 'received'}), 'preparing');
  assert.equal(nextStatusOf('pickup', {status: 'ready'}), 'pickedUp');
  assert.equal(
      nextStatusOf('bean', {status: 'roasting', fulfillmentMethod: 'delivery'}),
      'shipped',
  );
});

test('마지막 단계이거나 알 수 없는 상태면 다음 단계가 없다', () => {
  assert.equal(nextStatusOf('pickup', {status: 'pickedUp'}), null);
  assert.equal(nextStatusOf('pickup', {status: 'cancelled'}), null);
  assert.equal(nextStatusOf('pickup', {}), null);
});

test('한 단계 진행은 허용한다', () => {
  assert.equal(
      validateStatusTransition({
        orderType: 'pickup',
        order: {status: 'received'},
        nextStatus: 'preparing',
      }),
      'preparing',
  );
});

test('단계를 건너뛸 수 없다', () => {
  assert.throws(() => validateStatusTransition({
    orderType: 'pickup',
    order: {status: 'received'},
    nextStatus: 'ready',
  }), /건너뛸 수 없습니다/);
});

test('이전 단계로 되돌릴 수 없다', () => {
  assert.throws(() => validateStatusTransition({
    orderType: 'pickup',
    order: {status: 'ready'},
    nextStatus: 'preparing',
  }), /되돌릴 수 없습니다/);
});

test('같은 상태로는 바꿀 수 없다', () => {
  assert.throws(() => validateStatusTransition({
    orderType: 'pickup',
    order: {status: 'ready'},
    nextStatus: 'ready',
  }), /이미 해당 상태/);
});

test('취소된 주문은 상태를 바꿀 수 없다', () => {
  assert.throws(() => validateStatusTransition({
    orderType: 'pickup',
    order: {status: 'cancelled'},
    nextStatus: 'preparing',
  }), /취소된 주문/);
});

test('다른 흐름의 상태는 적용할 수 없다', () => {
  // 픽업 주문에 원두 전용 상태를 넣는 경우
  assert.throws(() => validateStatusTransition({
    orderType: 'pickup',
    order: {status: 'received'},
    nextStatus: 'roasting',
  }), /적용할 수 없는 상태/);
  // 배송 원두 주문에 픽업 전용 상태를 넣는 경우
  assert.throws(() => validateStatusTransition({
    orderType: 'bean',
    order: {status: 'roasting', fulfillmentMethod: 'delivery'},
    nextStatus: 'ready',
  }), /적용할 수 없는 상태/);
});

test('주문이 없으면 거부한다', () => {
  assert.throws(() => validateStatusTransition({
    orderType: 'pickup',
    order: null,
    nextStatus: 'preparing',
  }), /주문을 찾을 수 없습니다/);
});

test('요청 검증은 필수 필드를 확인한다', () => {
  const ok = validateUpdateOrderStatusRequest({
    orderType: 'pickup', uid: 'u1', orderId: 'o1', status: 'preparing',
  });
  assert.deepEqual(ok, {
    orderType: 'pickup', uid: 'u1', orderId: 'o1', status: 'preparing',
  });

  assert.throws(() => validateUpdateOrderStatusRequest({
    orderType: 'x', uid: 'u1', orderId: 'o1', status: 'preparing',
  }), /주문 유형/);
  assert.throws(() => validateUpdateOrderStatusRequest({
    orderType: 'pickup', uid: '', orderId: 'o1', status: 'preparing',
  }), /회원 정보/);
  assert.throws(() => validateUpdateOrderStatusRequest({
    orderType: 'pickup', uid: 'u1', orderId: '', status: 'preparing',
  }), /주문 번호/);
  assert.throws(() => validateUpdateOrderStatusRequest({
    orderType: 'pickup', uid: 'u1', orderId: 'o1', status: 'cancelled',
  }), /변경할 상태/);
});
