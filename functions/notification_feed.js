// 푸시는 기기에 한 번 뜨고 사라진다. 앱 안에서 다시 볼 수 있도록 같은 내용을
// 사용자 문서 하나(`notifications/{uid}`)에 배열로 쌓아 둔다.
//
// 배열을 고른 까닭: 알림함은 한 사람 것을 통째로 읽고, 회원 탈퇴 때 문서 하나만
// 지우면 되고, 모두 읽음도 쓰기 한 번이면 끝나기 때문이다. 대신 무한정 늘면
// 문서 크기 한도에 부딪히므로 최근 것만 남긴다.
const FEED_LIMIT = 50;

/** 알림함 항목의 분류. 클라이언트 enum과 이름을 맞춘다. */
const FEED_CATEGORIES = ['order', 'points', 'gift', 'event'];

/**
 * 주문 상태 알림을 알림함 항목으로 옮긴다.
 *
 * id를 `주문id:상태`로 박아 트리거가 두 번 돌아도 같은 항목이 겹치지 않게 한다.
 */
function orderFeedEntries({notifications, route, createdAt}) {
  return notifications.map((notification) => ({
    id: `${notification.orderId}:${notification.status}`,
    title: notification.title,
    body: notification.body,
    category: 'order',
    route,
    createdAt,
    isRead: false,
  }));
}

/**
 * 이미 쌓인 항목과 새 항목을 합친다.
 *
 * 같은 id가 이미 있으면 **기존 것을 남긴다**. 사용자가 읽음으로 바꿔 둔 표시를
 * 트리거 재실행이 되돌리지 않게 하기 위함이다.
 */
function mergeFeedItems(existing, incoming, limit = FEED_LIMIT) {
  const items = Array.isArray(existing) ? existing.filter(Boolean) : [];
  const knownIds = new Set(items.map((item) => item.id));
  const added = incoming.filter((item) => !knownIds.has(item.id));
  return [...added, ...items].slice(0, limit);
}

module.exports = {
  FEED_LIMIT,
  FEED_CATEGORIES,
  orderFeedEntries,
  mergeFeedItems,
};
