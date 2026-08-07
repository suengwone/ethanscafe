const test = require('node:test');
const assert = require('node:assert/strict');

const {
  collectStatusChangeNotifications,
  orderSummary,
} = require('./order_status');

const order = (id, status, items) => ({
  id,
  status,
  items:
    items ?? [
      {beanId: 'bean-1', beanName: '에티오피아 예가체프', quantity: 1},
    ],
});

test('상태가 바뀐 주문만 알림 대상으로 수집한다', () => {
  const before = {orders: [order('o1', 'received'), order('o2', 'roasting')]};
  const after = {orders: [order('o1', 'roasting'), order('o2', 'roasting')]};

  const notifications = collectStatusChangeNotifications(before, after);

  assert.equal(notifications.length, 1);
  assert.equal(notifications[0].orderId, 'o1');
  assert.equal(notifications[0].status, 'roasting');
  assert.ok(notifications[0].title.length > 0);
  assert.ok(notifications[0].body.includes('에티오피아 예가체프'));
});

test('신규 생성된 주문(주문 접수)은 알림을 보내지 않는다', () => {
  const before = {orders: []};
  const after = {orders: [order('o1', 'received')]};

  assert.deepEqual(collectStatusChangeNotifications(before, after), []);
});

test('문서가 처음 생성된 경우에도 알림을 보내지 않는다', () => {
  const after = {orders: [order('o1', 'received')]};

  assert.deepEqual(collectStatusChangeNotifications(null, after), []);
});

test('알 수 없는 상태로 바뀌면 알림을 보내지 않는다', () => {
  const before = {orders: [order('o1', 'received')]};
  const after = {orders: [order('o1', 'cancelled')]};

  assert.deepEqual(collectStatusChangeNotifications(before, after), []);
});

test('shipped/delivered 상태 변경도 알림을 수집한다', () => {
  const before = {orders: [order('o1', 'roasting'), order('o2', 'shipped')]};
  const after = {orders: [order('o1', 'shipped'), order('o2', 'delivered')]};

  const notifications = collectStatusChangeNotifications(before, after);

  assert.deepEqual(
    notifications.map((n) => [n.orderId, n.status]),
    [
      ['o1', 'shipped'],
      ['o2', 'delivered'],
    ],
  );
});

test('주문 요약은 첫 상품명과 나머지 건수를 표시한다', () => {
  assert.equal(orderSummary(order('o1', 'shipped')), '에티오피아 예가체프');
  assert.equal(
    orderSummary(
      order('o1', 'shipped', [
        {beanName: '에티오피아 예가체프'},
        {beanName: '브라질 옐로우버본'},
        {beanName: '과테말라 안티구아'},
      ]),
    ),
    '에티오피아 예가체프 외 2건',
  );
  assert.equal(orderSummary({id: 'o1', status: 'shipped'}), '원두');
});
