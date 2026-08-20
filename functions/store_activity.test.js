const test = require('node:test');
const assert = require('node:assert/strict');

const {
  congestionForCount,
  storeIdsToRecount,
  liveOrderCount,
  storeActivityDoc,
} = require('./store_activity');

test('진행 중인 주문 수를 혼잡도 세 단계로 나눈다', () => {
  assert.equal(congestionForCount(0), 'relaxed');
  assert.equal(congestionForCount(2), 'relaxed');
  assert.equal(congestionForCount(3), 'normal');
  assert.equal(congestionForCount(6), 'normal');
  assert.equal(congestionForCount(7), 'busy');
  assert.equal(congestionForCount(20), 'busy');
});

test('색인에서 아직 만들고 있는 주문만 센다', () => {
  const count = liveOrderCount([
    {status: 'received'},
    {status: 'preparing'},
    {status: 'ready'}, // 픽업대에 나온 주문은 바를 붙잡지 않는다
    null,
  ]);

  assert.equal(count, 2);
});

test('새 주문이 들어온 매장을 다시 센다', () => {
  const storeIds = storeIdsToRecount({
    beforeData: null,
    afterData: {orders: [{id: 'p1', status: 'received', storeId: 'macheon'}]},
  });

  assert.deepEqual(storeIds, ['macheon']);
});

test('상태가 그대로인 주문은 다시 세지 않는다', () => {
  const orders = [{id: 'p1', status: 'preparing', storeId: 'macheon'}];
  const storeIds = storeIdsToRecount({
    beforeData: {orders},
    afterData: {orders},
  });

  assert.deepEqual(storeIds, []);
});

test('여러 매장의 주문이 함께 바뀌면 매장마다 한 번씩만 센다', () => {
  const storeIds = storeIdsToRecount({
    beforeData: {
      orders: [
        {id: 'p1', status: 'received', storeId: 'macheon'},
        {id: 'p2', status: 'received', storeId: 'pangyo'},
        {id: 'p3', status: 'received', storeId: 'macheon'},
      ],
    },
    afterData: {
      orders: [
        {id: 'p1', status: 'preparing', storeId: 'macheon'},
        {id: 'p2', status: 'preparing', storeId: 'pangyo'},
        {id: 'p3', status: 'pickedUp', storeId: 'macheon'},
      ],
    },
  });

  assert.deepEqual(storeIds.sort(), ['macheon', 'pangyo']);
});

test('주문 문서가 통째로 사라져도 그 매장을 다시 센다', () => {
  const storeIds = storeIdsToRecount({
    beforeData: {orders: [{id: 'p1', status: 'preparing', storeId: 'macheon'}]},
    afterData: null,
  });

  assert.deepEqual(storeIds, ['macheon']);
});

test('매장을 알 수 없는 주문은 건너뛴다', () => {
  const storeIds = storeIdsToRecount({
    beforeData: null,
    afterData: {orders: [{id: 'p1', status: 'received'}, {status: 'received'}]},
  });

  assert.deepEqual(storeIds, []);
});

test('집계 문서에는 건수와 혼잡도, 잰 시각이 함께 들어간다', () => {
  assert.deepEqual(
      storeActivityDoc({count: 4, now: 'ts'}),
      {activeOrders: 4, congestion: 'normal', updatedAt: 'ts'},
  );
});
