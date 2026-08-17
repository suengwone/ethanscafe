const {setGlobalOptions} = require('firebase-functions/v2');
const functionsV1 = require('firebase-functions/v1');
const {onDocumentWritten} = require('firebase-functions/v2/firestore');
const {onCall, HttpsError} = require('firebase-functions/v2/https');
const {defineSecret} = require('firebase-functions/params');
const {initializeApp} = require('firebase-admin/app');
const {getAuth} = require('firebase-admin/auth');
const {getFirestore, FieldValue, Timestamp} = require('firebase-admin/firestore');
const {getMessaging} = require('firebase-admin/messaging');

const {
  collectStatusChangeNotifications,
  orderSummary,
  PICKUP_STATUS_MESSAGES,
} = require('./order_status');
const {
  validateStatusTransition,
  validateUpdateOrderStatusRequest,
} = require('./order_transitions');
const {userDataDocPaths} = require('./account_cleanup');
const {
  NAVER_PROFILE_URL,
  validateNaverSignInRequest,
  buildTokenRequestUrl,
  extractAccessToken,
  extractNaverProfile,
  naverUid,
  toUserRecordFields,
} = require('./naver_auth');
const {
  KAKAO_TOKEN_URL,
  validateKakaoSignInRequest,
  buildKakaoTokenBody,
  extractKakaoTokens,
} = require('./kakao_auth');
const {
  TOSS_CONFIRM_URL,
  validateConfirmRequest,
  toApprovalPayload,
  basicAuthHeader,
  paymentLookupUrl,
  paymentCancelUrl,
  verifyPaymentForOrder,
} = require('./toss_payment');
const {
  validatePlaceOrderRequest,
  validateUsePointsRequest,
  validateEarnByMembershipRequest,
  orderTotalAmount,
  catalogItemIds,
  verifyCatalogItems,
  salesQuantitiesByItem,
  validateCouponsForOrder,
  couponTitlesLabel,
  normalizePointsData,
  applyOrderToPoints,
  applyCancelToPoints,
  nextPickupNumber,
  buildOrderDoc,
  serializeOrder,
  newOrderEntryId,
} = require('./order_checkout');
const {
  REFUND_DONE,
  REFUND_FAILED,
  resolveCancelTarget,
  assertCancellable,
  refundKeyOf,
  cancelledOrderOf,
  cancelReasonOf,
} = require('./order_cancel');
const {
  COLLECTION: ACTIVE_ORDERS_COLLECTION,
  collectActiveOrderWrites,
} = require('./active_orders');
const {
  COLLECTION: REFUND_FAILURES_COLLECTION,
  refundFailureId,
  refundFailureDoc,
  validateRetryRefundRequest,
  refundRetryDecision,
} = require('./refund_failures');
const {collectCouponBackfills} = require('./coupon_backfill');
const {
  validateChargeRequest,
  chargeBonus,
  chargeHistoryEntry,
  chargeResultPayload,
  newMembershipId,
} = require('./points_charge');
const {validateBusinessRegisterRequest} = require('./business_profile');

setGlobalOptions({region: 'asia-northeast3'});
initializeApp();

const tossSecretKey = defineSecret('TOSS_SECRET_KEY');
const naverClientId = defineSecret('NAVER_CLIENT_ID');
const naverClientSecret = defineSecret('NAVER_CLIENT_SECRET');
const kakaoJsAppKey = defineSecret('KAKAO_JS_APP_KEY');
const kakaoClientSecret = defineSecret('KAKAO_CLIENT_SECRET');

exports.registerBusinessProfile = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError('unauthenticated', '로그인이 필요합니다.');
  }

  let business;
  try {
    business = validateBusinessRegisterRequest(request.data);
  } catch (error) {
    throw new HttpsError('invalid-argument', error.message);
  }

  await getFirestore()
    .collection('users')
    .doc(request.auth.uid)
    .set(
      {
        accountType: 'business',
        business: {...business, verifiedAt: FieldValue.serverTimestamp()},
      },
      {merge: true},
    );
  return business;
});

exports.confirmTossPayment = onCall(
  {secrets: [tossSecretKey]},
  async (request) => {
    if (!request.auth) {
      throw new HttpsError('unauthenticated', '로그인이 필요합니다.');
    }

    let confirmRequest;
    try {
      confirmRequest = validateConfirmRequest(request.data);
    } catch (error) {
      throw new HttpsError('invalid-argument', error.message);
    }

    const response = await fetch(TOSS_CONFIRM_URL, {
      method: 'POST',
      headers: {
        'Authorization': basicAuthHeader(tossSecretKey.value()),
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(confirmRequest),
    });
    const payment = await response.json();
    if (!response.ok) {
      throw new HttpsError(
        'failed-precondition',
        payment && payment.message ? payment.message : '결제 승인에 실패했습니다.',
      );
    }

    try {
      return toApprovalPayload(payment, confirmRequest.amount);
    } catch (error) {
      throw new HttpsError('failed-precondition', error.message);
    }
  },
);

exports.chargePoints = onCall(
  {secrets: [tossSecretKey]},
  async (request) => {
    if (!request.auth) {
      throw new HttpsError('unauthenticated', '로그인이 필요합니다.');
    }

    let chargeRequest;
    try {
      chargeRequest = validateChargeRequest(request.data);
    } catch (error) {
      throw new HttpsError('invalid-argument', error.message);
    }

    const {paymentKey, orderId, amount} = chargeRequest;
    const firestore = getFirestore();
    const pointsRef = firestore.collection('points').doc(request.auth.uid);
    const chargeRef = pointsRef.collection('charges').doc(orderId);

    const existing = await chargeRef.get();
    if (existing.exists && existing.data().result) {
      return existing.data().result;
    }

    const response = await fetch(TOSS_CONFIRM_URL, {
      method: 'POST',
      headers: {
        'Authorization': basicAuthHeader(tossSecretKey.value()),
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({paymentKey, orderId, amount}),
    });
    const payment = await response.json();
    if (!response.ok) {
      throw new HttpsError(
        'failed-precondition',
        payment && payment.message ? payment.message : '결제 승인에 실패했습니다.',
      );
    }

    let approval;
    try {
      approval = toApprovalPayload(payment, amount);
    } catch (error) {
      throw new HttpsError('failed-precondition', error.message);
    }

    const bonus = chargeBonus(amount);
    return firestore.runTransaction(async (transaction) => {
      const chargeSnapshot = await transaction.get(chargeRef);
      if (chargeSnapshot.exists && chargeSnapshot.data().result) {
        return chargeSnapshot.data().result;
      }

      const pointsSnapshot = await transaction.get(pointsRef);
      const data = pointsSnapshot.data() || {
        membershipId: newMembershipId(),
        balance: 0,
        history: [],
      };
      const balance = (data.balance || 0) + amount + bonus;
      const entry = chargeHistoryEntry({
        orderId,
        paymentKey,
        amount,
        bonus,
        createdAt: Timestamp.now(),
      });
      transaction.set(pointsRef, {
        ...data,
        balance,
        history: [entry, ...(Array.isArray(data.history) ? data.history : [])],
      });

      const result = chargeResultPayload({
        paymentKey,
        orderId,
        amount,
        bonus,
        method: approval.method,
        balance,
      });
      transaction.set(chargeRef, {
        paymentKey,
        amount,
        bonus,
        createdAt: Timestamp.now(),
        result,
      });
      return result;
    });
  },
);

const ORDER_COLLECTIONS = {bean: 'orders', pickup: 'pickup_orders'};
const ORDER_DESCRIPTIONS = {
  bean: {use: '원두 주문 포인트 사용', earn: '원두 주문', cancel: '원두 주문 취소'},
  pickup: {use: '픽업 주문 포인트 사용', earn: '픽업 주문', cancel: '픽업 주문 취소'},
};

/** 결제를 전액 취소한다. 성공 여부를 돌려주고 예외는 던지지 않는다. */
async function cancelTossPayment(secretKey, paymentKey, cancelReason) {
  try {
    const response = await fetch(paymentCancelUrl(paymentKey), {
      method: 'POST',
      headers: {
        'Authorization': basicAuthHeader(secretKey),
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({cancelReason}),
    });
    if (!response.ok) {
      const body = await response.text().catch(() => '');
      console.error('결제 취소가 거절되었습니다.', paymentKey, response.status,
          body);
      return false;
    }
    return true;
  } catch (error) {
    console.error('결제 취소에 실패했습니다.', paymentKey, error);
    return false;
  }
}

exports.placeOrder = onCall(
  {secrets: [tossSecretKey]},
  async (request) => {
    if (!request.auth) {
      throw new HttpsError('unauthenticated', '로그인이 필요합니다.');
    }

    let orderRequest;
    try {
      orderRequest = validatePlaceOrderRequest(request.data);
    } catch (error) {
      throw new HttpsError('invalid-argument', error.message);
    }

    const uid = request.auth.uid;
    const firestore = getFirestore();

    // 금액을 계산하기 전에 단가가 카탈로그와 일치하는지 서버에서 확인한다.
    const catalogCollection =
        orderRequest.orderType === 'pickup' ? 'menus' : 'beans';
    const itemIds = catalogItemIds(orderRequest.orderType, orderRequest.items);
    const catalogSnapshots = await firestore.getAll(
        ...itemIds.map((id) => firestore.collection(catalogCollection).doc(id)));
    const catalogData = new Map();
    catalogSnapshots.forEach((snapshot, index) => {
      catalogData.set(itemIds[index], snapshot.exists ? snapshot.data() : null);
    });
    try {
      verifyCatalogItems({
        orderType: orderRequest.orderType,
        items: orderRequest.items,
        catalogData,
      });
    } catch (error) {
      throw new HttpsError('failed-precondition', error.message);
    }

    const couponRefs = orderRequest.couponIds.map(
        (id) => firestore.collection('coupons').doc(id));

    const couponSnapshots = couponRefs.length > 0 ?
      await firestore.getAll(...couponRefs) :
      [];
    const coupons = couponSnapshots.map((snapshot) => {
      if (!snapshot.exists) {
        throw new HttpsError('failed-precondition', '적용할 수 없는 쿠폰입니다.');
      }
      return snapshot.data();
    });

    const totalAmount = orderTotalAmount(orderRequest.items);
    let couponDiscount;
    try {
      couponDiscount = validateCouponsForOrder({
        coupons,
        uid,
        orderAmount: totalAmount,
        nowMillis: Date.now(),
      });
    } catch (error) {
      throw new HttpsError('failed-precondition', error.message);
    }

    if (orderRequest.usedPoints > totalAmount - couponDiscount) {
      throw new HttpsError(
          'failed-precondition', '사용 포인트가 결제 금액을 벗어났습니다.');
    }
    const paidAmount =
        totalAmount - couponDiscount - orderRequest.usedPoints;

    let approvedPayment = null;
    if (paidAmount > 0) {
      if (!orderRequest.payment ||
          orderRequest.payment.amount !== paidAmount) {
        throw new HttpsError(
            'failed-precondition', '결제 승인 금액이 주문 금액과 일치하지 않습니다.');
      }
      const response = await fetch(
          paymentLookupUrl(orderRequest.payment.paymentKey), {
            headers: {'Authorization': basicAuthHeader(tossSecretKey.value())},
          });
      const payment = await response.json().catch(() => null);
      if (!response.ok) {
        throw new HttpsError('failed-precondition', '결제 정보를 확인하지 못했습니다.');
      }
      try {
        approvedPayment = verifyPaymentForOrder(payment, {
          orderId: orderRequest.payment.orderId,
          amount: paidAmount,
        });
      } catch (error) {
        throw new HttpsError('failed-precondition', error.message);
      }
    } else if (orderRequest.payment) {
      throw new HttpsError('failed-precondition', '결제가 필요 없는 주문입니다.');
    }

    const descriptions = ORDER_DESCRIPTIONS[orderRequest.orderType];
    const ordersRef = firestore
        .collection(ORDER_COLLECTIONS[orderRequest.orderType])
        .doc(uid);
    const pointsRef = firestore.collection('points').doc(uid);
    const usageRef = approvedPayment ?
      firestore.collection('payment_usages').doc(approvedPayment.paymentKey) :
      null;

    try {
      const result = await firestore.runTransaction(async (transaction) => {
        const ordersSnapshot = await transaction.get(ordersRef);
        const pointsSnapshot = await transaction.get(pointsRef);
        if (usageRef) {
          const usageSnapshot = await transaction.get(usageRef);
          if (usageSnapshot.exists) {
            throw new Error('이미 처리된 결제입니다.');
          }
        }
        const transactionCoupons = [];
        for (const ref of couponRefs) {
          const snapshot = await transaction.get(ref);
          const data = snapshot.exists ? snapshot.data() : null;
          if (!data || data.uid !== uid || data.isUsed === true) {
            throw new Error('적용할 수 없는 쿠폰입니다.');
          }
          transactionCoupons.push(data);
        }

        const now = Timestamp.now();
        const pointsData =
            normalizePointsData(pointsSnapshot.data(), newMembershipId);
        const {earned, data: updatedPoints} = applyOrderToPoints({
          pointsData,
          usedPoints: orderRequest.usedPoints,
          paidAmount,
          useDescription: descriptions.use,
          earnDescription: descriptions.earn,
          createdAt: now,
        });

        const ordersData = ordersSnapshot.data();
        const existingOrders =
            ordersData && Array.isArray(ordersData.orders) ?
              ordersData.orders :
              [];
        const order = buildOrderDoc({
          request: orderRequest,
          orderId: newOrderEntryId(),
          earnedPoints: earned,
          couponTitle: couponTitlesLabel(transactionCoupons),
          couponDiscount,
          paymentMethod: approvedPayment ? approvedPayment.method : null,
          pickupNumber: orderRequest.orderType === 'pickup' ?
            nextPickupNumber(existingOrders, new Date()) :
            null,
          createdAt: now,
        });

        transaction.set(pointsRef, updatedPoints);
        for (const ref of couponRefs) {
          transaction.update(ref, {isUsed: true});
        }
        transaction.set(ordersRef, {orders: [order, ...existingOrders]});
        for (const [productId, quantity] of salesQuantitiesByItem(
            orderRequest.orderType, orderRequest.items)) {
          transaction.set(
              firestore.collection('product_stats').doc(productId),
              {salesCount: FieldValue.increment(quantity)},
              {merge: true},
          );
        }
        if (usageRef) {
          transaction.set(usageRef, {
            uid,
            orderId: order.id,
            createdAt: now,
          });
        }
        return {order, earnedPoints: earned, balance: updatedPoints.balance};
      });
      return {...result, order: serializeOrder(result.order)};
    } catch (error) {
      if (approvedPayment) {
        const cancelled = await cancelTossPayment(
            tossSecretKey.value(),
            approvedPayment.paymentKey,
            '주문 저장 실패 자동 취소',
        );
        throw new HttpsError(
            'aborted',
            cancelled ?
              `주문 저장에 실패해 결제를 자동 취소(환불)했습니다. (${error.message})` :
              '주문 저장에 실패했으나 결제 취소까지 실패했습니다. ' +
                `고객센터로 문의해 주세요. (${error.message})`,
        );
      }
      throw new HttpsError(
          'failed-precondition', error.message || '주문 처리에 실패했습니다.');
    }
  },
);

exports.cancelOrder = onCall({secrets: [tossSecretKey]}, async (request) => {
  if (!request.auth) {
    throw new HttpsError('unauthenticated', '로그인이 필요합니다.');
  }

  let cancelRequest;
  try {
    cancelRequest = resolveCancelTarget({
      data: request.data,
      uid: request.auth.uid,
      isAdmin: request.auth.token.admin === true,
    });
  } catch (error) {
    throw new HttpsError('invalid-argument', error.message);
  }

  const uid = cancelRequest.uid;
  const firestore = getFirestore();
  const descriptions = ORDER_DESCRIPTIONS[cancelRequest.orderType];
  const ordersRef = firestore
      .collection(ORDER_COLLECTIONS[cancelRequest.orderType])
      .doc(uid);
  const pointsRef = firestore.collection('points').doc(uid);

  try {
    const cancelled = await firestore.runTransaction(async (transaction) => {
      const ordersSnapshot = await transaction.get(ordersRef);
      const ordersData = ordersSnapshot.data();
      const orders = ordersData && Array.isArray(ordersData.orders) ?
        ordersData.orders :
        [];
      const index = orders.findIndex(
          (order) => order && order.id === cancelRequest.orderId);
      if (index === -1) {
        throw new Error('주문을 찾을 수 없습니다.');
      }
      const order = orders[index];
      assertCancellable({
        orderType: cancelRequest.orderType,
        order,
        byAdmin: cancelRequest.byAdmin,
      });

      const couponIds =
          typeof order.couponId === 'string' && order.couponId.length > 0 ?
            order.couponId.split(',') :
            [];
      const couponRefs = couponIds.map(
          (id) => firestore.collection('coupons').doc(id));
      const couponSnapshots = [];
      for (const ref of couponRefs) {
        couponSnapshots.push(await transaction.get(ref));
      }

      const usedPoints =
          Number.isInteger(order.usedPoints) ? order.usedPoints : 0;
      const earnedPoints =
          Number.isInteger(order.earnedPoints) ? order.earnedPoints : 0;
      let updatedPoints = null;
      if (usedPoints > 0 || earnedPoints > 0) {
        const pointsSnapshot = await transaction.get(pointsRef);
        updatedPoints = applyCancelToPoints({
          pointsData:
              normalizePointsData(pointsSnapshot.data(), newMembershipId),
          usedPoints,
          earnedPoints,
          description: descriptions.cancel,
          createdAt: Timestamp.now(),
        });
      }

      const cancelledOrder = cancelledOrderOf(order);
      const updatedOrders = [...orders];
      updatedOrders[index] = cancelledOrder;
      transaction.set(ordersRef, {orders: updatedOrders});
      couponSnapshots.forEach((snapshot, couponIndex) => {
        if (snapshot.exists && snapshot.data().uid === uid) {
          transaction.update(couponRefs[couponIndex], {isUsed: false});
        }
      });
      if (updatedPoints) {
        transaction.set(pointsRef, updatedPoints);
      }
      return cancelledOrder;
    });

    // 취소를 먼저 확정해 중복 요청을 막고, 그 뒤에 결제를 환불한다.
    // 환불 결과는 주문 문서에 남겨 실패한 건을 골라낼 수 있게 한다.
    const paymentKey = refundKeyOf(cancelled);
    if (!paymentKey) {
      return {order: serializeOrder(cancelled)};
    }
    const refunded = await cancelTossPayment(
        tossSecretKey.value(),
        paymentKey,
        cancelReasonOf({
          byAdmin: cancelRequest.byAdmin,
          orderType: cancelRequest.orderType,
        }),
    );
    const settled = await patchRefundStatus({
      firestore,
      ordersRef,
      orderId: cancelRequest.orderId,
      status: refunded ? REFUND_DONE : REFUND_FAILED,
    }) ?? cancelled;
    if (!refunded) {
      // 고객 돈이 묶인 상태다. 매장이 목록으로 보고 재시도할 수 있게 남긴다.
      await recordRefundFailure({
        orderType: cancelRequest.orderType,
        uid,
        order: {...settled, summary: orderSummary(settled)},
      });
      throw new HttpsError(
          'internal',
          '주문은 취소했으나 결제 환불에 실패했습니다. 고객센터로 문의해 주세요.',
      );
    }
    return {order: serializeOrder(settled)};
  } catch (error) {
    if (error instanceof HttpsError) {
      throw error;
    }
    throw new HttpsError(
        'failed-precondition', error.message || '주문 취소에 실패했습니다.');
  }
});

async function recordRefundFailure({orderType, uid, order}) {
  await getFirestore()
      .collection(REFUND_FAILURES_COLLECTION)
      .doc(refundFailureId({orderType, uid, orderId: order.id}))
      .set(refundFailureDoc({
        orderType,
        uid,
        order,
        failedAt: Timestamp.now(),
      }));
}

/**
 * 주문 배열에서 한 건의 `refundStatus`만 고쳐 쓰고 그 주문을 돌려준다.
 * 그 사이 다른 주문이 들어올 수 있어 배열을 통째로 덮어쓰지 않고 다시 읽는다.
 */
function patchRefundStatus({firestore, ordersRef, orderId, status}) {
  return firestore.runTransaction(async (transaction) => {
    const snapshot = await transaction.get(ordersRef);
    const data = snapshot.data();
    const orders = data && Array.isArray(data.orders) ? data.orders : [];
    const index = orders.findIndex((order) => order && order.id === orderId);
    if (index === -1) {
      return null;
    }
    const patched = {...orders[index], refundStatus: status};
    const updated = [...orders];
    updated[index] = patched;
    transaction.set(ordersRef, {orders: updated});
    return patched;
  });
}

/**
 * 실패한 환불을 다시 시도한다.
 *
 * 취소 요청이 PG에 닿고 응답만 유실된 경우가 있어, 다시 걸기 전에 결제를 조회한다.
 * 이미 취소돼 있으면 재요청 없이 성공으로 정리한다.
 */
exports.retryRefund = onCall({secrets: [tossSecretKey]}, async (request) => {
  if (!request.auth || request.auth.token.admin !== true) {
    throw new HttpsError('permission-denied', '관리자만 사용할 수 있습니다.');
  }

  let retryRequest;
  try {
    retryRequest = validateRetryRefundRequest(request.data);
  } catch (error) {
    throw new HttpsError('invalid-argument', error.message);
  }

  const firestore = getFirestore();
  const failureRef = firestore
      .collection(REFUND_FAILURES_COLLECTION)
      .doc(refundFailureId(retryRequest));
  const failure = await failureRef.get();
  if (!failure.exists) {
    throw new HttpsError('not-found', '환불 실패 기록을 찾을 수 없습니다.');
  }
  const paymentKey = failure.data().paymentKey;
  if (typeof paymentKey !== 'string' || paymentKey.length === 0) {
    throw new HttpsError('failed-precondition', '환불할 결제 정보가 없습니다.');
  }

  const response = await fetch(paymentLookupUrl(paymentKey), {
    headers: {'Authorization': basicAuthHeader(tossSecretKey.value())},
  });
  const payment = await response.json().catch(() => null);
  if (!response.ok) {
    throw new HttpsError('failed-precondition', '결제 정보를 확인하지 못했습니다.');
  }

  const decision = refundRetryDecision(payment);
  const refunded = decision.action === 'settled' ||
      await cancelTossPayment(
          tossSecretKey.value(), paymentKey, '환불 재시도');

  const ordersRef = firestore
      .collection(ORDER_COLLECTIONS[retryRequest.orderType])
      .doc(retryRequest.uid);
  await patchRefundStatus({
    firestore,
    ordersRef,
    orderId: retryRequest.orderId,
    status: refunded ? REFUND_DONE : REFUND_FAILED,
  });

  if (!refunded) {
    throw new HttpsError('internal', '환불이 다시 실패했습니다.');
  }
  await failureRef.delete();
  return {refunded: true, alreadyCancelled: decision.action === 'settled'};
});

exports.updateOrderStatus = onCall(async (request) => {
  if (!request.auth || request.auth.token.admin !== true) {
    throw new HttpsError('permission-denied', '관리자만 사용할 수 있습니다.');
  }

  let statusRequest;
  try {
    statusRequest = validateUpdateOrderStatusRequest(request.data);
  } catch (error) {
    throw new HttpsError('invalid-argument', error.message);
  }

  const firestore = getFirestore();
  const ordersRef = firestore
      .collection(ORDER_COLLECTIONS[statusRequest.orderType])
      .doc(statusRequest.uid);

  try {
    return await firestore.runTransaction(async (transaction) => {
      const snapshot = await transaction.get(ordersRef);
      const data = snapshot.data();
      const orders = data && Array.isArray(data.orders) ? data.orders : [];
      const index = orders.findIndex(
          (order) => order && order.id === statusRequest.orderId);
      if (index === -1) {
        throw new Error('주문을 찾을 수 없습니다.');
      }

      validateStatusTransition({
        orderType: statusRequest.orderType,
        order: orders[index],
        nextStatus: statusRequest.status,
      });

      const updated = [...orders];
      updated[index] = {...orders[index], status: statusRequest.status};
      transaction.set(ordersRef, {orders: updated});
      return {order: serializeOrder(updated[index])};
    });
  } catch (error) {
    throw new HttpsError(
        'failed-precondition', error.message || '주문 상태 변경에 실패했습니다.');
  }
});

exports.usePoints = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError('unauthenticated', '로그인이 필요합니다.');
  }

  let usePointsRequest;
  try {
    usePointsRequest = validateUsePointsRequest(request.data);
  } catch (error) {
    throw new HttpsError('invalid-argument', error.message);
  }

  const firestore = getFirestore();
  const pointsRef = firestore.collection('points').doc(request.auth.uid);
  try {
    return await firestore.runTransaction(async (transaction) => {
      const snapshot = await transaction.get(pointsRef);
      const pointsData = normalizePointsData(snapshot.data(), newMembershipId);
      if (usePointsRequest.amount > pointsData.balance) {
        throw new Error('포인트 잔액이 부족합니다.');
      }
      const balance = pointsData.balance - usePointsRequest.amount;
      transaction.set(pointsRef, {
        ...pointsData,
        balance,
        history: [
          {
            id: newOrderEntryId(),
            type: 'use',
            description: usePointsRequest.description,
            amount: -usePointsRequest.amount,
            createdAt: Timestamp.now(),
          },
          ...pointsData.history,
        ],
      });
      return {balance};
    });
  } catch (error) {
    throw new HttpsError(
        'failed-precondition', error.message || '포인트 사용에 실패했습니다.');
  }
});

exports.earnPointsByMembership = onCall(async (request) => {
  if (!request.auth || request.auth.token.admin !== true) {
    throw new HttpsError('permission-denied', '관리자만 사용할 수 있습니다.');
  }

  let earnRequest;
  try {
    earnRequest = validateEarnByMembershipRequest(request.data);
  } catch (error) {
    throw new HttpsError('invalid-argument', error.message);
  }

  const firestore = getFirestore();
  const query = await firestore
      .collection('points')
      .where('membershipId', '==', earnRequest.membershipId)
      .limit(1)
      .get();
  if (query.empty) {
    throw new HttpsError('not-found', '등록되지 않은 회원 QR 코드입니다.');
  }
  const pointsRef = query.docs[0].ref;

  return firestore.runTransaction(async (transaction) => {
    const snapshot = await transaction.get(pointsRef);
    const pointsData = normalizePointsData(snapshot.data(), newMembershipId);
    const {earned, data: updatedPoints} = applyOrderToPoints({
      pointsData,
      usedPoints: 0,
      paidAmount: earnRequest.paymentAmount,
      useDescription: '',
      earnDescription: '매장 결제',
      createdAt: Timestamp.now(),
    });
    transaction.set(pointsRef, updatedPoints);
    return {
      membershipId: earnRequest.membershipId,
      paymentAmount: earnRequest.paymentAmount,
      earned,
      balance: updatedPoints.balance,
    };
  });
});

exports.backfillCouponUids = onCall(async (request) => {
  if (!request.auth || request.auth.token.admin !== true) {
    throw new HttpsError('permission-denied', '관리자만 사용할 수 있습니다.');
  }

  const firestore = getFirestore();
  const snapshot = await firestore.collection('coupons').get();
  const {updates, skipped} = collectCouponBackfills(
      snapshot.docs.map((doc) => ({id: doc.id, uid: doc.data().uid})));

  const chunkSize = 400;
  for (let start = 0; start < updates.length; start += chunkSize) {
    const batch = firestore.batch();
    for (const update of updates.slice(start, start + chunkSize)) {
      batch.update(
          firestore.collection('coupons').doc(update.id), {uid: update.uid});
    }
    await batch.commit();
  }
  return {updated: updates.length, skipped};
});

/**
 * 진행 중인 주문 색인을 처음부터 다시 만든다.
 *
 * 색인은 주문 문서가 바뀔 때만 갱신되므로, 색인을 도입하기 전에 들어온 주문은
 * 아무도 건드리지 않으면 매장 화면에 영영 나타나지 않는다. 배포 직후 한 번 돌린다.
 */
exports.backfillActiveOrders = onCall(async (request) => {
  if (!request.auth || request.auth.token.admin !== true) {
    throw new HttpsError('permission-denied', '관리자만 사용할 수 있습니다.');
  }

  const firestore = getFirestore();
  let indexed = 0;
  for (const [orderType, collection] of Object.entries(ORDER_COLLECTIONS)) {
    const snapshot = await firestore.collection(collection).get();
    for (const doc of snapshot.docs) {
      // 색인이 비어 있다고 보고 전체를 다시 쓴다.
      const writes = collectActiveOrderWrites({
        orderType,
        uid: doc.id,
        beforeData: null,
        afterData: doc.data(),
      });
      if (writes.length === 0) {
        continue;
      }
      const batch = firestore.batch();
      for (const write of writes) {
        batch.set(
            firestore.collection(ACTIVE_ORDERS_COLLECTION).doc(write.id),
            write.doc,
        );
      }
      await batch.commit();
      indexed += writes.length;
    }
  }
  return {indexed};
});

exports.signInWithKakao = onCall(
  {secrets: [kakaoJsAppKey, kakaoClientSecret]},
  async (request) => {
    let signInRequest;
    try {
      signInRequest = validateKakaoSignInRequest(request.data);
    } catch (error) {
      throw new HttpsError('invalid-argument', error.message);
    }

    const response = await fetch(KAKAO_TOKEN_URL, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded;charset=utf-8',
      },
      body: buildKakaoTokenBody({
        clientId: kakaoJsAppKey.value(),
        clientSecret: kakaoClientSecret.value(),
        code: signInRequest.code,
        redirectUri: signInRequest.redirectUri,
      }),
    });
    const body = await response.json().catch(() => null);
    if (!response.ok) {
      throw new HttpsError('unauthenticated', '카카오 인증에 실패했습니다.');
    }
    try {
      return extractKakaoTokens(body);
    } catch (error) {
      throw new HttpsError('unauthenticated', '카카오 인증에 실패했습니다.');
    }
  },
);

exports.signInWithNaver = onCall(
  {secrets: [naverClientId, naverClientSecret]},
  async (request) => {
  let signInRequest;
  try {
    signInRequest = validateNaverSignInRequest(request.data);
  } catch (error) {
    throw new HttpsError('invalid-argument', error.message);
  }

  let accessToken = signInRequest.accessToken;
  if (!accessToken) {
    const tokenResponse = await fetch(
      buildTokenRequestUrl({
        clientId: naverClientId.value(),
        clientSecret: naverClientSecret.value(),
        code: signInRequest.code,
        state: signInRequest.state,
      }),
    );
    const tokenBody = await tokenResponse.json().catch(() => null);
    if (!tokenResponse.ok) {
      throw new HttpsError('unauthenticated', '네이버 인증에 실패했습니다.');
    }
    try {
      accessToken = extractAccessToken(tokenBody);
    } catch (error) {
      throw new HttpsError('unauthenticated', '네이버 인증에 실패했습니다.');
    }
  }

  const response = await fetch(NAVER_PROFILE_URL, {
    headers: {'Authorization': `Bearer ${accessToken}`},
  });
  const body = await response.json().catch(() => null);
  if (!response.ok) {
    throw new HttpsError('unauthenticated', '네이버 인증에 실패했습니다.');
  }

  let profile;
  try {
    profile = extractNaverProfile(body);
  } catch (error) {
    throw new HttpsError('unauthenticated', '네이버 인증에 실패했습니다.');
  }

  const uid = naverUid(profile);
  const fields = toUserRecordFields(profile);
  const auth = getAuth();
  try {
    await upsertNaverUser(auth, uid, fields);
  } catch (error) {
    if (error.code === 'auth/email-already-exists') {
      delete fields.email;
      await upsertNaverUser(auth, uid, fields);
    } else {
      throw new HttpsError('internal', '네이버 로그인 처리에 실패했습니다.');
    }
  }

  const token = await auth.createCustomToken(uid, {provider: 'naver'});
  return {token};
  },
);

async function upsertNaverUser(auth, uid, fields) {
  try {
    await auth.updateUser(uid, fields);
  } catch (error) {
    if (error.code === 'auth/user-not-found') {
      await auth.createUser({uid, ...fields});
    } else {
      throw error;
    }
  }
}

exports.cleanUpDeletedUserData = functionsV1
  .region('asia-northeast3')
  .auth.user()
  .onDelete(async (user) => {
    const firestore = getFirestore();
    const batch = firestore.batch();
    for (const path of userDataDocPaths(user.uid)) {
      batch.delete(firestore.doc(path));
    }
    await batch.commit();
  });

const ORDER_HISTORY_ROUTE = '/profile/orders';
const ANDROID_CHANNEL_ID = 'high_importance_channel';
const INVALID_TOKEN_CODES = [
  'messaging/invalid-registration-token',
  'messaging/registration-token-not-registered',
  'messaging/invalid-argument',
];

/**
 * 주문 상태 변경 알림 발송. 원두·픽업 트리거가 공유한다.
 * 알림 설정이 꺼져 있거나 토큰이 없으면 조용히 끝낸다.
 */
async function pushOrderStatusNotifications(uid, notifications) {
  if (notifications.length === 0) {
    return;
  }
  {
    const firestore = getFirestore();

    const settingsSnapshot = await firestore
      .collection('notificationSettings')
      .doc(uid)
      .get();
    const settings = settingsSnapshot.data();
    if (settings && settings.pushEnabled === false) {
      return;
    }

    const tokensSnapshot = await firestore
      .collection('fcmTokens')
      .doc(uid)
      .get();
    const tokensData = tokensSnapshot.data();
    const tokens = (
      tokensData && Array.isArray(tokensData.tokens) ? tokensData.tokens : []
    ).filter((token) => typeof token === 'string' && token.length > 0);
    if (tokens.length === 0) {
      return;
    }

    const messaging = getMessaging();
    const invalidTokens = new Set();
    for (const notification of notifications) {
      const response = await messaging.sendEachForMulticast({
        tokens,
        notification: {
          title: notification.title,
          body: notification.body,
        },
        data: {
          route: ORDER_HISTORY_ROUTE,
          orderId: notification.orderId,
          status: notification.status,
        },
        android: {
          priority: 'high',
          notification: {channelId: ANDROID_CHANNEL_ID},
        },
        apns: {payload: {aps: {sound: 'default'}}},
      });
      response.responses.forEach((result, index) => {
        if (result.error && INVALID_TOKEN_CODES.includes(result.error.code)) {
          invalidTokens.add(tokens[index]);
        }
      });
    }

    if (invalidTokens.size > 0) {
      await firestore
        .collection('fcmTokens')
        .doc(uid)
        .set(
          {tokens: FieldValue.arrayRemove(...invalidTokens)},
          {merge: true},
        );
    }
  }
}

/** 진행 중인 주문 색인을 주문 문서 변경에 맞춰 갱신한다. */
async function syncActiveOrders({orderType, uid, beforeData, afterData}) {
  const writes = collectActiveOrderWrites({
    orderType,
    uid,
    beforeData,
    afterData,
  });
  if (writes.length === 0) {
    return;
  }
  const firestore = getFirestore();
  const batch = firestore.batch();
  for (const write of writes) {
    const ref = firestore.collection(ACTIVE_ORDERS_COLLECTION).doc(write.id);
    if (write.type === 'delete') {
      batch.delete(ref);
    } else {
      batch.set(ref, write.doc);
    }
  }
  await batch.commit();
}

exports.sendBeanOrderStatusPush = onDocumentWritten(
  'orders/{uid}',
  async (event) => {
    const before = event.data.before.exists ? event.data.before.data() : null;
    const after = event.data.after.exists ? event.data.after.data() : null;
    await syncActiveOrders({
      orderType: 'bean',
      uid: event.params.uid,
      beforeData: before,
      afterData: after,
    });
    await pushOrderStatusNotifications(
        event.params.uid,
        collectStatusChangeNotifications(before, after),
    );
  },
);

exports.sendPickupOrderStatusPush = onDocumentWritten(
  'pickup_orders/{uid}',
  async (event) => {
    const before = event.data.before.exists ? event.data.before.data() : null;
    const after = event.data.after.exists ? event.data.after.data() : null;
    await syncActiveOrders({
      orderType: 'pickup',
      uid: event.params.uid,
      beforeData: before,
      afterData: after,
    });
    await pushOrderStatusNotifications(
        event.params.uid,
        collectStatusChangeNotifications(
            before, after, PICKUP_STATUS_MESSAGES),
    );
  },
);
