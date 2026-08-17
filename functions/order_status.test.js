const test = require('node:test');
const assert = require('node:assert/strict');

const {
  collectStatusChangeNotifications,
  orderSummary,
  PICKUP_STATUS_MESSAGES,
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
  const after = {orders: [order('o1', 'pickedUp')]};

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
  // 원두·픽업 양쪽에서 쓰이므로 상품이 없을 때는 중립적인 기본값을 쓴다.
  assert.equal(orderSummary({id: 'o1', status: 'shipped'}), '주문');
});

test('픽업 주문은 메뉴명으로 요약한다', () => {
  assert.equal(
    orderSummary({id: 'p1', items: [{menuName: '바닐라 라떼'}]}),
    '바닐라 라떼',
  );
  assert.equal(
    orderSummary({
      id: 'p1',
      items: [{menuName: '바닐라 라떼'}, {menuName: '플레인 베이글'}],
    }),
    '바닐라 라떼 외 1건',
  );
});

test('픽업 상태 변경은 픽업 전용 메시지로 수집한다', () => {
  const before = {orders: [{id: 'p1', status: 'received', items: [{menuName: '바닐라 라떼'}]}]};
  const after = {orders: [{id: 'p1', status: 'ready', items: [{menuName: '바닐라 라떼'}]}]};

  const notifications = collectStatusChangeNotifications(
    before, after, PICKUP_STATUS_MESSAGES,
  );

  assert.equal(notifications.length, 1);
  assert.equal(notifications[0].status, 'ready');
  assert.equal(notifications[0].title, '주문하신 음료가 나왔어요');
  assert.match(notifications[0].body, /바닐라 라떼/);
});

test('픽업 메시지 표에 없는 상태는 알리지 않는다', () => {
  const before = {orders: [{id: 'p1', status: 'ready', items: []}]};
  const after = {orders: [{id: 'p1', status: 'pickedUp', items: []}]};

  assert.deepEqual(
    collectStatusChangeNotifications(before, after, PICKUP_STATUS_MESSAGES),
    [],
  );
});

test('매장이 취소한 픽업 주문도 고객에게 알린다', () => {
  const items = [{menuName: '바닐라 라떼'}];
  const before = {orders: [{id: 'p1', status: 'preparing', items}]};
  const after = {
    orders: [{id: 'p1', status: 'cancelled', items, paymentKey: 'pk_1'}],
  };

  const notifications = collectStatusChangeNotifications(
    before, after, PICKUP_STATUS_MESSAGES,
  );

  assert.equal(notifications.length, 1);
  assert.equal(notifications[0].title, '주문이 취소됐어요');
  assert.match(notifications[0].body, /환불됩니다/);
});

test('결제 없이 치른 주문의 취소 알림은 환불을 말하지 않는다', () => {
  const before = {orders: [{id: 'b1', status: 'received', items: []}]};
  const after = {orders: [{id: 'b1', status: 'cancelled', items: []}]};

  const notifications = collectStatusChangeNotifications(before, after);

  assert.equal(notifications.length, 1);
  assert.match(notifications[0].body, /포인트와 쿠폰은 돌려드렸어요/);
});

test('매장 수령 원두가 준비되면 알린다', () => {
  const items = [{beanName: '에티오피아 예가체프'}];
  const before = {orders: [{id: 'b1', status: 'roasting', items}]};
  const after = {orders: [{id: 'b1', status: 'ready', items}]};

  const notifications = collectStatusChangeNotifications(before, after);

  assert.equal(notifications.length, 1);
  assert.equal(notifications[0].title, '원두가 준비됐어요');
});
