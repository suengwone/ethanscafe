const test = require('node:test');
const {assertFails, assertSucceeds} = require('@firebase/rules-unit-testing');
const {doc, getDoc, setDoc, updateDoc, deleteDoc} = require('firebase/firestore');

const {testEnvironment, seed, admin, user, guest} = require('./helpers');

let env;

const thisYear = new Date().getFullYear();

// 규칙이 통과시키는 최소 형태. 각 테스트가 여기서 한 항목씩만 어긋나게 바꾼다.
function coupon(overrides = {}) {
  return {
    uid: 'me',
    isUsed: false,
    discountAmount: 3000,
    discountRate: 0,
    ...overrides,
  };
}

test.before(async () => {
  env = await testEnvironment('rewards');
});

test.after(async () => {
  await env.cleanup();
});

test.beforeEach(async () => {
  await env.clearFirestore();
});

test('쿠폰은 소유자와 관리자만 읽는다', async () => {
  await seed(env, (db) => setDoc(doc(db, 'coupons/welcome-me'), coupon()));

  await assertSucceeds(
    getDoc(doc(user(env, 'me').firestore(), 'coupons/welcome-me')),
  );
  await assertSucceeds(
    getDoc(doc(admin(env).firestore(), 'coupons/welcome-me')),
  );
  await assertFails(
    getDoc(doc(user(env, 'other').firestore(), 'coupons/welcome-me')),
  );
});

test('자동 발급 쿠폰은 정해진 문서 id로만 만든다', async () => {
  const db = user(env, 'me').firestore();

  await assertSucceeds(setDoc(doc(db, 'coupons/welcome-me'), coupon()));
  await assertSucceeds(
    setDoc(doc(db, `coupons/birthday-${thisYear}-me`), coupon()),
  );
  await assertSucceeds(
    setDoc(doc(db, `coupons/birthday-${thisYear - 1}-me`), coupon()),
  );
});

test('아무 문서 id로나 쿠폰을 만들지 못한다', async () => {
  const db = user(env, 'me').firestore();

  await assertFails(setDoc(doc(db, 'coupons/free-coffee'), coupon()));
  // 내년 생일 쿠폰을 미리 받아 두지 못한다.
  await assertFails(
    setDoc(doc(db, `coupons/birthday-${thisYear + 1}-me`), coupon()),
  );
  // 남의 문서 id로도, 남의 uid를 넣고도 만들지 못한다.
  await assertFails(setDoc(doc(db, 'coupons/welcome-other'), coupon()));
  await assertFails(
    setDoc(doc(db, 'coupons/welcome-me'), coupon({uid: 'other'})),
  );
});

test('한도를 넘는 할인으로 쿠폰을 만들지 못한다', async () => {
  const db = user(env, 'me').firestore();

  await assertFails(
    setDoc(doc(db, 'coupons/welcome-me'), coupon({discountAmount: 3001})),
  );
  await assertFails(
    setDoc(doc(db, 'coupons/welcome-me'), coupon({discountRate: 21})),
  );
  // 이미 쓴 상태로 만들어 두는 것도 막는다.
  await assertFails(
    setDoc(doc(db, 'coupons/welcome-me'), coupon({isUsed: true})),
  );
});

test('소유자는 쿠폰을 사용 처리만 할 수 있다', async () => {
  await seed(env, (db) => setDoc(doc(db, 'coupons/welcome-me'), coupon()));

  await assertSucceeds(
    updateDoc(doc(user(env, 'me').firestore(), 'coupons/welcome-me'), {
      isUsed: true,
    }),
  );
});

test('쓴 쿠폰을 되돌려 다시 쓰지 못한다', async () => {
  await seed(env, (db) =>
    setDoc(doc(db, 'coupons/welcome-me'), coupon({isUsed: true})),
  );

  await assertFails(
    updateDoc(doc(user(env, 'me').firestore(), 'coupons/welcome-me'), {
      isUsed: false,
    }),
  );
});

test('사용 처리에 다른 항목을 얹지 못한다', async () => {
  await seed(env, (db) => setDoc(doc(db, 'coupons/welcome-me'), coupon()));

  await assertFails(
    updateDoc(doc(user(env, 'me').firestore(), 'coupons/welcome-me'), {
      isUsed: true,
      discountAmount: 100000,
    }),
  );
});

test('쿠폰은 관리자만 지운다', async () => {
  await seed(env, (db) => setDoc(doc(db, 'coupons/welcome-me'), coupon()));

  await assertFails(
    deleteDoc(doc(user(env, 'me').firestore(), 'coupons/welcome-me')),
  );
  await assertSucceeds(
    deleteDoc(doc(admin(env).firestore(), 'coupons/welcome-me')),
  );
});

test('초대 실적은 본인이 읽기만 한다', async () => {
  await seed(env, (db) => setDoc(doc(db, 'referrals/me'), {invited: 2}));

  await assertSucceeds(getDoc(doc(user(env, 'me').firestore(), 'referrals/me')));
  await assertSucceeds(getDoc(doc(admin(env).firestore(), 'referrals/me')));
  await assertFails(
    getDoc(doc(user(env, 'other').firestore(), 'referrals/me')),
  );
  await assertFails(
    updateDoc(doc(user(env, 'me').firestore(), 'referrals/me'), {invited: 99}),
  );
  // 보상 지급이 걸려 있어 관리자도 손으로 고치지 못한다.
  await assertFails(
    updateDoc(doc(admin(env).firestore(), 'referrals/me'), {invited: 99}),
  );
});

test('초대 코드 매핑은 아무도 읽지 못한다', async () => {
  await seed(env, (db) => setDoc(doc(db, 'referral_codes/ABC123'), {uid: 'me'}));

  await assertFails(
    getDoc(doc(user(env, 'me').firestore(), 'referral_codes/ABC123')),
  );
  await assertFails(
    getDoc(doc(admin(env).firestore(), 'referral_codes/ABC123')),
  );
  await assertFails(
    getDoc(doc(guest(env).firestore(), 'referral_codes/ABC123')),
  );
  await assertFails(
    setDoc(doc(admin(env).firestore(), 'referral_codes/XYZ789'), {uid: 'me'}),
  );
});
