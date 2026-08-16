const test = require('node:test');
const assert = require('node:assert/strict');

const {
  earnPointsForPayment,
  validatePlaceOrderRequest,
  validateCancelOrderRequest,
  validateUsePointsRequest,
  validateEarnByMembershipRequest,
  orderTotalAmount,
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
} = require('./order_checkout');

const beanItem = {
  beanId: 'bean-1',
  beanName: '에티오피아 예가체프',
  weight: 'g200',
  grind: 'wholeBean',
  quantity: 2,
  unitPrice: 15000,
};

const pickupItem = {
  menuId: 'menu-1',
  menuName: '아메리카노',
  option: 'ICE',
  quantity: 1,
  unitPrice: 4500,
};

function timestampOf(date) {
  return {
    toMillis: () => date.getTime(),
    toDate: () => date,
  };
}

test('배송 원두 주문 요청을 검증한다', () => {
  const request = validatePlaceOrderRequest({
    orderType: 'bean',
    items: [beanItem],
    usedPoints: 1000,
    couponIds: ['coupon-1'],
    payment: {paymentKey: 'pk', orderId: 'bean-123456', amount: 26000},
    fulfillmentMethod: 'delivery',
    recipient: '홍길동',
    recipientPhone: '010-1234-5678',
    shippingAddress: '서울시 마포구 1',
  });

  assert.equal(request.orderType, 'bean');
  assert.equal(request.items.length, 1);
  assert.equal(request.usedPoints, 1000);
  assert.deepEqual(request.couponIds, ['coupon-1']);
  assert.equal(request.recipient, '홍길동');
});

test('픽업 주문 요청은 매장 정보가 필요하다', () => {
  assert.throws(() =>
    validatePlaceOrderRequest({orderType: 'pickup', items: [pickupItem]}),
  );

  const request = validatePlaceOrderRequest({
    orderType: 'pickup',
    items: [pickupItem],
    storeId: 'store-1',
    storeName: '합정점',
  });
  assert.equal(request.storeId, 'store-1');
  assert.equal(request.usedPoints, 0);
  assert.deepEqual(request.couponIds, []);
  assert.equal(request.payment, null);
});

test('잘못된 주문 요청을 거부한다', () => {
  assert.throws(() => validatePlaceOrderRequest({orderType: 'gift'}));
  assert.throws(() =>
    validatePlaceOrderRequest({orderType: 'bean', items: []}),
  );
  assert.throws(() =>
    validatePlaceOrderRequest({
      orderType: 'bean',
      items: [{...beanItem, quantity: 0}],
      fulfillmentMethod: 'delivery',
      recipient: '홍길동',
      recipientPhone: '010',
      shippingAddress: '서울',
    }),
  );
  assert.throws(() =>
    validatePlaceOrderRequest({
      orderType: 'bean',
      items: [{...beanItem, unitPrice: 1.5}],
      fulfillmentMethod: 'delivery',
      recipient: '홍길동',
      recipientPhone: '010',
      shippingAddress: '서울',
    }),
  );
  assert.throws(() =>
    validatePlaceOrderRequest({
      orderType: 'bean',
      items: [beanItem],
      usedPoints: -1,
      fulfillmentMethod: 'delivery',
      recipient: '홍길동',
      recipientPhone: '010',
      shippingAddress: '서울',
    }),
  );
  assert.throws(() =>
    validatePlaceOrderRequest({
      orderType: 'bean',
      items: [beanItem],
      couponIds: ['c1', 'c1'],
      fulfillmentMethod: 'delivery',
      recipient: '홍길동',
      recipientPhone: '010',
      shippingAddress: '서울',
    }),
  );
});

test('주문 취소 요청을 검증한다', () => {
  assert.deepEqual(
      validateCancelOrderRequest({orderType: 'pickup', orderId: 'o-1'}),
      {orderType: 'pickup', orderId: 'o-1'},
  );
  assert.throws(() => validateCancelOrderRequest({orderType: 'bean'}));
  assert.throws(() =>
    validateCancelOrderRequest({orderType: 'none', orderId: 'o-1'}),
  );
});

test('포인트 사용 요청을 검증한다', () => {
  assert.deepEqual(validateUsePointsRequest({amount: 500}), {
    amount: 500,
    description: '포인트 결제',
  });
  assert.deepEqual(
      validateUsePointsRequest({amount: 500, description: '매장 결제'}),
      {amount: 500, description: '매장 결제'},
  );
  assert.throws(() => validateUsePointsRequest({amount: 0}));
  assert.throws(() => validateUsePointsRequest({amount: 100.5}));
});

test('회원 적립 요청을 검증한다', () => {
  assert.deepEqual(
      validateEarnByMembershipRequest({
        membershipId: 'MEMBER-12345678',
        paymentAmount: 8000,
      }),
      {membershipId: 'MEMBER-12345678', paymentAmount: 8000},
  );
  assert.throws(() =>
    validateEarnByMembershipRequest({
      membershipId: 'GUEST-1',
      paymentAmount: 8000,
    }),
  );
  assert.throws(() =>
    validateEarnByMembershipRequest({
      membershipId: 'MEMBER-12345678',
      paymentAmount: 0,
    }),
  );
});

test('주문 금액과 적립 포인트를 계산한다', () => {
  assert.equal(orderTotalAmount([beanItem, {...beanItem, quantity: 1}]), 45000);
  assert.equal(earnPointsForPayment(12345), 1234);
  assert.equal(earnPointsForPayment(0), 0);
});

test('쿠폰 할인 금액을 계산한다', () => {
  assert.equal(couponDiscountFor({discountAmount: 3000}, 10000), 3000);
  assert.equal(couponDiscountFor({discountRate: 20}, 10500), 2100);
  assert.equal(
      couponDiscountFor({discountAmount: 3000, minOrderAmount: 20000}, 10000),
      0,
  );
  assert.equal(couponDiscountFor({}, 10000), 0);
});

test('쿠폰 검증은 소유자/사용 여부/만료를 확인한다', () => {
  const future = timestampOf(new Date(Date.now() + 86400000));
  const past = timestampOf(new Date(Date.now() - 86400000));
  const base = {
    uid: 'user-1',
    isUsed: false,
    discountAmount: 3000,
    expiresAt: future,
  };

  assert.equal(
      validateCouponsForOrder({
        coupons: [base],
        uid: 'user-1',
        orderAmount: 10000,
        nowMillis: Date.now(),
      }),
      3000,
  );
  assert.throws(() =>
    validateCouponsForOrder({
      coupons: [{...base, uid: 'other'}],
      uid: 'user-1',
      orderAmount: 10000,
      nowMillis: Date.now(),
    }),
  );
  assert.throws(() =>
    validateCouponsForOrder({
      coupons: [{...base, isUsed: true}],
      uid: 'user-1',
      orderAmount: 10000,
      nowMillis: Date.now(),
    }),
  );
  assert.throws(() =>
    validateCouponsForOrder({
      coupons: [{...base, expiresAt: past}],
      uid: 'user-1',
      orderAmount: 10000,
      nowMillis: Date.now(),
    }),
  );
  assert.throws(() =>
    validateCouponsForOrder({
      coupons: [base, {...base, discountAmount: 1000}],
      uid: 'user-1',
      orderAmount: 10000,
      nowMillis: Date.now(),
    }),
  );
});

test('스택 가능한 쿠폰은 일반 쿠폰과 함께 사용할 수 있다', () => {
  const future = timestampOf(new Date(Date.now() + 86400000));
  const discount = validateCouponsForOrder({
    coupons: [
      {uid: 'user-1', discountAmount: 3000, expiresAt: future},
      {uid: 'user-1', discountAmount: 1000, isStackable: true,
        expiresAt: future},
    ],
    uid: 'user-1',
    orderAmount: 10000,
    nowMillis: Date.now(),
  });
  assert.equal(discount, 4000);
});

test('쿠폰 라벨을 만든다', () => {
  assert.equal(couponIdsLabel([]), null);
  assert.equal(couponIdsLabel(['a', 'b']), 'a,b');
  assert.equal(couponTitlesLabel([]), null);
  assert.equal(
      couponTitlesLabel([{title: '웰컴'}, {title: '생일'}]),
      '웰컴 + 생일',
  );
});

test('주문 시 포인트 사용과 적립을 함께 반영한다', () => {
  const pointsData = {
    membershipId: 'MEMBER-12345678',
    balance: 5000,
    history: [{id: 'old'}],
  };
  const {earned, data} = applyOrderToPoints({
    pointsData,
    usedPoints: 2000,
    paidAmount: 10000,
    useDescription: '픽업 주문 포인트 사용',
    earnDescription: '픽업 주문',
    createdAt: 'now',
    entryId: () => 'entry',
  });

  assert.equal(earned, 1000);
  assert.equal(data.balance, 4000);
  assert.equal(data.history.length, 3);
  assert.equal(data.history[0].type, 'earn');
  assert.equal(data.history[0].paymentAmount, 10000);
  assert.equal(data.history[1].type, 'use');
  assert.equal(data.history[1].amount, -2000);
  assert.equal(data.history[2].id, 'old');
});

test('잔액보다 많은 포인트 사용은 거부한다', () => {
  assert.throws(() =>
    applyOrderToPoints({
      pointsData: {membershipId: 'M', balance: 100, history: []},
      usedPoints: 200,
      paidAmount: 0,
      useDescription: '사용',
      earnDescription: '적립',
      createdAt: 'now',
    }),
  );
});

test('주문 취소 시 사용 포인트를 환급하고 적립을 회수한다', () => {
  const data = applyCancelToPoints({
    pointsData: {membershipId: 'M', balance: 500, history: []},
    usedPoints: 2000,
    earnedPoints: 1000,
    description: '원두 주문 취소',
    createdAt: 'now',
    entryId: () => 'entry',
  });

  assert.equal(data.balance, 1500);
  assert.equal(data.history.length, 2);
  assert.equal(data.history[0].amount, -1000);
  assert.equal(data.history[1].amount, 2000);
});

test('적립 회수는 잔액+환급 한도까지만 회수한다', () => {
  const data = applyCancelToPoints({
    pointsData: {membershipId: 'M', balance: 100, history: []},
    usedPoints: 0,
    earnedPoints: 500,
    description: '주문 취소',
    createdAt: 'now',
    entryId: () => 'entry',
  });
  assert.equal(data.balance, 0);
});

test('픽업 번호는 당일 주문 수 기준으로 증가한다', () => {
  const today = new Date(2026, 7, 16, 10);
  const yesterday = new Date(2026, 7, 15, 10);
  const orders = [
    {createdAt: timestampOf(today)},
    {createdAt: timestampOf(yesterday)},
  ];
  assert.equal(nextPickupNumber(orders, today), 2);
  assert.equal(nextPickupNumber([], today), 1);
});

test('원두 배송 주문 문서를 생성한다', () => {
  const request = validatePlaceOrderRequest({
    orderType: 'bean',
    items: [beanItem],
    usedPoints: 1000,
    couponIds: ['coupon-1'],
    payment: {paymentKey: 'pk', orderId: 'bean-123456', amount: 26000},
    fulfillmentMethod: 'delivery',
    recipient: '홍길동',
    recipientPhone: '010-1234-5678',
    shippingAddress: '서울시 마포구 1',
  });
  const order = buildOrderDoc({
    request,
    orderId: 'order-1',
    earnedPoints: 2600,
    couponTitle: '웰컴 쿠폰',
    couponDiscount: 3000,
    paymentMethod: '카드',
    pickupNumber: null,
    createdAt: 'now',
  });

  assert.equal(order.id, 'order-1');
  assert.equal(order.totalAmount, 30000);
  assert.equal(order.usedPoints, 1000);
  assert.equal(order.earnedPoints, 2600);
  assert.equal(order.couponId, 'coupon-1');
  assert.equal(order.couponTitle, '웰컴 쿠폰');
  assert.equal(order.paymentKey, 'pk');
  assert.equal(order.paymentMethod, '카드');
  assert.equal(order.status, 'received');
  assert.equal(order.fulfillmentMethod, 'delivery');
  assert.equal(order.shippingAddress, '서울시 마포구 1');
  assert.equal(order.pickupNumber, undefined);
});

test('픽업 주문 문서는 매장과 픽업 번호를 포함한다', () => {
  const request = validatePlaceOrderRequest({
    orderType: 'pickup',
    items: [pickupItem],
    storeId: 'store-1',
    storeName: '합정점',
  });
  const order = buildOrderDoc({
    request,
    orderId: 'order-2',
    earnedPoints: 450,
    couponTitle: null,
    couponDiscount: 0,
    paymentMethod: null,
    pickupNumber: 3,
    createdAt: 'now',
  });

  assert.equal(order.storeId, 'store-1');
  assert.equal(order.storeName, '합정점');
  assert.equal(order.pickupNumber, 3);
  assert.equal(order.couponId, undefined);
  assert.equal(order.paymentKey, undefined);
  assert.equal(order.paymentMethod, undefined);
});

test('주문 직렬화 시 createdAt을 ISO 문자열로 바꾼다', () => {
  const date = new Date('2026-08-16T01:23:45.000Z');
  const serialized = serializeOrder({id: 'o-1', createdAt: timestampOf(date)});
  assert.equal(serialized.createdAt, '2026-08-16T01:23:45.000Z');
});

test('포인트 문서가 없으면 기본값을 만든다', () => {
  const data = normalizePointsData(undefined, () => 'MEMBER-00000000');
  assert.deepEqual(data, {
    membershipId: 'MEMBER-00000000',
    balance: 0,
    history: [],
  });
});
