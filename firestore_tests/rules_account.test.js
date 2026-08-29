const test = require('node:test');
const {assertFails, assertSucceeds} = require('@firebase/rules-unit-testing');
const {doc, getDoc, setDoc, updateDoc, deleteDoc} = require('firebase/firestore');

const {testEnvironment, seed, admin, user, guest} = require('./helpers');

let env;

test.before(async () => {
  env = await testEnvironment('account');
});

test.after(async () => {
  await env.cleanup();
});

test.beforeEach(async () => {
  await env.clearFirestore();
});

test('회원 문서는 본인만 읽고 쓴다', async () => {
  await seed(env, (db) => setDoc(doc(db, 'users/me'), {name: '이선'}));

  await assertSucceeds(getDoc(doc(user(env, 'me').firestore(), 'users/me')));
  await assertSucceeds(
    setDoc(doc(user(env, 'me').firestore(), 'users/me'), {name: '이선'}),
  );
  await assertFails(getDoc(doc(user(env, 'other').firestore(), 'users/me')));
  await assertFails(
    setDoc(doc(user(env, 'other').firestore(), 'users/me'), {name: '남'}),
  );
  await assertFails(getDoc(doc(guest(env).firestore(), 'users/me')));
});

test('개인 설정은 본인만 읽고 쓴다', async () => {
  const collections = [
    'favorites',
    'notificationSettings',
    'fcmTokens',
    'paymentMethods',
    'deliveryAddresses',
  ];

  for (const collection of collections) {
    const mine = `${collection}/me`;
    await assertSucceeds(
      setDoc(doc(user(env, 'me').firestore(), mine), {value: 1}),
    );
    await assertSucceeds(getDoc(doc(user(env, 'me').firestore(), mine)));
    await assertFails(getDoc(doc(user(env, 'other').firestore(), mine)));
    await assertFails(
      setDoc(doc(user(env, 'other').firestore(), mine), {value: 2}),
    );
  }
});

test('포인트 잔액은 본인과 관리자만 읽는다', async () => {
  await seed(env, (db) =>
    setDoc(doc(db, 'points/me'), {balance: 5000, history: []}),
  );

  await assertSucceeds(getDoc(doc(user(env, 'me').firestore(), 'points/me')));
  await assertSucceeds(getDoc(doc(admin(env).firestore(), 'points/me')));
  await assertFails(getDoc(doc(user(env, 'other').firestore(), 'points/me')));
  await assertFails(getDoc(doc(guest(env).firestore(), 'points/me')));
});

test('포인트 문서는 빈 잔액으로만 만들 수 있다', async () => {
  await assertSucceeds(
    setDoc(doc(user(env, 'me').firestore(), 'points/me'), {
      balance: 0,
      history: [],
    }),
  );
});

test('잔액을 미리 채운 포인트 문서는 만들지 못한다', async () => {
  await assertFails(
    setDoc(doc(user(env, 'me').firestore(), 'points/me'), {
      balance: 100000,
      history: [],
    }),
  );
  await assertFails(
    setDoc(doc(user(env, 'me').firestore(), 'points/me'), {
      balance: 0,
      history: [{amount: 100000, reason: '충전'}],
    }),
  );
});

test('본인은 포인트 잔액을 고치거나 지우지 못한다', async () => {
  await seed(env, (db) =>
    setDoc(doc(db, 'points/me'), {balance: 1000, history: []}),
  );

  await assertFails(
    updateDoc(doc(user(env, 'me').firestore(), 'points/me'), {balance: 999999}),
  );
  await assertFails(deleteDoc(doc(user(env, 'me').firestore(), 'points/me')));
  await assertSucceeds(
    updateDoc(doc(admin(env).firestore(), 'points/me'), {balance: 2000}),
  );
});

test('충전 내역은 본인이 읽기만 한다', async () => {
  await seed(env, (db) =>
    setDoc(doc(db, 'points/me/charges/c1'), {amount: 30000}),
  );

  await assertSucceeds(
    getDoc(doc(user(env, 'me').firestore(), 'points/me/charges/c1')),
  );
  await assertFails(
    getDoc(doc(user(env, 'other').firestore(), 'points/me/charges/c1')),
  );
  await assertFails(
    setDoc(doc(user(env, 'me').firestore(), 'points/me/charges/c2'), {
      amount: 30000,
    }),
  );
  // 관리자도 손으로 충전 내역을 넣지 못한다. 서버만 쓴다.
  await assertFails(
    setDoc(doc(admin(env).firestore(), 'points/me/charges/c3'), {
      amount: 30000,
    }),
  );
});
