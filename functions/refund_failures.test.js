const test = require('node:test');
const assert = require('node:assert/strict');

const {
  refundFailureId,
  refundFailureDoc,
  validateRetryRefundRequest,
  refundRetryDecision,
} = require('./refund_failures');

test('실패 문서 ID는 주문 유형·회원·주문을 합친다', () => {
  assert.equal(
      refundFailureId({orderType: 'pickup', uid: 'u1', orderId: 'p1'}),
      'pickup_u1_p1',
  );
});

test('실패 문서에 재시도와 확인에 필요한 값을 담는다', () => {
  assert.deepEqual(
      refundFailureDoc({
        orderType: 'bean',
        uid: 'u1',
        order: {
          id: 'b1',
          paymentKey: 'pk_1',
          summary: '에티오피아 예가체프',
          totalAmount: 30000,
          usedPoints: 5000,
        },
        failedAt: 'ts',
      }),
      {
        orderType: 'bean',
        uid: 'u1',
        orderId: 'b1',
        paymentKey: 'pk_1',
        summary: '에티오피아 예가체프',
        amount: 30000,
        usedPoints: 5000,
        failedAt: 'ts',
      },
  );
});

test('재시도 요청을 검증한다', () => {
  assert.deepEqual(
      validateRetryRefundRequest({
        orderType: 'pickup',
        uid: 'u1',
        orderId: 'p1',
      }),
      {orderType: 'pickup', uid: 'u1', orderId: 'p1'},
  );
  assert.throws(
      () => validateRetryRefundRequest({orderType: 'gift', uid: 'u1',
        orderId: 'p1'}),
      /주문 유형/,
  );
  assert.throws(
      () => validateRetryRefundRequest({orderType: 'pickup', orderId: 'p1'}),
      /회원 번호/,
  );
  assert.throws(
      () => validateRetryRefundRequest({orderType: 'pickup', uid: 'u1'}),
      /주문 번호/,
  );
});

test('이미 취소된 결제는 다시 취소하지 않는다', () => {
  assert.deepEqual(
      refundRetryDecision({status: 'CANCELED'}), {action: 'settled'});
});

test('아직 살아 있는 결제는 취소를 건다', () => {
  assert.deepEqual(refundRetryDecision({status: 'DONE'}), {action: 'cancel'});
  assert.deepEqual(refundRetryDecision(null), {action: 'cancel'});
  assert.deepEqual(refundRetryDecision({}), {action: 'cancel'});
});
