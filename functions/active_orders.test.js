const test = require('node:test');
const assert = require('node:assert/strict');

const {
  isClosed,
  activeOrderId,
  activeOrderDoc,
  collectActiveOrderWrites,
} = require('./active_orders');

const pickupOrder = {
  id: 'p1',
  status: 'received',
  pickupNumber: 12,
  storeId: 'macheon',
  storeName: '폭스트롯 마천점',
  totalAmount: 11600,
  createdAt: 'ts',
  items: [{menuName: '바닐라 라떼'}],
};

test('처리가 끝난 상태만 닫힌 주문으로 본다', () => {
  assert.equal(isClosed({status: 'pickedUp'}), true);
  assert.equal(isClosed({status: 'delivered'}), true);
  assert.equal(isClosed({status: 'cancelled'}), true);
  assert.equal(isClosed({status: 'preparing'}), false);
});

test('색인 문서 ID는 주문 유형·회원·주문을 합친다', () => {
  assert.equal(
      activeOrderId({orderType: 'pickup', uid: 'u1', orderId: 'p1'}),
      'pickup_u1_p1',
  );
});

test('픽업 주문은 픽업 번호와 매장을 담는다', () => {
  assert.deepEqual(
      activeOrderDoc({orderType: 'pickup', uid: 'u1', order: pickupOrder}),
      {
        orderType: 'pickup',
        uid: 'u1',
        orderId: 'p1',
        status: 'received',
        summary: '바닐라 라떼',
        totalAmount: 11600,
        createdAt: 'ts',
        pickupNumber: 12,
        storeId: 'macheon',
        storeName: '폭스트롯 마천점',
      },
  );
});

test('원두 주문은 수령 방법과 수령인을 담는다', () => {
  const doc = activeOrderDoc({
    orderType: 'bean',
    uid: 'u1',
    order: {
      id: 'b1',
      status: 'roasting',
      fulfillmentMethod: 'delivery',
      recipient: '이단',
      totalAmount: 30000,
      items: [{beanName: '에티오피아 예가체프'}],
    },
  });
  assert.equal(doc.fulfillmentMethod, 'delivery');
  assert.equal(doc.recipient, '이단');
  assert.equal(doc.summary, '에티오피아 예가체프');
});

test('새로 들어온 주문은 색인에 추가한다', () => {
  const writes = collectActiveOrderWrites({
    orderType: 'pickup',
    uid: 'u1',
    beforeData: null,
    afterData: {orders: [pickupOrder]},
  });

  assert.equal(writes.length, 1);
  assert.equal(writes[0].type, 'set');
  assert.equal(writes[0].id, 'pickup_u1_p1');
  assert.equal(writes[0].doc.status, 'received');
});

test('상태가 그대로면 아무것도 쓰지 않는다', () => {
  assert.deepEqual(
      collectActiveOrderWrites({
        orderType: 'pickup',
        uid: 'u1',
        beforeData: {orders: [pickupOrder]},
        afterData: {orders: [{...pickupOrder, refundStatus: 'done'}]},
      }),
      [],
  );
});

test('상태가 진행되면 색인을 갱신한다', () => {
  const writes = collectActiveOrderWrites({
    orderType: 'pickup',
    uid: 'u1',
    beforeData: {orders: [pickupOrder]},
    afterData: {orders: [{...pickupOrder, status: 'preparing'}]},
  });

  assert.equal(writes.length, 1);
  assert.equal(writes[0].type, 'set');
  assert.equal(writes[0].doc.status, 'preparing');
});

test('픽업이 끝나거나 취소되면 색인에서 지운다', () => {
  for (const status of ['pickedUp', 'cancelled']) {
    const writes = collectActiveOrderWrites({
      orderType: 'pickup',
      uid: 'u1',
      beforeData: {orders: [pickupOrder]},
      afterData: {orders: [{...pickupOrder, status}]},
    });
    assert.deepEqual(writes, [{type: 'delete', id: 'pickup_u1_p1'}]);
  }
});

test('주문 문서가 통째로 사라지면 남은 색인을 지운다', () => {
  assert.deepEqual(
      collectActiveOrderWrites({
        orderType: 'bean',
        uid: 'u1',
        beforeData: {orders: [{id: 'b1', status: 'roasting', items: []}]},
        afterData: null,
      }),
      [{type: 'delete', id: 'bean_u1_b1'}],
  );
});

test('여러 주문 중 바뀐 것만 반영한다', () => {
  const other = {id: 'p2', status: 'preparing', items: []};
  const writes = collectActiveOrderWrites({
    orderType: 'pickup',
    uid: 'u1',
    beforeData: {orders: [pickupOrder, other]},
    afterData: {orders: [pickupOrder, {...other, status: 'ready'}]},
  });

  assert.equal(writes.length, 1);
  assert.equal(writes[0].id, 'pickup_u1_p2');
});
