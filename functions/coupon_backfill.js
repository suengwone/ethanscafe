const WELCOME_PREFIX = 'welcome-';
const BIRTHDAY_PATTERN = /^birthday-\d{4}-(.+)$/;

function couponUidFromId(couponId) {
  if (typeof couponId !== 'string') {
    return null;
  }
  if (couponId.startsWith(WELCOME_PREFIX)) {
    const uid = couponId.slice(WELCOME_PREFIX.length);
    return uid.length > 0 ? uid : null;
  }
  const birthday = BIRTHDAY_PATTERN.exec(couponId);
  if (birthday) {
    return birthday[1];
  }
  return null;
}

function collectCouponBackfills(docs) {
  const updates = [];
  let skipped = 0;
  for (const doc of docs) {
    if (typeof doc.uid === 'string' && doc.uid.length > 0) {
      continue;
    }
    const uid = couponUidFromId(doc.id);
    if (uid === null) {
      skipped += 1;
      continue;
    }
    updates.push({id: doc.id, uid});
  }
  return {updates, skipped};
}

module.exports = {
  couponUidFromId,
  collectCouponBackfills,
};
