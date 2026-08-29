const EARN_RATE_PERCENT = 10;
const MAX_ITEM_COUNT = 50;
const MAX_UNIT_PRICE = 10000000;
const MAX_DESCRIPTION_LENGTH = 100;

const BEAN_WEIGHTS = ['g200', 'g500'];
const GRIND_OPTIONS = [
  'wholeBean',
  'espresso',
  'mokaPot',
  'handDrip',
  'frenchPress',
];
const BEAN_FULFILLMENTS = ['delivery', 'pickup'];

function earnPointsForPayment(paymentAmount) {
  return Math.floor((paymentAmount * EARN_RATE_PERCENT) / 100);
}

function newOrderEntryId(now = Date.now(), random = Math.random) {
  const suffix = Math.floor(random() * 0x10000);
  return `${now * 1000}-${suffix}`;
}

function requireString(value, name, {optional = false, maxLength = 200} = {}) {
  if (value === undefined || value === null) {
    if (optional) {
      return null;
    }
    throw new Error(`${name}이(가) 올바르지 않습니다.`);
  }
  if (typeof value !== 'string' || value.length === 0 ||
      value.length > maxLength) {
    throw new Error(`${name}이(가) 올바르지 않습니다.`);
  }
  return value;
}

function requireInt(value, name, {min, max}) {
  if (!Number.isInteger(value) || value < min || value > max) {
    throw new Error(`${name}이(가) 올바르지 않습니다.`);
  }
  return value;
}

function validateBeanItem(item) {
  if (!item || typeof item !== 'object') {
    throw new Error('주문 상품이 올바르지 않습니다.');
  }
  const weight = item.weight;
  if (!BEAN_WEIGHTS.includes(weight)) {
    throw new Error('원두 용량이 올바르지 않습니다.');
  }
  const grind = item.grind;
  if (!GRIND_OPTIONS.includes(grind)) {
    throw new Error('분쇄 옵션이 올바르지 않습니다.');
  }
  return {
    beanId: requireString(item.beanId, '상품 정보'),
    beanName: requireString(item.beanName, '상품 정보'),
    weight,
    grind,
    quantity: requireInt(item.quantity, '수량', {min: 1, max: 999}),
    unitPrice: requireInt(item.unitPrice, '금액', {min: 0, max: MAX_UNIT_PRICE}),
  };
}

function validatePickupItem(item) {
  if (!item || typeof item !== 'object') {
    throw new Error('주문 상품이 올바르지 않습니다.');
  }
  const validated = {
    menuId: requireString(item.menuId, '상품 정보'),
    menuName: requireString(item.menuName, '상품 정보'),
    quantity: requireInt(item.quantity, '수량', {min: 1, max: 999}),
    unitPrice: requireInt(item.unitPrice, '금액', {min: 0, max: MAX_UNIT_PRICE}),
  };
  const option = requireString(item.option, '옵션', {optional: true});
  if (option !== null) {
    validated.option = option;
  }
  return validated;
}

function validatePayment(payment) {
  if (payment === undefined || payment === null) {
    return null;
  }
  return {
    paymentKey: requireString(payment.paymentKey, 'paymentKey'),
    orderId: requireString(payment.orderId, 'orderId'),
    amount: requireInt(payment.amount, '결제 금액', {
      min: 1,
      max: MAX_UNIT_PRICE,
    }),
  };
}

function validateCouponIds(couponIds) {
  if (couponIds === undefined || couponIds === null) {
    return [];
  }
  if (!Array.isArray(couponIds) || couponIds.length > 10) {
    throw new Error('쿠폰 정보가 올바르지 않습니다.');
  }
  const ids = couponIds.map((id) => requireString(id, '쿠폰 정보'));
  if (new Set(ids).size !== ids.length) {
    throw new Error('같은 쿠폰은 한 번만 적용할 수 있습니다.');
  }
  return ids;
}

function validatePlaceOrderRequest(data) {
  const orderType = data && data.orderType;
  if (orderType !== 'bean' && orderType !== 'pickup') {
    throw new Error('주문 유형이 올바르지 않습니다.');
  }

  const rawItems = data.items;
  if (!Array.isArray(rawItems) || rawItems.length === 0 ||
      rawItems.length > MAX_ITEM_COUNT) {
    throw new Error('주문 상품이 비어 있습니다.');
  }
  const items = rawItems.map(
      orderType === 'bean' ? validateBeanItem : validatePickupItem);

  const usedPoints = data.usedPoints === undefined ?
    0 :
    requireInt(data.usedPoints, '사용 포인트', {min: 0, max: MAX_UNIT_PRICE});
  const couponIds = validateCouponIds(data.couponIds);
  const payment = validatePayment(data.payment);

  const request = {orderType, items, usedPoints, couponIds, payment};

  if (orderType === 'pickup') {
    request.storeId = requireString(data.storeId, '매장 정보');
    request.storeName = requireString(data.storeName, '매장 정보');
    return request;
  }

  const fulfillmentMethod = data.fulfillmentMethod;
  if (!BEAN_FULFILLMENTS.includes(fulfillmentMethod)) {
    throw new Error('수령 방법이 올바르지 않습니다.');
  }
  request.fulfillmentMethod = fulfillmentMethod;
  if (fulfillmentMethod === 'pickup') {
    request.storeId = requireString(data.storeId, '매장 정보');
    request.storeName = requireString(data.storeName, '매장 정보');
  } else {
    request.recipient = requireString(data.recipient, '배송지 정보');
    request.recipientPhone = requireString(data.recipientPhone, '배송지 정보');
    request.shippingAddress =
        requireString(data.shippingAddress, '배송지 정보', {maxLength: 500});
  }
  return request;
}

function orderTotalAmount(items) {
  return items.reduce((sum, item) => sum + item.quantity * item.unitPrice, 0);
}

/** 주문 항목이 참조하는 카탈로그 문서 ID. 픽업은 메뉴, 원두는 원두 문서다. */
function catalogItemId(orderType, item) {
  return orderType === 'pickup' ? item.menuId : item.beanId;
}

function catalogItemIds(orderType, items) {
  return [...new Set(items.map((item) => catalogItemId(orderType, item)))];
}

function catalogUnitPrice(orderType, item, data) {
  if (orderType === 'pickup') {
    return data.price;
  }
  return item.weight === 'g200' ? data.price200 : data.price500;
}

/**
 * 클라이언트가 보낸 단가를 카탈로그 가격과 대조한다.
 * 가격을 클라이언트가 정하면 0원 주문을 만들 수 있으므로 서버가 반드시 확인한다.
 * catalogData는 문서 ID -> 문서 데이터(없으면 null) 맵이다.
 */
function verifyCatalogItems({orderType, items, catalogData}) {
  for (const item of items) {
    const id = catalogItemId(orderType, item);
    const data = catalogData.get(id);
    if (!data) {
      throw new Error('판매하지 않는 상품이 포함되어 있습니다.');
    }
    // 장바구니에 담아둔 사이 매장이 품절 처리했을 수 있다.
    if (data.soldOut === true) {
      throw new Error('품절된 상품이 포함되어 있습니다. 장바구니를 다시 확인해 주세요.');
    }
    const expected = catalogUnitPrice(orderType, item, data);
    if (!Number.isInteger(expected) || expected < 0) {
      throw new Error('상품 가격을 확인하지 못했습니다.');
    }
    if (expected !== item.unitPrice) {
      throw new Error('상품 가격이 변경되었습니다. 장바구니를 다시 확인해 주세요.');
    }
  }
}

function couponDiscountFor(coupon, orderAmount) {
  const discountAmount = coupon.discountAmount || 0;
  const discountRate = coupon.discountRate || 0;
  const minOrderAmount = coupon.minOrderAmount || 0;
  if ((discountAmount <= 0 && discountRate <= 0) ||
      orderAmount < minOrderAmount) {
    return 0;
  }
  const discount = discountAmount > 0 ?
    discountAmount :
    Math.floor((orderAmount * discountRate) / 100);
  return Math.min(Math.max(discount, 0), orderAmount);
}

function validateCouponsForOrder({coupons, uid, orderAmount, nowMillis}) {
  if (coupons.length === 0) {
    return 0;
  }
  const regularCount =
      coupons.filter((coupon) => coupon.isStackable !== true).length;
  if (regularCount > 1) {
    throw new Error('중복 사용이 불가능한 쿠폰은 1장만 적용할 수 있습니다.');
  }
  let discount = 0;
  for (const coupon of coupons) {
    if (coupon.uid !== uid) {
      throw new Error('적용할 수 없는 쿠폰입니다.');
    }
    if (coupon.isUsed === true) {
      throw new Error('이미 사용된 쿠폰입니다.');
    }
    const expiresAt = coupon.expiresAt;
    const expiresMillis = expiresAt && typeof expiresAt.toMillis === 'function' ?
      expiresAt.toMillis() :
      0;
    if (expiresMillis < nowMillis) {
      throw new Error('유효 기간이 지난 쿠폰입니다.');
    }
    const amount = couponDiscountFor(coupon, orderAmount);
    if (amount <= 0) {
      throw new Error('적용할 수 없는 쿠폰입니다.');
    }
    discount += amount;
  }
  return Math.min(discount, orderAmount);
}

/** 주문 항목을 카탈로그 문서 ID별 판매 수량으로 합산한다. */
function salesQuantitiesByItem(orderType, items) {
  const quantities = new Map();
  for (const item of items) {
    const id = catalogItemId(orderType, item);
    quantities.set(id, (quantities.get(id) || 0) + item.quantity);
  }
  return quantities;
}

function couponIdsLabel(couponIds) {
  return couponIds.length === 0 ? null : couponIds.join(',');
}

function couponTitlesLabel(coupons) {
  return coupons.length === 0 ?
    null :
    coupons.map((coupon) => coupon.title || '').join(' + ');
}

function normalizePointsData(data, newMembershipId) {
  const raw = data || {};
  return {
    membershipId: raw.membershipId || newMembershipId(),
    balance: Number.isInteger(raw.balance) ? raw.balance : 0,
    history: Array.isArray(raw.history) ? raw.history : [],
  };
}

function applyOrderToPoints({
  pointsData,
  usedPoints,
  paidAmount,
  useDescription,
  earnDescription,
  createdAt,
  entryId = newOrderEntryId,
}) {
  const entries = [];
  let balance = pointsData.balance;
  if (usedPoints > 0) {
    if (usedPoints > balance) {
      throw new Error('포인트 잔액이 부족합니다.');
    }
    balance -= usedPoints;
    entries.push({
      id: entryId(),
      type: 'use',
      description: useDescription,
      amount: -usedPoints,
      createdAt,
    });
  }
  let earned = 0;
  if (paidAmount > 0) {
    earned = earnPointsForPayment(paidAmount);
    if (earned > 0) {
      balance += earned;
      entries.push({
        id: entryId(),
        type: 'earn',
        description: earnDescription,
        amount: earned,
        paymentAmount: paidAmount,
        createdAt,
      });
    }
  }
  return {
    earned,
    data: {
      ...pointsData,
      balance,
      history: [...entries.reverse(), ...pointsData.history],
    },
  };
}

function applyCancelToPoints({
  pointsData,
  usedPoints,
  earnedPoints,
  description,
  createdAt,
  entryId = newOrderEntryId,
}) {
  const reclaimed = Math.min(earnedPoints, pointsData.balance + usedPoints);
  const entries = [];
  if (reclaimed > 0) {
    entries.push({
      id: entryId(),
      type: 'use',
      description: `${description} 적립 회수`,
      amount: -reclaimed,
      createdAt,
    });
  }
  if (usedPoints > 0) {
    entries.push({
      id: entryId(),
      type: 'earn',
      description: `${description} 포인트 환급`,
      amount: usedPoints,
      createdAt,
    });
  }
  return {
    ...pointsData,
    balance: pointsData.balance + usedPoints - reclaimed,
    history: [...entries, ...pointsData.history],
  };
}

function nextPickupNumber(orders, now) {
  const todayCount = orders.filter((order) => {
    const createdAt = order && order.createdAt;
    const date = createdAt && typeof createdAt.toDate === 'function' ?
      createdAt.toDate() :
      null;
    return date !== null &&
        date.getFullYear() === now.getFullYear() &&
        date.getMonth() === now.getMonth() &&
        date.getDate() === now.getDate();
  }).length;
  return todayCount + 1;
}

function buildOrderDoc({
  request,
  orderId,
  earnedPoints,
  couponTitle,
  couponDiscount,
  paymentMethod,
  pickupNumber,
  createdAt,
}) {
  const order = {
    id: orderId,
    items: request.items,
    totalAmount: orderTotalAmount(request.items),
    usedPoints: request.usedPoints,
    earnedPoints,
    couponDiscount,
    status: 'received',
    createdAt,
  };
  const couponId = couponIdsLabel(request.couponIds);
  if (couponId !== null) {
    order.couponId = couponId;
  }
  if (couponTitle !== null && couponTitle !== undefined) {
    order.couponTitle = couponTitle;
  }
  if (request.payment) {
    order.paymentKey = request.payment.paymentKey;
  }
  if (paymentMethod) {
    order.paymentMethod = paymentMethod;
  }
  if (request.orderType === 'pickup') {
    order.storeId = request.storeId;
    order.storeName = request.storeName;
    order.pickupNumber = pickupNumber;
    return order;
  }
  order.fulfillmentMethod = request.fulfillmentMethod;
  if (request.fulfillmentMethod === 'pickup') {
    order.storeId = request.storeId;
    order.storeName = request.storeName;
  } else {
    order.recipient = request.recipient;
    order.recipientPhone = request.recipientPhone;
    order.shippingAddress = request.shippingAddress;
  }
  return order;
}

function serializeOrder(order) {
  const createdAt = order.createdAt;
  return {
    ...order,
    createdAt: createdAt && typeof createdAt.toDate === 'function' ?
      createdAt.toDate().toISOString() :
      new Date(createdAt).toISOString(),
  };
}

function validateUsePointsRequest(data) {
  const amount = requireInt(data && data.amount, '사용 포인트', {
    min: 1,
    max: MAX_UNIT_PRICE,
  });
  const description = data && data.description !== undefined ?
    requireString(data.description, '설명', {
      maxLength: MAX_DESCRIPTION_LENGTH,
    }) :
    '포인트 결제';
  return {amount, description};
}

function validateEarnByMembershipRequest(data) {
  const membershipId = requireString(data && data.membershipId, '회원 QR 코드');
  if (!/^MEMBER-\d{8}$/.test(membershipId)) {
    throw new Error('회원 QR 코드가 올바르지 않습니다.');
  }
  const paymentAmount = requireInt(data && data.paymentAmount, '결제 금액', {
    min: 1,
    max: MAX_UNIT_PRICE,
  });
  return {membershipId, paymentAmount};
}

/**
 * 이 결제를 이미 쓰고 있는 주문이 있다는 뜻.
 *
 * placeOrder 트랜잭션이 `payment_usages`에서 같은 paymentKey를 발견하면 던진다.
 * 같은 결제로 두 번 주문이 서지 않게 막는 장치이므로, 이 실패는 "돈이 붕 떴다"가
 * 아니라 "이미 잘 처리됐다"에 가깝다.
 */
const PAYMENT_ALREADY_USED_MESSAGE = '이미 처리된 결제입니다.';

/**
 * 주문이 실패했을 때 이미 승인된 결제를 되돌려야 하는지 판단한다.
 *
 * 클라이언트는 placeOrder를 부르기 전에 결제를 먼저 승인받는다. 그래서 이 콜러블
 * 안에서 무엇이 실패하든 그 돈은 이미 고객 계좌에서 빠져나간 상태다. 품절·쿠폰·
 * 포인트 검사처럼 결제를 확인하기 **전에** 던지는 것도 마찬가지라, 확인을 마친
 * 결제만 되돌리면 그 구간에서 낸 돈이 기록 없이 남는다.
 *
 * 딱 하나 예외가 있다. 이미 다른 주문이 쓰고 있는 결제(중복 제출)는 건드리면 안
 * 된다. 취소하면 멀쩡히 성립한 주문의 돈만 돌려주게 된다.
 */
function shouldCancelPayment({paymentKey, error}) {
  if (typeof paymentKey !== 'string' || paymentKey.length === 0) {
    return false;
  }
  const message = error && typeof error.message === 'string' ?
    error.message :
    '';
  return !message.includes(PAYMENT_ALREADY_USED_MESSAGE);
}

module.exports = {
  EARN_RATE_PERCENT,
  earnPointsForPayment,
  newOrderEntryId,
  validatePlaceOrderRequest,
  validateUsePointsRequest,
  validateEarnByMembershipRequest,
  orderTotalAmount,
  catalogItemId,
  catalogItemIds,
  catalogUnitPrice,
  verifyCatalogItems,
  salesQuantitiesByItem,
  couponDiscountFor,
  validateCouponsForOrder,
  couponIdsLabel,
  couponTitlesLabel,
  normalizePointsData,
  applyOrderToPoints,
  applyCancelToPoints,
  nextPickupNumber,
  buildOrderDoc,
  serializeOrder,
  PAYMENT_ALREADY_USED_MESSAGE,
  shouldCancelPayment,
};
