// 취소는 고객이 직접 하기도 하고 매장이 품절 등으로 하기도 한다.
// 매장이 취소한 경우 알리지 않으면 고객이 헛걸음하므로 두 경우 모두 보낸다.
const CANCELLED_MESSAGE = {
  title: '주문이 취소됐어요',
  body: (summary, order) => {
    // 포인트·쿠폰으로만 치른 주문은 환불할 결제 건이 없다.
    const refunded = order && typeof order.paymentKey === 'string' &&
      order.paymentKey.length > 0;
    return refunded ?
      `${summary} 주문이 취소되었어요. 결제하신 금액은 환불됩니다.` :
      `${summary} 주문이 취소되었어요. 사용하신 포인트와 쿠폰은 돌려드렸어요.`;
  },
};

const STATUS_MESSAGES = {
  roasting: {
    title: '원두 로스팅이 시작됐어요',
    body: (summary) => `${summary} 주문의 원두를 정성껏 로스팅하고 있어요.`,
  },
  shipped: {
    title: '원두가 발송됐어요',
    body: (summary) => `${summary} 주문이 발송되었어요. 곧 도착할 예정이에요.`,
  },
  delivered: {
    title: '원두가 배송 완료됐어요',
    body: (summary) => `${summary} 주문이 배송 완료되었어요. 맛있게 즐겨주세요.`,
  },
  // 매장 수령을 고른 원두 주문. 배송 흐름에는 없는 단계다.
  ready: {
    title: '원두가 준비됐어요',
    body: (summary) => `${summary} 주문을 매장에서 찾아가세요.`,
  },
  cancelled: CANCELLED_MESSAGE,
};

// 픽업 주문용. 매장에서 상태를 넘길 때 고객에게 바로 알린다.
const PICKUP_STATUS_MESSAGES = {
  preparing: {
    title: '음료를 만들고 있어요',
    body: (summary) => `${summary} 주문을 준비 중이에요.`,
  },
  ready: {
    title: '주문하신 음료가 나왔어요',
    body: (summary) => `${summary} 주문을 픽업대에서 찾아가세요.`,
  },
  cancelled: CANCELLED_MESSAGE,
};

function orderSummary(order) {
  const items = Array.isArray(order.items) ? order.items : [];
  if (items.length === 0) {
    return '주문';
  }
  const first = items[0] || {};
  const name = first.beanName || first.menuName || '주문';
  return items.length === 1 ? name : `${name} 외 ${items.length - 1}건`;
}

function collectStatusChangeNotifications(
    beforeData, afterData, messages = STATUS_MESSAGES) {
  const beforeOrders =
    beforeData && Array.isArray(beforeData.orders) ? beforeData.orders : [];
  const afterOrders =
    afterData && Array.isArray(afterData.orders) ? afterData.orders : [];
  const beforeStatusById = new Map(
    beforeOrders
      .filter((order) => order && order.id)
      .map((order) => [order.id, order.status]),
  );

  const notifications = [];
  for (const order of afterOrders) {
    if (!order || !order.id || !beforeStatusById.has(order.id)) {
      continue;
    }
    if (beforeStatusById.get(order.id) === order.status) {
      continue;
    }
    const message = messages[order.status];
    if (!message) {
      continue;
    }
    notifications.push({
      orderId: order.id,
      status: order.status,
      title: message.title,
      body: message.body(orderSummary(order), order),
    });
  }
  return notifications;
}

module.exports = {
  STATUS_MESSAGES,
  PICKUP_STATUS_MESSAGES,
  orderSummary,
  collectStatusChangeNotifications,
};
