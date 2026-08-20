'use strict';

/**
 * 매장 혼잡도 자동 집계.
 *
 * 혼잡도는 원래 직원이 카탈로그 관리에서 직접 눌러 올린다. 바쁠수록 손이 안 가는
 * 일이라 정작 붐빌 때 값이 낡는다. 그래서 아직 음료가 나오지 않은 픽업 주문 수로
 * 매장이 얼마나 밀렸는지를 서버가 대신 재어 `store_activity`에 적어 둔다.
 *
 * 세는 대상은 `active_orders` 색인이다. 픽업 주문이 바뀔 때마다 그 매장 것만
 * 통째로 다시 세므로, 증감으로 어긋난 값이 있어도 다음 주문에서 저절로 맞는다.
 */

const COLLECTION = 'store_activity';

/** 아직 음료가 나오지 않은 주문. 픽업대에 놓인(`ready`) 주문은 바를 붙잡지 않는다. */
const LIVE_STATUSES = ['received', 'preparing'];

/** 이 건수부터 '보통'. */
const NORMAL_FROM = 3;
/** 이 건수부터 '혼잡'. */
const BUSY_FROM = 7;

function congestionForCount(count) {
  if (count >= BUSY_FROM) {
    return 'busy';
  }
  if (count >= NORMAL_FROM) {
    return 'normal';
  }
  return 'relaxed';
}

function ordersOf(data) {
  return data && Array.isArray(data.orders) ? data.orders : [];
}

function storeIdOf(order) {
  return order && typeof order.storeId === 'string' && order.storeId ?
    order.storeId : null;
}

/**
 * 주문 문서 한 건의 변경에서 다시 세어야 할 매장을 고른다.
 * 상태가 그대로인 주문은 색인도 그대로이므로 건너뛴다.
 */
function storeIdsToRecount({beforeData, afterData}) {
  const beforeById = new Map(
      ordersOf(beforeData)
          .filter((order) => order && order.id)
          .map((order) => [order.id, order]),
  );

  const storeIds = new Set();
  const seen = new Set();
  for (const order of ordersOf(afterData)) {
    if (!order || !order.id) {
      continue;
    }
    seen.add(order.id);
    const before = beforeById.get(order.id);
    if (before && before.status === order.status) {
      continue;
    }
    const storeId = storeIdOf(order) || storeIdOf(before);
    if (storeId) {
      storeIds.add(storeId);
    }
  }

  // 주문 문서째 지워진 경우(탈퇴 등)에도 매장 쪽 수치는 줄어야 한다.
  for (const [id, order] of beforeById) {
    const storeId = storeIdOf(order);
    if (!seen.has(id) && storeId) {
      storeIds.add(storeId);
    }
  }
  return [...storeIds];
}

/** 색인 문서 중 아직 만들고 있는 픽업 주문만 센다. */
function liveOrderCount(activeOrders) {
  return activeOrders.filter(
      (order) => order && LIVE_STATUSES.includes(order.status),
  ).length;
}

/**
 * 고객 화면이 읽을 문서. 건수를 함께 남겨 "진행 중인 주문 5건" 같은 근거를 보여 줄 수
 * 있게 한다.
 */
function storeActivityDoc({count, now}) {
  return {
    activeOrders: count,
    congestion: congestionForCount(count),
    updatedAt: now,
  };
}

module.exports = {
  COLLECTION,
  LIVE_STATUSES,
  NORMAL_FROM,
  BUSY_FROM,
  congestionForCount,
  storeIdsToRecount,
  liveOrderCount,
  storeActivityDoc,
};
