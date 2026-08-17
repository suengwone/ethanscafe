'use strict';

/**
 * 진행 중인 주문 색인.
 *
 * 주문은 회원별 문서 하나에 배열로 쌓인다. 매장 주문 관리 화면이 이 구조를 직접
 * 읽으면 처리할 주문이 몇 건이든 회원 수만큼 문서를 읽게 되고, 지난 주문이 쌓일수록
 * 읽는 양도 같이 늘어난다. 그래서 아직 처리해야 하는 주문만 문서 하나씩 떼어
 * `active_orders`에 두고, 끝나거나 취소되면 지운다.
 */

const {orderSummary} = require('./order_status');

const COLLECTION = 'active_orders';

/** 매장이 더 손댈 필요가 없는 상태. 색인에서 지운다. */
const CLOSED_STATUSES = ['pickedUp', 'delivered', 'cancelled'];

function isClosed(order) {
  return !order || CLOSED_STATUSES.includes(order.status);
}

/** 주문 유형과 회원, 주문 번호를 합쳐 만든 색인 문서 ID. */
function activeOrderId({orderType, uid, orderId}) {
  return `${orderType}_${uid}_${orderId}`;
}

/** 매장 화면이 목록을 그리는 데 필요한 만큼만 담는다. */
function activeOrderDoc({orderType, uid, order}) {
  const doc = {
    orderType,
    uid,
    orderId: order.id,
    status: order.status,
    summary: orderSummary(order),
    totalAmount: Number.isInteger(order.totalAmount) ? order.totalAmount : 0,
    createdAt: order.createdAt || null,
  };
  if (orderType === 'pickup') {
    doc.pickupNumber =
      Number.isInteger(order.pickupNumber) ? order.pickupNumber : null;
    doc.storeName = order.storeName || null;
  } else {
    doc.fulfillmentMethod = order.fulfillmentMethod || 'delivery';
    doc.recipient = order.recipient || null;
    doc.storeName = order.storeName || null;
  }
  return doc;
}

function ordersOf(data) {
  return data && Array.isArray(data.orders) ? data.orders : [];
}

/**
 * 주문 문서 한 건의 변경을 색인에 반영할 쓰기 목록으로 바꾼다.
 * 상태가 그대로면 아무것도 돌려주지 않아 무의미한 쓰기를 만들지 않는다.
 */
function collectActiveOrderWrites({orderType, uid, beforeData, afterData}) {
  const beforeById = new Map(
      ordersOf(beforeData)
          .filter((order) => order && order.id)
          .map((order) => [order.id, order]),
  );

  const writes = [];
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
    const id = activeOrderId({orderType, uid, orderId: order.id});
    if (isClosed(order)) {
      // 처음부터 끝난 상태로 들어온 주문은 색인에 없었으니 지울 것도 없다.
      if (before) {
        writes.push({type: 'delete', id});
      }
      continue;
    }
    writes.push({type: 'set', id, doc: activeOrderDoc({orderType, uid, order})});
  }

  // 주문 문서 자체가 지워진 경우(탈퇴 등) 남은 색인을 정리한다.
  for (const id of beforeById.keys()) {
    if (!seen.has(id)) {
      writes.push({
        type: 'delete',
        id: activeOrderId({orderType, uid, orderId: id}),
      });
    }
  }
  return writes;
}

module.exports = {
  COLLECTION,
  CLOSED_STATUSES,
  isClosed,
  activeOrderId,
  activeOrderDoc,
  collectActiveOrderWrites,
};
