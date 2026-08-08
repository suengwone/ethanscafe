const {setGlobalOptions} = require('firebase-functions/v2');
const functionsV1 = require('firebase-functions/v1');
const {onDocumentWritten} = require('firebase-functions/v2/firestore');
const {onCall, HttpsError} = require('firebase-functions/v2/https');
const {defineSecret} = require('firebase-functions/params');
const {initializeApp} = require('firebase-admin/app');
const {getAuth} = require('firebase-admin/auth');
const {getFirestore, FieldValue} = require('firebase-admin/firestore');
const {getMessaging} = require('firebase-admin/messaging');

const {collectStatusChangeNotifications} = require('./order_status');
const {userDataDocPaths} = require('./account_cleanup');
const {
  NAVER_PROFILE_URL,
  validateNaverSignInRequest,
  extractNaverProfile,
  naverUid,
  toUserRecordFields,
} = require('./naver_auth');
const {
  TOSS_CONFIRM_URL,
  validateConfirmRequest,
  toApprovalPayload,
  basicAuthHeader,
} = require('./toss_payment');

setGlobalOptions({region: 'asia-northeast3'});
initializeApp();

const tossSecretKey = defineSecret('TOSS_SECRET_KEY');

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

exports.signInWithNaver = onCall(async (request) => {
  let accessToken;
  try {
    ({accessToken} = validateNaverSignInRequest(request.data));
  } catch (error) {
    throw new HttpsError('invalid-argument', error.message);
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
});

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

exports.sendBeanOrderStatusPush = onDocumentWritten(
  'orders/{uid}',
  async (event) => {
    const before = event.data.before.exists ? event.data.before.data() : null;
    const after = event.data.after.exists ? event.data.after.data() : null;
    const notifications = collectStatusChangeNotifications(before, after);
    if (notifications.length === 0) {
      return;
    }

    const uid = event.params.uid;
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
  },
);
