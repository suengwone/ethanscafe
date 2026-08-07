const {setGlobalOptions} = require('firebase-functions/v2');
const {onDocumentWritten} = require('firebase-functions/v2/firestore');
const {initializeApp} = require('firebase-admin/app');
const {getFirestore, FieldValue} = require('firebase-admin/firestore');
const {getMessaging} = require('firebase-admin/messaging');

const {collectStatusChangeNotifications} = require('./order_status');

setGlobalOptions({region: 'asia-northeast3'});
initializeApp();

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
