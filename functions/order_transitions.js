// 주문 상태 전환 규칙.
// 되돌리기와 단계 건너뛰기를 막는다. 취소는 cancelOrder 콜러블만 처리하므로
// 이 흐름에는 포함하지 않는다.

const PICKUP_FLOW = ['received', 'preparing', 'ready', 'pickedUp'];
const BEAN_DELIVERY_FLOW = ['received', 'roasting', 'shipped', 'delivered'];
const BEAN_PICKUP_FLOW = ['received', 'roasting', 'ready', 'pickedUp'];

/** 원두 주문은 수령 방법(배송/픽업)에 따라 흐름이 갈린다. */
function orderFlow(orderType, order) {
  if (orderType === 'pickup') {
    return PICKUP_FLOW;
  }
  return order && order.fulfillmentMethod === 'pickup' ?
    BEAN_PICKUP_FLOW :
    BEAN_DELIVERY_FLOW;
}

/** 다음 단계. 마지막 단계이거나 상태를 알 수 없으면 null. */
function nextStatusOf(orderType, order) {
  const flow = orderFlow(orderType, order);
  const index = flow.indexOf(order && order.status);
  if (index === -1 || index === flow.length - 1) {
    return null;
  }
  return flow[index + 1];
}

function validateStatusTransition({orderType, order, nextStatus}) {
  if (!order) {
    throw new Error('주문을 찾을 수 없습니다.');
  }
  if (order.status === 'cancelled') {
    throw new Error('취소된 주문은 상태를 바꿀 수 없습니다.');
  }
  const flow = orderFlow(orderType, order);
  const from = flow.indexOf(order.status);
  const to = flow.indexOf(nextStatus);
  if (from === -1) {
    throw new Error('현재 주문 상태를 알 수 없습니다.');
  }
  if (to === -1) {
    throw new Error('이 주문에 적용할 수 없는 상태입니다.');
  }
  if (to === from) {
    throw new Error('이미 해당 상태입니다.');
  }
  if (to < from) {
    throw new Error('이전 단계로 되돌릴 수 없습니다.');
  }
  if (to > from + 1) {
    throw new Error('단계를 건너뛸 수 없습니다.');
  }
  return nextStatus;
}

function validateUpdateOrderStatusRequest(data) {
  const orderType = data && data.orderType;
  if (orderType !== 'bean' && orderType !== 'pickup') {
    throw new Error('주문 유형이 올바르지 않습니다.');
  }
  const uid = data.uid;
  if (typeof uid !== 'string' || uid.length === 0 || uid.length > 128) {
    throw new Error('회원 정보가 올바르지 않습니다.');
  }
  const orderId = data.orderId;
  if (typeof orderId !== 'string' || orderId.length === 0 ||
      orderId.length > 200) {
    throw new Error('주문 번호가 올바르지 않습니다.');
  }
  const status = data.status;
  const known = new Set([
    ...PICKUP_FLOW, ...BEAN_DELIVERY_FLOW, ...BEAN_PICKUP_FLOW,
  ]);
  if (typeof status !== 'string' || !known.has(status)) {
    throw new Error('변경할 상태가 올바르지 않습니다.');
  }
  return {orderType, uid, orderId, status};
}

module.exports = {
  PICKUP_FLOW,
  BEAN_DELIVERY_FLOW,
  BEAN_PICKUP_FLOW,
  orderFlow,
  nextStatusOf,
  validateStatusTransition,
  validateUpdateOrderStatusRequest,
};
