'use strict';

/**
 * 주문 취소 규칙.
 *
 * 고객은 접수 직후에만 스스로 취소할 수 있다. 매장(관리자)은 품절이나 설비 고장처럼
 * 진행 중에 생기는 사유가 있어 이미 시작된 단계도 취소할 수 있지만, 고객에게 이미
 * 넘어간 주문(픽업 완료·배송 완료)과 택배로 넘긴 주문(발송 완료)은 앱에서 되돌릴 수 없다.
 */

const OWNER_CANCELLABLE = ['received'];
const ADMIN_CANCELLABLE = ['received', 'preparing', 'roasting', 'ready'];

/** 환불 진행 상태. 주문 문서에 남겨 실패한 환불을 놓치지 않게 한다. */
const REFUND_PENDING = 'pending';
const REFUND_DONE = 'done';
const REFUND_FAILED = 'failed';

function requireString(value, label) {
  if (typeof value !== 'string' || value.length === 0) {
    throw new Error(`${label}이(가) 올바르지 않습니다.`);
  }
  return value;
}

/**
 * 취소 요청이 가리키는 주문의 주인과 권한을 정한다.
 *
 * `uid`를 넘기지 않으면 본인 주문을 취소하는 것으로 본다. 다른 회원의 주문은
 * 관리자만 지정할 수 있고, 이때만 관리자 권한의 취소로 취급한다.
 */
function resolveCancelTarget({data, uid, isAdmin}) {
  const orderType = data && data.orderType;
  if (orderType !== 'bean' && orderType !== 'pickup') {
    throw new Error('주문 유형이 올바르지 않습니다.');
  }
  const orderId = requireString(data && data.orderId, '주문 번호');
  const targetUid = data && data.uid;
  if (targetUid === undefined || targetUid === null) {
    return {orderType, orderId, uid, byAdmin: false};
  }
  requireString(targetUid, '회원 번호');
  if (!isAdmin) {
    throw new Error('다른 회원의 주문은 취소할 수 없습니다.');
  }
  return {orderType, orderId, uid: targetUid, byAdmin: true};
}

/** 취소할 수 없는 상태면 사유를 담아 예외를 던진다. */
function assertCancellable({orderType, order, byAdmin}) {
  if (!order || typeof order.status !== 'string') {
    throw new Error('현재 주문 상태를 알 수 없습니다.');
  }
  if (order.status === 'cancelled') {
    throw new Error('이미 취소된 주문입니다.');
  }
  const allowed = byAdmin ? ADMIN_CANCELLABLE : OWNER_CANCELLABLE;
  if (allowed.includes(order.status)) {
    return;
  }
  if (byAdmin) {
    throw new Error('고객에게 전달된 주문은 취소할 수 없습니다.');
  }
  throw new Error(orderType === 'bean' ?
    '로스팅이 시작된 주문은 취소할 수 없습니다.' :
    '제조가 시작된 주문은 취소할 수 없습니다.');
}

/**
 * 환불해야 할 결제 키. 포인트·쿠폰으로 전액을 치른 주문은 결제 키가 없어 환불 대상이 아니다.
 */
function refundKeyOf(order) {
  const key = order && order.paymentKey;
  return typeof key === 'string' && key.length > 0 ? key : null;
}

/** 취소된 주문 문서. 환불 대상이면 결과를 확인하기 전까지 `pending`으로 둔다. */
function cancelledOrderOf(order) {
  const cancelled = {...order, status: 'cancelled'};
  if (refundKeyOf(order)) {
    cancelled.refundStatus = REFUND_PENDING;
  }
  return cancelled;
}

function cancelReasonOf({byAdmin, orderType}) {
  const subject = byAdmin ? '매장' : '고객';
  const label = orderType === 'bean' ? '원두 주문' : '픽업 주문';
  return `${subject} ${label} 취소`;
}

module.exports = {
  OWNER_CANCELLABLE,
  ADMIN_CANCELLABLE,
  REFUND_PENDING,
  REFUND_DONE,
  REFUND_FAILED,
  resolveCancelTarget,
  assertCancellable,
  refundKeyOf,
  cancelledOrderOf,
  cancelReasonOf,
};
