const test = require('node:test');
const assert = require('node:assert/strict');

const {couponUidFromId, collectCouponBackfills} = require('./coupon_backfill');

test('welcome 쿠폰 id에서 uid를 추출한다', () => {
  assert.equal(couponUidFromId('welcome-user-123'), 'user-123');
  assert.equal(couponUidFromId('welcome-'), null);
});

test('birthday 쿠폰 id에서 uid를 추출한다', () => {
  assert.equal(couponUidFromId('birthday-2026-user-123'), 'user-123');
  assert.equal(couponUidFromId('birthday-user-123'), null);
});

test('패턴에 맞지 않는 id는 null을 반환한다', () => {
  assert.equal(couponUidFromId('event-2026'), null);
  assert.equal(couponUidFromId(null), null);
});

test('uid가 없는 문서만 백필 대상으로 수집한다', () => {
  const {updates, skipped} = collectCouponBackfills([
    {id: 'welcome-user-1', uid: undefined},
    {id: 'birthday-2026-user-2', uid: ''},
    {id: 'welcome-user-3', uid: 'user-3'},
    {id: 'event-2026', uid: undefined},
  ]);

  assert.deepEqual(updates, [
    {id: 'welcome-user-1', uid: 'user-1'},
    {id: 'birthday-2026-user-2', uid: 'user-2'},
  ]);
  assert.equal(skipped, 1);
});
