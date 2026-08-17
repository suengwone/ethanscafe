'use strict';

/**
 * 환불 실패 기록.
 *
 * 주문 취소는 확정됐는데 PG 환불만 실패한 건은 고객 돈이 묶여 있는 상태다.
 * 주문은 회원별 문서 안 배열이라 `refundStatus`로 질의할 수 없으므로, 실패한
 * 건만 문서 하나씩 떼어 두고 매장이 목록으로 보고 재시도할 수 있게 한다.
 * 환불이 끝나면 문서를 지운다.
 */

const COLLECTION = 'refund_failures';

/** 토스에서 이미 취소가 끝난 결제의 상태값. */
const CANCELED_STATUS = 'CANCELED';

function requireString(value, label) {
  if (typeof value !== 'string' || value.length === 0) {
    throw new Error(`${label}이(가) 올바르지 않습니다.`);
  }
  return value;
}

function refundFailureId({orderType, uid, orderId}) {
  return `${orderType}_${uid}_${orderId}`;
}

function refundFailureDoc({orderType, uid, order, failedAt}) {
  return {
    orderType,
    uid,
    orderId: order.id,
    paymentKey: order.paymentKey,
    summary: typeof order.summary === 'string' ? order.summary : null,
    amount: Number.isInteger(order.totalAmount) ? order.totalAmount : 0,
    usedPoints: Number.isInteger(order.usedPoints) ? order.usedPoints : 0,
    failedAt,
  };
}

function validateRetryRefundRequest(data) {
  const orderType = data && data.orderType;
  if (orderType !== 'bean' && orderType !== 'pickup') {
    throw new Error('주문 유형이 올바르지 않습니다.');
  }
  return {
    orderType,
    uid: requireString(data && data.uid, '회원 번호'),
    orderId: requireString(data && data.orderId, '주문 번호'),
  };
}

/**
 * 재시도할 결제인지 판단한다.
 *
 * 취소 요청이 PG에 닿았는데 응답만 못 받은 경우가 있어, 다시 취소를 걸기 전에
 * 조회 결과부터 본다. 이미 취소돼 있으면 성공으로 보고 재요청하지 않는다.
 */
function refundRetryDecision(payment) {
  if (!payment || typeof payment.status !== 'string') {
    return {action: 'cancel'};
  }
  if (payment.status === CANCELED_STATUS) {
    return {action: 'settled'};
  }
  return {action: 'cancel'};
}

module.exports = {
  COLLECTION,
  CANCELED_STATUS,
  refundFailureId,
  refundFailureDoc,
  validateRetryRefundRequest,
  refundRetryDecision,
};
