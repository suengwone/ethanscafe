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
};

function orderSummary(order) {
  const items = Array.isArray(order.items) ? order.items : [];
  if (items.length === 0) {
    return '원두';
  }
  const first = items[0] && items[0].beanName ? items[0].beanName : '원두';
  return items.length === 1 ? first : `${first} 외 ${items.length - 1}건`;
}

function collectStatusChangeNotifications(beforeData, afterData) {
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
    const message = STATUS_MESSAGES[order.status];
    if (!message) {
      continue;
    }
    notifications.push({
      orderId: order.id,
      status: order.status,
      title: message.title,
      body: message.body(orderSummary(order)),
    });
  }
  return notifications;
}

module.exports = {
  STATUS_MESSAGES,
  orderSummary,
  collectStatusChangeNotifications,
};
