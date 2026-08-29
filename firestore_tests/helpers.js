const fs = require('node:fs');
const path = require('node:path');
const {initializeTestEnvironment} = require('@firebase/rules-unit-testing');
const {setLogLevel} = require('firebase/firestore');

// 이 테스트는 거절당하는 것이 정상인 요청을 계속 던진다. SDK는 거절을 전부
// error로 찍으므로 그대로 두면 통과한 실행도 빨간 로그로 뒤덮인다.
setLogLevel('silent');

// 평소에는 저장소의 규칙을 그대로 본다. FIRESTORE_RULES로 다른 파일을 가리키면
// 규칙을 일부러 풀어 놓은 사본에 걸어 볼 수 있다. 테스트가 정말 무는지,
// 즉 잘못된 규칙에서 빨간불이 켜지는지 확인하는 용도다.
const rules = fs.readFileSync(
  process.env.FIRESTORE_RULES || path.join(__dirname, '..', 'firestore.rules'),
  'utf8',
);

// node --test는 파일마다 프로세스를 따로 띄운다. 프로젝트 ID가 같으면 나란히
// 도는 파일들이 서로의 문서를 지우므로 파일마다 다른 ID를 준다.
function testEnvironment(name) {
  return initializeTestEnvironment({
    projectId: `cafe-rules-${name}`,
    firestore: {rules},
  });
}

// 읽기·수정 규칙을 보려면 먼저 문서가 있어야 한다. 준비 단계는 규칙을 끄고 쓴다.
function seed(env, write) {
  return env.withSecurityRulesDisabled((context) => write(context.firestore()));
}

const admin = (env) => env.authenticatedContext('admin', {admin: true});
const user = (env, uid) => env.authenticatedContext(uid);
const guest = (env) => env.unauthenticatedContext();

module.exports = {testEnvironment, seed, admin, user, guest};
