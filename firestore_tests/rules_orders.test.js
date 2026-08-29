const test = require('node:test');
const {assertFails, assertSucceeds} = require('@firebase/rules-unit-testing');
const {doc, getDoc, setDoc, updateDoc} = require('firebase/firestore');

const {testEnvironment, seed, admin, user, guest} = require('./helpers');

let env;

test.before(async () => {
  env = await testEnvironment('orders');
});

test.after(async () => {
  await env.cleanup();
});

test.beforeEach(async () => {
  await env.clearFirestore();
});

// 원두 주문과 픽업 주문은 규칙이 같다. 금액이 걸려 있어 쓰기는 콜러블만 한다.
for (const collection of ['orders', 'pickup_orders']) {
  test(`${collection}는 본인과 관리자만 읽는다`, async () => {
    await seed(env, (db) => setDoc(doc(db, `${collection}/me`), {orders: []}));

    await assertSucceeds(
      getDoc(doc(user(env, 'me').firestore(), `${collection}/me`)),
    );
    await assertSucceeds(
      getDoc(doc(admin(env).firestore(), `${collection}/me`)),
    );
    await assertFails(
      getDoc(doc(user(env, 'other').firestore(), `${collection}/me`)),
    );
    await assertFails(
      getDoc(doc(guest(env).firestore(), `${collection}/me`)),
    );
  });

  test(`${collection}는 본인도 쓰지 못한다`, async () => {
    await seed(env, (db) => setDoc(doc(db, `${collection}/me`), {orders: []}));

    await assertFails(
      updateDoc(doc(user(env, 'me').firestore(), `${collection}/me`), {
        orders: [{id: 'o1', totalPrice: 0, status: 'ready'}],
      }),
    );
    await assertSucceeds(
      updateDoc(doc(admin(env).firestore(), `${collection}/me`), {
        orders: [{id: 'o1', status: 'ready'}],
      }),
    );
  });
}

// 매장 관리자만 보는 서버 색인. 관리자도 손으로 고치지 못한다.
for (const collection of ['active_orders', 'refund_failures']) {
  test(`${collection}는 관리자만 읽고 아무도 쓰지 못한다`, async () => {
    await seed(env, (db) => setDoc(doc(db, `${collection}/e1`), {storeId: 'macheon'}));

    await assertSucceeds(
      getDoc(doc(admin(env).firestore(), `${collection}/e1`)),
    );
    await assertFails(
      getDoc(doc(user(env, 'me').firestore(), `${collection}/e1`)),
    );
    await assertFails(getDoc(doc(guest(env).firestore(), `${collection}/e1`)));
    await assertFails(
      updateDoc(doc(admin(env).firestore(), `${collection}/e1`), {
        storeId: 'pangyo',
      }),
    );
  });
}

test('혼잡도는 누구나 읽지만 아무도 쓰지 못한다', async () => {
  await seed(env, (db) =>
    setDoc(doc(db, 'store_activity/macheon'), {congestion: 'relaxed'}),
  );

  await assertSucceeds(
    getDoc(doc(guest(env).firestore(), 'store_activity/macheon')),
  );
  await assertFails(
    updateDoc(doc(admin(env).firestore(), 'store_activity/macheon'), {
      congestion: 'busy',
    }),
  );
});

test('판매량 집계는 누구나 읽고 관리자만 쓴다', async () => {
  await seed(env, (db) => setDoc(doc(db, 'product_stats/p1'), {sold: 10}));

  await assertSucceeds(
    getDoc(doc(guest(env).firestore(), 'product_stats/p1')),
  );
  await assertFails(
    updateDoc(doc(user(env, 'me').firestore(), 'product_stats/p1'), {sold: 999}),
  );
  await assertSucceeds(
    updateDoc(doc(admin(env).firestore(), 'product_stats/p1'), {sold: 11}),
  );
});
