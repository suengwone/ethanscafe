const TOSS_CONFIRM_URL = 'https://api.tosspayments.com/v1/payments/confirm';
const TOSS_PAYMENTS_URL = 'https://api.tosspayments.com/v1/payments';

const ORDER_ID_PATTERN = /^[A-Za-z0-9_-]{6,64}$/;

function validateConfirmRequest(data) {
  const paymentKey = data && data.paymentKey;
  const orderId = data && data.orderId;
  const amount = data && data.amount;

  if (typeof paymentKey !== 'string' || paymentKey.length === 0) {
    throw new Error('paymentKey가 올바르지 않습니다.');
  }
  if (typeof orderId !== 'string' || !ORDER_ID_PATTERN.test(orderId)) {
    throw new Error('orderId가 올바르지 않습니다.');
  }
  if (!Number.isInteger(amount) || amount <= 0) {
    throw new Error('amount가 올바르지 않습니다.');
  }
  return {paymentKey, orderId, amount};
}

function toApprovalPayload(payment, requestedAmount) {
  if (!payment || payment.totalAmount !== requestedAmount) {
    throw new Error('결제 승인 금액이 요청 금액과 일치하지 않습니다.');
  }
  return {
    paymentKey: payment.paymentKey,
    orderId: payment.orderId,
    amount: payment.totalAmount,
    method: typeof payment.method === 'string' ? payment.method : '카드',
    approvedAt: typeof payment.approvedAt === 'string' ? payment.approvedAt : null,
    receiptUrl:
      payment.receipt && typeof payment.receipt.url === 'string' ?
        payment.receipt.url :
        null,
  };
}

function basicAuthHeader(secretKey) {
  return 'Basic ' + Buffer.from(`${secretKey}:`).toString('base64');
}

function paymentLookupUrl(paymentKey) {
  return `${TOSS_PAYMENTS_URL}/${encodeURIComponent(paymentKey)}`;
}

function paymentCancelUrl(paymentKey) {
  return `${TOSS_PAYMENTS_URL}/${encodeURIComponent(paymentKey)}/cancel`;
}

function verifyPaymentForOrder(payment, {orderId, amount}) {
  if (!payment || payment.status !== 'DONE') {
    throw new Error('완료되지 않은 결제입니다.');
  }
  if (payment.orderId !== orderId) {
    throw new Error('결제 주문번호가 일치하지 않습니다.');
  }
  if (payment.totalAmount !== amount) {
    throw new Error('결제 승인 금액이 주문 금액과 일치하지 않습니다.');
  }
  return {
    paymentKey: payment.paymentKey,
    orderId: payment.orderId,
    amount: payment.totalAmount,
    method: typeof payment.method === 'string' ? payment.method : '카드',
  };
}

module.exports = {
  TOSS_CONFIRM_URL,
  TOSS_PAYMENTS_URL,
  validateConfirmRequest,
  toApprovalPayload,
  basicAuthHeader,
  paymentLookupUrl,
  paymentCancelUrl,
  verifyPaymentForOrder,
};
