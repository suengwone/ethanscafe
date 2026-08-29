const test = require('node:test');
const assert = require('node:assert/strict');

const {
  earnPointsForPayment,
  shouldCancelPayment,
  PAYMENT_ALREADY_USED_MESSAGE,
  validatePlaceOrderRequest,
  validateUsePointsRequest,
  validateEarnByMembershipRequest,
  orderTotalAmount,
  catalogItemIds,
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

test('픽업 단가가 메뉴 가격과 다르면 거부한다', () => {
  const catalogData = new Map([['menu-1', {price: 4500}]]);
  assert.doesNotThrow(() => verifyCatalogItems({
    orderType: 'pickup',
    items: [pickupItem],
    catalogData,
  }));
  assert.throws(() => verifyCatalogItems({
    orderType: 'pickup',
    items: [{...pickupItem, unitPrice: 0}],
    catalogData,
  }), /가격이 변경/);
});

test('원두 단가는 용량별 가격과 대조한다', () => {
  const catalogData = new Map([['bean-1', {price200: 15000, price500: 30000}]]);
  assert.doesNotThrow(() => verifyCatalogItems({
    orderType: 'bean',
    items: [beanItem],
    catalogData,
  }));
  assert.throws(() => verifyCatalogItems({
    orderType: 'bean',
    items: [{...beanItem, weight: 'g500'}],
    catalogData,
  }), /가격이 변경/);
  assert.doesNotThrow(() => verifyCatalogItems({
    orderType: 'bean',
    items: [{...beanItem, weight: 'g500', unitPrice: 30000}],
    catalogData,
  }));
});

test('카탈로그에 없는 상품은 거부한다', () => {
  assert.throws(() => verifyCatalogItems({
    orderType: 'pickup',
    items: [pickupItem],
    catalogData: new Map([['menu-1', null]]),
  }), /판매하지 않는 상품/);
});

test('품절 처리된 상품은 거부한다', () => {
  assert.throws(() => verifyCatalogItems({
    orderType: 'pickup',
    items: [pickupItem],
    catalogData: new Map([['menu-1', {price: 4500, soldOut: true}]]),
  }), /품절된 상품/);
  assert.doesNotThrow(() => verifyCatalogItems({
    orderType: 'pickup',
    items: [pickupItem],
    catalogData: new Map([['menu-1', {price: 4500, soldOut: false}]]),
  }));
});

test('카탈로그 가격이 숫자가 아니면 거부한다', () => {
  assert.throws(() => verifyCatalogItems({
    orderType: 'pickup',
    items: [pickupItem],
    catalogData: new Map([['menu-1', {price: '4500'}]]),
  }), /가격을 확인하지 못/);
});

test('중복 상품 ID는 한 번만 조회한다', () => {
  assert.deepEqual(
      catalogItemIds('pickup', [pickupItem, {...pickupItem, quantity: 3}]),
      ['menu-1'],
  );
  assert.deepEqual(catalogItemIds('bean', [beanItem]), ['bean-1']);
});

test('판매량은 상품 ID별로 합산한다', () => {
  const quantities = salesQuantitiesByItem('pickup', [
    pickupItem,
    {...pickupItem, quantity: 2},
    {...pickupItem, menuId: 'menu-2', quantity: 5},
  ]);
  assert.equal(quantities.get('menu-1'), 3);
  assert.equal(quantities.get('menu-2'), 5);
});

test('원두 판매량은 원두 ID 기준으로 합산한다', () => {
  const quantities = salesQuantitiesByItem('bean', [
    beanItem,
    {...beanItem, weight: 'g500', quantity: 1},
  ]);
  assert.equal(quantities.get('bean-1'), 3);
});

test('결제를 들고 왔으면 어디서 실패하든 되돌린다', () => {
  // 품절·쿠폰·포인트는 결제를 확인하기 전에 던진다. 그때도 돈은 이미 나갔다.
  const failures = [
    new Error('품절된 상품이 포함되어 있습니다. 장바구니를 다시 확인해 주세요.'),
    new Error('상품 가격이 변경되었습니다. 장바구니를 다시 확인해 주세요.'),
    new Error('적용할 수 없는 쿠폰입니다.'),
    new Error('사용 포인트가 결제 금액을 벗어났습니다.'),
    new Error('결제 정보를 확인하지 못했습니다.'),
  ];

  for (const error of failures) {
    assert.equal(
        shouldCancelPayment({paymentKey: 'pay_1', error}),
        true,
        error.message,
    );
  }
});

test('이미 다른 주문이 쓰는 결제는 건드리지 않는다', () => {
  // 중복 제출이다. 취소하면 멀쩡히 성립한 주문의 돈만 돌려주게 된다.
  assert.equal(
      shouldCancelPayment({
        paymentKey: 'pay_1',
        error: new Error(PAYMENT_ALREADY_USED_MESSAGE),
      }),
      false,
  );
});

test('감싼 문구 안에 들어 있어도 알아본다', () => {
  assert.equal(
      shouldCancelPayment({
        paymentKey: 'pay_1',
        error: new Error(`주문 저장 실패 (${PAYMENT_ALREADY_USED_MESSAGE})`),
      }),
      false,
  );
});

test('결제 없는 주문은 되돌릴 것이 없다', () => {
  const error = new Error('적용할 수 없는 쿠폰입니다.');
  assert.equal(shouldCancelPayment({paymentKey: null, error}), false);
  assert.equal(shouldCancelPayment({paymentKey: '', error}), false);
});
