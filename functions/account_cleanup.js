const USER_DATA_COLLECTIONS = [
  'users',
  'points',
  'favorites',
  'notificationSettings',
  'fcmTokens',
  'paymentMethods',
  'deliveryAddresses',
  'orders',
];

function userDataDocPaths(uid) {
  if (typeof uid !== 'string' || uid.trim().length === 0) {
    throw new Error('유효한 사용자 ID가 필요합니다.');
  }
  return USER_DATA_COLLECTIONS.map((collection) => `${collection}/${uid}`);
}

module.exports = {
  USER_DATA_COLLECTIONS,
  userDataDocPaths,
};
