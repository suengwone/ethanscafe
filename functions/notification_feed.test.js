const test = require('node:test');
const assert = require('node:assert/strict');

const {
  FEED_LIMIT,
  isPushAllowed,
  orderFeedEntries,
  newPointHistoryEntries,
  pointsFeedEntries,
  mergeFeedItems,
  newFeedItems,
  POINTS_BURST_LIMIT,
} = require('./notification_feed');

const createdAt = new Date('2026-08-30T09:00:00.000Z');

test('주문 상태 알림을 알림함 항목으로 옮긴다', () => {
  const entries = orderFeedEntries({
    notifications: [
      {
        orderId: 'order-1',
        status: 'ready',
        title: '주문하신 음료가 나왔어요',
        body: '바닐라 라떼 주문을 픽업대에서 찾아가세요.',
      },
    ],
    orderType: 'bean',
    createdAt,
  });

  assert.deepEqual(entries, [
    {
      id: 'order-1:ready',
      title: '주문하신 음료가 나왔어요',
      body: '바닐라 라떼 주문을 픽업대에서 찾아가세요.',
      category: 'order',
      route: '/profile/orders',
      createdAt,
      isRead: false,
    },
  ]);
});

test('새 항목이 앞에 붙는다', () => {
  const merged = mergeFeedItems(
      [{id: 'order-1:preparing', isRead: true}],
      [{id: 'order-1:ready', isRead: false}],
  );

  assert.deepEqual(merged.map((item) => item.id), [
    'order-1:ready',
    'order-1:preparing',
  ]);
});

test('트리거가 두 번 돌아도 읽음 표시를 되돌리지 않는다', () => {
  const merged = mergeFeedItems(
      [{id: 'order-1:ready', isRead: true}],
      [{id: 'order-1:ready', isRead: false}],
  );

  assert.equal(merged.length, 1);
  assert.equal(merged[0].isRead, true);
});

test('오래된 알림은 한도 밖으로 밀려난다', () => {
  const existing = Array.from({length: FEED_LIMIT}, (_, index) => ({
    id: `old-${index}`,
  }));

  const merged = mergeFeedItems(existing, [{id: 'new-1'}]);

  assert.equal(merged.length, FEED_LIMIT);
  assert.equal(merged[0].id, 'new-1');
  assert.equal(merged.at(-1).id, `old-${FEED_LIMIT - 2}`);
});

test('알림함이 비어 있어도 새 항목을 담는다', () => {
  assert.deepEqual(
      mergeFeedItems(undefined, [{id: 'order-1:ready'}]),
      [{id: 'order-1:ready'}],
  );
});

test('픽업 주문 알림은 추적 화면으로, 원두 주문 알림은 주문 내역으로 보낸다', () => {
  const notifications = [
    {orderId: 'p1', status: 'ready', title: '제목', body: '본문'},
  ];

  assert.equal(
      orderFeedEntries({notifications, orderType: 'pickup', createdAt})[0].route,
      '/profile/orders/track/p1',
  );
  assert.equal(
      orderFeedEntries({notifications, orderType: 'bean', createdAt})[0].route,
      '/profile/orders',
  );
});

test('푸시를 끄면 어떤 분류도 보내지 않는다', () => {
  assert.equal(isPushAllowed({pushEnabled: false}, 'order'), false);
  assert.equal(isPushAllowed({pushEnabled: false}, 'points'), false);
});

test('포인트 알림만 따로 끌 수 있다', () => {
  const settings = {pushEnabled: true, pointsEnabled: false};

  assert.equal(isPushAllowed(settings, 'points'), false);
  // 주문 상태는 돈과 물건이 걸린 일이라 따로 끄지 못한다.
  assert.equal(isPushAllowed(settings, 'order'), true);
});

test('설정 문서가 없으면 보낸다', () => {
  assert.equal(isPushAllowed(undefined, 'points'), true);
  assert.equal(isPushAllowed({}, 'points'), true);
});

test('이번 쓰기에서 앞에 붙은 포인트 이력만 새 것으로 본다', () => {
  const before = {history: [{id: 'b'}, {id: 'c'}]};
  const after = {history: [{id: 'a2'}, {id: 'a1'}, {id: 'b'}, {id: 'c'}]};

  assert.deepEqual(
      newPointHistoryEntries(before, after).map((entry) => entry.id),
      ['a2', 'a1'],
  );
});

test('포인트 문서가 처음 생기면 붙은 이력이 모두 새 것이다', () => {
  assert.deepEqual(
      newPointHistoryEntries(null, {history: [{id: 'a'}]}).map((e) => e.id),
      ['a'],
  );
  assert.deepEqual(newPointHistoryEntries(null, {history: []}), []);
  assert.deepEqual(newPointHistoryEntries(null, null), []);
});

test('주문 결제로 쓰고 모은 포인트는 알림 하나로 묶는다', () => {
  const items = pointsFeedEntries({
    entries: [
      {id: 'e1', type: 'earn', description: '픽업 주문', amount: 320},
      {id: 'u1', type: 'use', description: '픽업 주문 포인트 사용', amount: -500},
    ],
    balance: 4820,
    createdAt,
  });

  assert.equal(items.length, 1);
  assert.equal(items[0].id, 'points:e1');
  assert.equal(items[0].category, 'points');
  assert.equal(items[0].route, '/points');
  assert.equal(items[0].title, '포인트가 적립됐어요');
  assert.equal(
      items[0].body,
      '픽업 주문으로 500P를 쓰고 320P를 모았어요. 지금 잔액은 4,820P예요.',
  );
});

test('적립만 있으면 적립 알림 하나를 만든다', () => {
  const items = pointsFeedEntries({
    entries: [
      {id: 'e1', type: 'earn', description: '매장 결제', amount: 450},
    ],
    balance: 5270,
    createdAt,
  });

  assert.equal(items.length, 1);
  assert.equal(
      items[0].body,
      '매장 결제로 450P를 모았어요. 지금 잔액은 5,270P예요.',
  );
});

test('충전은 보너스를 함께 알린다', () => {
  const [item] = pointsFeedEntries({
    entries: [
      {
        id: 'c1',
        type: 'charge',
        description: '선불권 충전',
        amount: 55000,
        bonusAmount: 5000,
      },
    ],
    balance: 55000,
    createdAt,
  });

  assert.equal(item.title, '포인트를 충전했어요');
  assert.equal(
      item.body,
      '보너스 5,000P를 더해 55,000P가 들어왔어요. 지금 잔액은 55,000P예요.',
  );
});

test('주문 취소로 돌려준 포인트는 알리지 않는다', () => {
  // 취소 알림이 이미 "사용하신 포인트와 쿠폰은 돌려드렸어요"라고 말한다.
  assert.deepEqual(
      pointsFeedEntries({
        entries: [
          {
            id: 'r1',
            type: 'earn',
            description: '픽업 주문 취소 포인트 환급',
            amount: 500,
            cancelled: true,
          },
        ],
        balance: 5000,
        createdAt,
      }),
      [],
  );
});

test('설명에 취소가 들어갔다고 알림을 삼키지 않는다', () => {
  // 사용 설명은 사용자가 적는다. 문구로 가려내면 멀쩡한 알림이 사라진다.
  const items = pointsFeedEntries({
    entries: [
      {id: 'u1', type: 'use', description: '예약 취소 수수료', amount: -1000},
    ],
    balance: 4000,
    createdAt,
  });

  assert.equal(items.length, 1);
  assert.equal(items[0].title, '포인트를 사용했어요');
});

test('이미 알림함에 있는 항목은 새 것으로 치지 않는다', () => {
  const added = newFeedItems(
      [{id: 'a'}, {id: 'b'}],
      [{id: 'b'}, {id: 'c'}],
  );

  assert.deepEqual(added.map((item) => item.id), ['c']);
  assert.deepEqual(newFeedItems(undefined, [{id: 'a'}]).map((i) => i.id), ['a']);
});

test('포인트 이력이 한 번에 쏟아지면 알림 수를 막는다', () => {
  const history = Array.from({length: 20}, (_, index) => ({id: `n${index}`}));

  const fresh = newPointHistoryEntries({history: []}, {history});

  assert.equal(fresh.length, POINTS_BURST_LIMIT);
  assert.equal(fresh[0].id, 'n0');
});

test('묶이지 않는 여러 이력은 각자 그때의 잔액을 말한다', () => {
  const items = pointsFeedEntries({
    entries: [
      {id: 'e2', type: 'earn', description: '친구 초대 보상', amount: 3000},
      {id: 'e1', type: 'earn', description: '매장 결제', amount: 200},
    ],
    balance: 8200,
    createdAt,
  });

  assert.equal(items.length, 2);
  assert.match(items[0].body, /지금 잔액은 8,200P예요\./);
  // 초대 보상이 붙기 전 잔액은 5,200P였다.
  assert.match(items[1].body, /지금 잔액은 5,200P예요\./);
});

test('받침에 따라 조사를 고른다', () => {
  const body = (description) =>
    pointsFeedEntries({
      entries: [{id: 'e', type: 'earn', description, amount: 100}],
      balance: 100,
      createdAt,
    })[0].body;

  assert.match(body('픽업 주문'), /^픽업 주문으로 /); // 받침 ㄴ
  assert.match(body('매장 결제'), /^매장 결제로 /); // 받침 없음
  assert.match(body('가을'), /^가을로 /); // ㄹ 받침은 `로`
});
