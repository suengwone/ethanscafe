const test = require('node:test');
const {assertFails, assertSucceeds} = require('@firebase/rules-unit-testing');
const {ref, uploadBytes, getBytes} = require('firebase/storage');

const {testEnvironment, admin, user, guest} = require('./helpers');

let env;

/** 규칙이 통과시키는 최소한의 사진 한 장. */
const photo = new Uint8Array([0xff, 0xd8, 0xff, 0xd9]);
const asJpeg = {contentType: 'image/jpeg'};

test.before(async () => {
  env = await testEnvironment('storage', {storage: true});
});

test.after(async () => {
  await env.cleanup();
});

test.beforeEach(async () => {
  await env.clearStorage();
});

test('상품 사진은 로그인 전에도 보인다', async () => {
  // 홈과 메뉴는 로그인하지 않아도 열린다. 여기서 막으면 사진만 빈칸이 된다.
  await env.withSecurityRulesDisabled(async (context) => {
    await uploadBytes(
        ref(context.storage(), 'products/menu/latte.jpg'), photo, asJpeg);
  });

  await assertSucceeds(
      getBytes(ref(guest(env).storage(), 'products/menu/latte.jpg')));
});

test('사진을 올리는 것은 매장뿐이다', async () => {
  await assertSucceeds(uploadBytes(
      ref(admin(env).storage(), 'products/menu/latte.jpg'), photo, asJpeg));
  await assertFails(uploadBytes(
      ref(user(env, 'me').storage(), 'products/menu/latte.jpg'),
      photo, asJpeg));
  await assertFails(uploadBytes(
      ref(guest(env).storage(), 'products/menu/latte.jpg'), photo, asJpeg));
});

test('사진이 아닌 것은 올리지 못한다', async () => {
  // 관리자 계정 하나로 저장소를 파일 서버처럼 쓰게 두지 않는다.
  await assertFails(uploadBytes(
      ref(admin(env).storage(), 'products/menu/payload.pdf'),
      photo,
      {contentType: 'application/pdf'},
  ));
  await assertFails(uploadBytes(
      ref(admin(env).storage(), 'products/menu/script.html'),
      photo,
      {contentType: 'text/html'},
  ));
});

test('너무 큰 파일은 올리지 못한다', async () => {
  const tooBig = new Uint8Array(5 * 1024 * 1024 + 1);
  await assertFails(uploadBytes(
      ref(admin(env).storage(), 'products/menu/huge.jpg'), tooBig, asJpeg));
});

test('상품 사진 밖의 경로는 닫혀 있다', async () => {
  await assertFails(uploadBytes(
      ref(admin(env).storage(), 'anything/else.jpg'), photo, asJpeg));
  await assertFails(
      getBytes(ref(guest(env).storage(), 'anything/else.jpg')));
});
