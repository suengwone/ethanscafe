const test = require('node:test');
const assert = require('node:assert/strict');

const {
  FEED_LIMIT,
  orderFeedEntries,
  mergeFeedItems,
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
    route: '/profile/orders',
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
