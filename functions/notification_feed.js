// 푸시는 기기에 한 번 뜨고 사라진다. 앱 안에서 다시 볼 수 있도록 같은 내용을
// 사용자 문서 하나(`notifications/{uid}`)에 배열로 쌓아 둔다.
//
// 배열을 고른 까닭: 알림함은 한 사람 것을 통째로 읽고, 회원 탈퇴 때 문서 하나만
// 지우면 되고, 모두 읽음도 쓰기 한 번이면 끝나기 때문이다. 대신 무한정 늘면
// 문서 크기 한도에 부딪히므로 최근 것만 남긴다.
const FEED_LIMIT = 50;

/** 알림함 항목의 분류. 클라이언트 enum과 이름을 맞춘다. */
const FEED_CATEGORIES = ['order', 'points'];

const ORDER_HISTORY_ROUTE = '/profile/orders';
const POINTS_ROUTE = '/points';

/**
 * 분류별로 확인할 알림 설정 항목.
 *
 * 여기 없는 분류는 `pushEnabled`만 본다. 주문 상태는 돈과 물건이 걸린 일이라
 * 따로 끌 수 있게 두지 않았다.
 */
const TOPIC_SETTING_KEYS = {points: 'pointsEnabled'};

/** 이 분류의 푸시를 보내도 되는지. 알림함 적재는 이 판단과 무관하다. */
function isPushAllowed(settings, category) {
  if (!settings) {
    return true;
  }
  if (settings.pushEnabled === false) {
    return false;
  }
  const key = TOPIC_SETTING_KEYS[category];
  return !key || settings[key] !== false;
}

/** 픽업 주문은 진행 단계를 보여 주는 추적 화면으로 바로 보낸다. */
function orderRoute(orderType, orderId) {
  return orderType === 'pickup' ?
    `${ORDER_HISTORY_ROUTE}/track/${orderId}` :
    ORDER_HISTORY_ROUTE;
}

/**
 * 주문 상태 알림을 알림함 항목으로 옮긴다.
 *
 * id를 `주문id:상태`로 박아 트리거가 두 번 돌아도 같은 항목이 겹치지 않게 한다.
 */
function orderFeedEntries({notifications, orderType, createdAt}) {
  return notifications.map((notification) => ({
    id: `${notification.orderId}:${notification.status}`,
    title: notification.title,
    body: notification.body,
    category: 'order',
    route: orderRoute(orderType, notification.orderId),
    createdAt,
    isRead: false,
  }));
}

/**
 * 한 번의 쓰기에서 알릴 수 있는 포인트 이력의 최대 개수.
 *
 * 지금 쓰는 곳은 많아야 두 건(사용+적립)을 붙인다. 이력 배열을 통째로 다시 쓰는
 * 일이 생기면 옛 항목이 새 것으로 보일 수 있어, 그때 알림이 쏟아지지 않게 막는다.
 */
const POINTS_BURST_LIMIT = 5;

/** 포인트 이력 가운데 이번 쓰기에서 새로 붙은 것만 고른다. */
function newPointHistoryEntries(beforeData, afterData) {
  const after = afterData && Array.isArray(afterData.history) ?
    afterData.history :
    [];
  const beforeIds = new Set(
      (beforeData && Array.isArray(beforeData.history) ? beforeData.history : [])
          .filter((entry) => entry && entry.id)
          .map((entry) => entry.id),
  );
  // 쓰는 쪽이 모두 앞에 붙이므로 새 항목은 앞에 몰려 있다. 아는 id를 만나는
  // 순간 멈춰야 중간에 사라진 옛 항목을 새 것으로 착각하지 않는다.
  const fresh = [];
  for (const entry of after) {
    if (!entry || !entry.id || beforeIds.has(entry.id)) {
      break;
    }
    fresh.push(entry);
  }
  if (fresh.length > POINTS_BURST_LIMIT) {
    console.error(
        '포인트 이력이 한 번에 너무 많이 붙었습니다. 알림을 줄입니다.',
        fresh.length,
    );
    return fresh.slice(0, POINTS_BURST_LIMIT);
  }
  return fresh;
}

const KOREAN_FIRST = 0xac00;
const KOREAN_LAST = 0xd7a3;

/** 받침에 따라 조사를 고른다. `으로`는 ㄹ 받침일 때만 예외로 `로`를 쓴다. */
function withParticle(word, withBatchim, withoutBatchim) {
  const last = String(word).trim().slice(-1);
  const code = last.charCodeAt(0);
  if (!last || code < KOREAN_FIRST || code > KOREAN_LAST) {
    return `${word}${withoutBatchim}`;
  }
  const jongseong = (code - KOREAN_FIRST) % 28;
  const takesBatchim = jongseong !== 0 &&
    !(jongseong === 8 && withoutBatchim === '로');
  return `${word}${takesBatchim ? withBatchim : withoutBatchim}`;
}

function points(amount) {
  return `${Math.abs(amount).toLocaleString('ko-KR')}P`;
}

/**
 * 포인트 이력을 알림함 항목으로 옮긴다.
 *
 * [entries]는 최신이 앞인 새 이력이고 [balance]는 그 가운데 가장 최신 항목까지
 * 반영한 잔액이다. 나머지 항목의 잔액은 금액을 되짚어 구한다.
 *
 * 한 번의 쓰기에 사용과 적립이 같이 들어오면(주문 결제) 알림 하나로 묶는다.
 * 한 번 결제하고 알림을 두 번 받을 까닭이 없다.
 * 주문 취소로 돌려준 포인트는 건너뛴다. 취소 알림이 이미 그 이야기를 한다.
 */
function pointsFeedEntries({entries, balance, createdAt}) {
  const fresh = entries.filter((entry) => entry && !isCancelRefund(entry));
  if (fresh.length === 0) {
    return [];
  }

  const used = fresh.find((entry) => entry.type === 'use');
  const earned = fresh.find((entry) => entry.type === 'earn');
  if (fresh.length === 2 && used && earned) {
    return [
      {
        id: `points:${earned.id}`,
        title: '포인트가 적립됐어요',
        body: `${withParticle(earned.description, '으로', '로')} ` +
          `${points(used.amount)}를 쓰고 ${points(earned.amount)}를 모았어요. ` +
          `지금 잔액은 ${points(balance)}예요.`,
        category: 'points',
        route: POINTS_ROUTE,
        createdAt,
        isRead: false,
      },
    ];
  }

  const items = [];
  let runningBalance = balance;
  for (const entry of entries) {
    if (!isCancelRefund(entry)) {
      items.push({
        id: `points:${entry.id}`,
        ...pointsMessage(entry, runningBalance),
        category: 'points',
        route: POINTS_ROUTE,
        createdAt,
        isRead: false,
      });
    }
    // 이 항목이 붙기 전 잔액이 바로 다음(더 오래된) 항목의 잔액이다.
    runningBalance -= entry.amount || 0;
  }
  return items;
}

/**
 * 주문 취소로 오간 포인트인지.
 *
 * 취소를 적는 쪽이 `cancelled`를 달아 준다. 문구에 '취소'가 들어갔는지로 가려내면
 * 사용자가 직접 적는 사용 설명에 그 두 글자가 들어갔을 때 멀쩡한 알림이 사라진다.
 */
function isCancelRefund(entry) {
  return entry.cancelled === true;
}

function pointsMessage(entry, balance) {
  if (entry.type === 'use') {
    return {
      title: '포인트를 사용했어요',
      body: `${points(entry.amount)}를 사용했어요. ` +
        `남은 잔액은 ${points(balance)}예요.`,
    };
  }
  if (entry.type === 'charge') {
    const bonus = entry.bonusAmount || 0;
    return {
      title: '포인트를 충전했어요',
      body: bonus > 0 ?
        `보너스 ${points(bonus)}를 더해 ${points(entry.amount)}가 들어왔어요. ` +
          `지금 잔액은 ${points(balance)}예요.` :
        `${points(entry.amount)}를 충전했어요. ` +
          `지금 잔액은 ${points(balance)}예요.`,
    };
  }
  return {
    title: '포인트가 적립됐어요',
    body: `${withParticle(entry.description, '으로', '로')} ` +
      `${points(entry.amount)}를 모았어요. 지금 잔액은 ${points(balance)}예요.`,
  };
}

/**
 * 이미 쌓인 항목과 새 항목을 합친다.
 *
 * 같은 id가 이미 있으면 **기존 것을 남긴다**. 사용자가 읽음으로 바꿔 둔 표시를
 * 트리거 재실행이 되돌리지 않게 하기 위함이다.
 */
function mergeFeedItems(existing, incoming, limit = FEED_LIMIT) {
  const items = Array.isArray(existing) ? existing.filter(Boolean) : [];
  return [...newFeedItems(existing, incoming), ...items].slice(0, limit);
}

/**
 * 아직 알림함에 없는 항목만 고른다.
 *
 * 트리거는 같은 사건으로 두 번 불릴 수 있다. 알림함은 id로 걸러지지만 푸시는
 * 그대로 한 번 더 나가므로, 보낼 쪽도 이 목록만 본다.
 */
function newFeedItems(existing, incoming) {
  const knownIds = new Set(
      (Array.isArray(existing) ? existing.filter(Boolean) : [])
          .map((item) => item.id),
  );
  return incoming.filter((item) => !knownIds.has(item.id));
}

module.exports = {
  FEED_LIMIT,
  FEED_CATEGORIES,
  ORDER_HISTORY_ROUTE,
  POINTS_ROUTE,
  isPushAllowed,
  orderRoute,
  orderFeedEntries,
  newPointHistoryEntries,
  pointsFeedEntries,
  mergeFeedItems,
  newFeedItems,
  POINTS_BURST_LIMIT,
};
