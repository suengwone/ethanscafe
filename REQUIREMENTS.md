# Ethan's Cafe 앱 요구사항 정의서

> 이 문서는 **실제 코드를 기준으로** 재정리되었다 (2026-08-17).
> 각 항목의 상태는 `✅ 구현됨` / `⬜ 미구현(백로그)`로 표기한다.

## 1. 개요

| 항목 | 내용 |
|------|------|
| 앱 이름 | Ethan's Cafe (표시명: 폭스트롯) |
| 플랫폼 | iOS, Android, Web (Flutter) |
| 목적 | 카페 고객용 주문·멤버십·포인트 앱 **+ 사업자(B2B) 도매 견적 창구** |
| 번들 ID | Android: `com.ethanscafe.cafe_app` / iOS: `com.ethanscafe.cafeApp` |
| Firebase 프로젝트 | `foxtrot-3bdba` (리전 `asia-northeast3`) |

## 2. 사용자 유형

앱은 계정 유형에 따라 **홈 화면이 분기**된다 (`RoleHomeScreen`).

| 유형 | 판별 | 진입 화면 | 권한 |
|------|------|-----------|------|
| 게스트 | 미로그인 | `HomeScreen` | **열람 전용** — 홈·메뉴·원두 상세·공지·매장 찾기만. 장바구니/선물/주문/포인트는 로그인 필요 |
| 고객 (`AccountType.personal`) | 로그인 | `HomeScreen` | 주문·결제·포인트·쿠폰 전 기능 |
| 사업자 (`AccountType.business`) | 로그인 + 사업자 등록 | `BusinessHomeScreen` | 도매 견적 요청/내역 |
| 관리자 | Firebase Auth 커스텀 클레임 `admin: true` | 앱 내 전용 화면 | 포인트 적립 스캔, 마스터 데이터 쓰기 |

## 3. 기술 스택

| 구분 | 기술 |
|------|------|
| 프레임워크 | Flutter (Dart SDK ^3.12.2) |
| 상태 관리 | Riverpod (`flutter_riverpod`, `riverpod_annotation`) |
| 라우팅 | go_router (`StatefulShellRoute` 탭 셸 + 로그인 리다이렉트) |
| 백엔드 | Firebase — Auth, Firestore, Functions, Storage, Messaging, Analytics, Crashlytics, Remote Config, Performance |
| 결제 | 토스페이먼츠 (결제창 WebView + 서버 승인) |
| 모델/직렬화 | freezed, json_serializable |
| 로컬 저장소 | shared_preferences (게스트/오프라인 폴백) |
| 다국어 | `flutter_localizations` + ARB (`lib/l10n/app_ko.arb`, `app_en.arb` → `flutter gen-l10n`) |
| 아키텍처 | Feature-first (`lib/features/{기능}/{data,domain,presentation}` + `lib/core/{constants,firebase,services,theme,utils,widgets}`) |

> **데이터 레이어 공통 패턴**: 기능별 repository 인터페이스(domain)에 대해 Firestore 구현과 로컬 구현을 두고, Firebase 초기화 여부·로그인 여부에 따라 provider가 선택한다.
>
> **문구 원칙**: 화면에 뜨는 말은 도메인 모델이 아니라 ARB에 산다. enum·모델은 사실(상태, 개수, 실패한 까닭)만 들고,
> 문장은 화면이 자기 `AppLocalizations`로 만든다.
>
> **쓰기 경로 원칙**: 금액이 걸린 쓰기(주문 생성/취소, 포인트 적립/사용/충전, 쿠폰 사용, 판매량 집계)는 **전부 Cloud Functions 콜러블을 경유**한다. 클라이언트 직접 쓰기는 보안 규칙에서 차단한다.

## 4. 기능 요구사항

### 4.1 인증 (auth)
- ✅ 로그인 화면 (`/login`)
- ✅ 카카오 로그인 (`kakao_flutter_sdk_user` + Functions `signInWithKakao` 커스텀 토큰, 웹은 OIDC `oidc.kakao`)
- ✅ 네이버 로그인 (`naver_login_sdk` + Functions `signInWithNaver`, 웹은 OAuth 팝업 + 콜백 페이지)
- ✅ 구글 로그인 (`google_sign_in`)
- ✅ Apple 로그인 (iOS 네이티브 / 기타 플랫폼은 Firebase provider 플로우)
- ✅ 게스트 모드 둘러보기 (공개 경로 외 접근 시 `/login` 리다이렉트)
- ✅ 로그인 상태 유지 (`authStateChanges`)
- ✅ 로그아웃 / 회원 탈퇴 (탈퇴 시 Functions `cleanUpDeletedUserData`가 사용자 데이터 정리)
- ✅ 사업자 계정 등록 (`/profile/business`, Functions `registerBusinessProfile`)

### 4.2 홈 (home)
- ✅ 계정 유형별 홈 분기 (`RoleHomeScreen` → 고객 `HomeScreen` / 사업자 `BusinessHomeScreen`)
- ✅ 고객 홈: 인사말 헤더, 리워드 카드(포인트 잔액), 이벤트 배너 캐러셀(`banners`), 추천 메뉴 가로 스크롤
- ✅ 하단 탭 내비게이션 (홈 / 주문 / 페이 / 마이 — `StatefulShellRoute`)

### 4.3 메뉴 (menu)
- ✅ 메뉴 화면 (`/menu`) — 카테고리 **5종**: 드립 커피 / 에스프레소 / 음료 / 티 / 디저트
- ✅ 메뉴 리스트 (이름·설명·가격·NEW/HIT/BEST·품절 뱃지·이미지)
- ✅ 메뉴 상세 (`/menu/item/:menuId`)
- ✅ Firestore `menus` 연동 (Firebase 미초기화 시 로컬 폴백)
- ✅ 메뉴 이미지 (로컬 asset, `assets/images/menu/`)
- ✅ 즐겨찾기 (`favorites`, 목록 `/profile/favorites`)

### 4.4 픽업 주문 (pickup)
- ✅ 픽업 장바구니 (`/menu/cart`) — 매장 선택, 수량 편집, 쿠폰·포인트 적용
- ✅ 주문 생성 — Functions `placeOrder` (`orderType: 'pickup'`)
- ✅ 픽업 번호 자동 채번 (당일 주문 수 기준)
- ✅ 주문 상태: 주문 접수 → 제조 중 → 픽업 대기 → 픽업 완료 / 주문 취소
- ✅ 주문 취소 — Functions `cancelOrder` (고객은 `received`에서만, 포인트 환급·적립 회수·쿠폰 복원·결제 환불 포함)
- ✅ 주문 상태 추적 (`/profile/orders/track/:orderId`)
- ✅ 상태 변경 시 푸시 알림 (제조 중 / 픽업 대기 / 취소)

### 4.5 원두 쇼핑 · 주문 (beans / order)
- ✅ 원두 목록 (메뉴 원두 탭, `beans`) / 원두 상세 (`/menu/beans/:beanId`)
- ✅ 원두 장바구니 (`/menu/beans-cart`) — 용량(200g/500g)·분쇄도 옵션, 수량 편집
- ✅ 수령 방법 선택: 배송 / 매장 픽업
- ✅ 주문 생성 — Functions `placeOrder` (`orderType: 'bean'`)
- ✅ 주문 상태: 주문 접수 → 로스팅 중 → 발송 완료 → 배송 완료 (픽업 시 픽업 대기 → 픽업 완료) / 주문 취소
- ✅ 상태 변경 시 푸시 알림 (로스팅 / 발송 / 배송 완료 / 픽업 대기 / 취소)
- ✅ 주문 내역 (`/profile/orders`) — 원두·픽업 통합 표시
- ✅ 재주문 (주문 내역에서 동일 구성 장바구니 담기, 판매 종료 상품 제외 안내)

### 4.6 결제 (payment)
- ✅ 토스페이먼츠 결제창 (WebView) → Functions 서버 승인
- ✅ 주문 결제: `placeOrder`가 토스 API로 결제 건을 조회·검증한 뒤 주문 확정
- ✅ 멱등 처리: `payment_usages/{paymentKey}` 문서로 동일 결제 중복 사용 차단
- ✅ 실패 시 자동 취소: 주문 저장 실패 시 승인된 결제를 자동 환불
- ✅ 결제 수단 관리 (`/profile/payment-methods`)
- ✅ 서버 카탈로그 검증: 주문 항목의 단가와 품절 여부를 `menus`/`beans`와 대조 (클라이언트 값 신뢰 금지)
- ✅ 주문 취소 시 결제 환불: 취소를 먼저 확정해 중복 요청을 막고 결과를 주문의 `refundStatus`에 기록
- ✅ 환불 진행 상태 노출: 환불이 끝나지 않은 취소 주문은 주문 내역·상태 추적에서 '환불 처리 중/확인 중'으로 표시

### 4.7 포인트 (points)
- ✅ 포인트 화면 (`/points`) — 잔액, 히스토리, 멤버십 QR
- ✅ 적립: 결제 금액의 **고정 10%** (원 단위 내림). 포인트 사용분 제외한 실결제액 기준
- ✅ 사용: 잔액 한도 내 차감 — Functions `usePoints`
- ✅ 멤버십 QR 표시 (`MEMBER-########`, 1분마다 갱신)
- ✅ 매장 적립: 관리자가 회원 QR을 스캔 (`/points/earn-scan`) → Functions `earnPointsByMembership` (**admin 클레임 필수**)
- ✅ 포인트 히스토리 (적립/사용/충전 구분, 결제 금액·보너스 기록)
- ✅ 선불권 충전 (`/points/charge`) — Functions `chargePoints`

  | 선불권 금액 | 충전 포인트 | 보너스 |
  |---|---|---|
  | 10,000원 | 10,000P | — |
  | 30,000원 | 31,000P | +1,000P |
  | 50,000원 | 52,500P | +2,500P |
  | 100,000원 | 107,000P | +7,000P |

  - 보너스 매핑은 클라이언트 상수와 서버에 동일 정의하되 **서버 값을 기준으로 지급**
  - 멱등성: `paymentKey`를 충전 기록(`points/{uid}/charges`)에 저장해 중복 충전 차단
  - 환불: 앱 내 미지원 (고객센터 응대). 게스트 충전 불가

- ✅ **포인트 사용 잠금** (`/profile/security`, `local_auth`) — 포인트를 쓰는 주문을 올리기 직전에 기기 잠금(생체 인증·PIN)으로 본인을 확인한다
  - 포인트는 충전해 둔 현금성 잔액이라 폰을 잃어버리면 그 자리에서 소진된다. 카드 결제는 토스 결제창이 이미 본인을 확인하므로 여기서 또 묻지 않는다
  - 포인트를 쓰지 않는 주문은 묻지 않고 지나간다
  - **걸 잠금이 없는 기기는 통과시킨다.** 막을 수단이 없는데 막으면 그 기기에서는 포인트를 영영 쓰지 못한다. 설정 화면이 그 사실을 적어 준다
  - 여러 번 틀려 기기가 잠갔을 때는 그 까닭을 따로 알린다
  - **포인트가 나가는 길은 세 곳이다** — 픽업 장바구니, 원두 장바구니, 포인트 화면의 직접 사용. 세 곳 모두 같은 잠금을 지난다. 한 곳만 열려 있어도 폰을 주운 사람은 거기로 잔액을 쓴다
  - 잠금 화면을 띄우지 못한 경우(`uiUnavailable`)는 **통과시키지 않는다**. 기기 사정이 아니라 앱 설정 문제이고, 통과로 쳐 주면 잠금을 켜 둔 사람이 지켜지는 줄 안다
  - 네이티브 준비물: Android는 `MainActivity`가 `FlutterFragmentActivity`를 상속하고 테마가 `Theme.AppCompat` 계열이어야 하며(둘 중 하나만 어긋나도 확인이 조용히 건너뛰어진다), iOS는 `NSFaceIDUsageDescription`이 있어야 한다 (없으면 Face ID 기기에서 앱이 종료된다)
  - 켜고 끄는 값은 계정이 아니라 **기기에 저장한다** (`shared_preferences`). 기본은 켜짐

### 4.8 쿠폰 (coupon)
- ✅ 쿠폰함 (`/profile/coupons`) — 사용 가능/사용 완료 탭, 뱃지 카운트
- ✅ 매장 사용 처리 플로우 (바텀시트에서 직원 확인 후 사용 처리)
- ✅ 주문 시 쿠폰 적용 — 정액/정률 할인, 최소 주문 금액 조건, 중복 사용 불가 쿠폰은 1장 제한
- ✅ 웰컴/생일 쿠폰 자동 발급 (`welcome-{uid}`, `birthday-{연도}-{uid}` — 규칙상 자기 소유 ID만, 할인 상한 3,000원 / 20%)
- ✅ 주문 취소 시 쿠폰 복원 — **서버만 수행**. 클라이언트는 `isUsed`를 `true`로만 변경 가능

### 4.9 구독 (subscription)
- ✅ 원두 정기구독 (`/profile/subscriptions`) — 주기 **매주 / 격주 / 매월**
- ✅ 구독 상태 관리 (구독 중 / 일시정지 / 해지됨)

### 4.10 선물 (gift)
- ✅ 원두 선물하기 (`/menu/gift`)
- ✅ 선물 내역 (`/profile/gifts`)

### 4.11 리뷰 (review)
- ✅ 메뉴/원두 리뷰 작성 및 별점
- ✅ 상세 화면 리뷰 노출
- ✅ 판매량 집계 (`product_stats.salesCount`) — **주문 트랜잭션에서 서버가 집계**

### 4.12 매장 (store)
- ✅ 매장 찾기 (`/stores`) — geolocator 현재 위치 기반 정렬
- ✅ 매장 상세 (`/stores/:storeId`) — 오늘 영업 여부, 매장 공지, 평일·주말 영업시간, 편의시설, 전화·지도 연결
- ✅ 영업 중 / 영업 종료 표시 — `09:00 - 21:00` 형태의 영업시간을 해석해 판단하고,
  토·일은 주말 영업시간을 쓴다. 해석되지 않는 문구(휴무 안내 등)면 아무것도 단정하지 않는다
- ✅ 혼잡도 — 직원이 올린 값(여유/보통/혼잡)이 먼저고, 없거나 올린 지 3시간이 지나면
  **진행 중인 픽업 주문 수로 서버가 자동 집계한 값**이 대신 뜬다 (§4.19)
- ✅ 매장 공지 — 매장별 한 줄 공지. 목록과 상세에 함께 뜬다

### 4.13 공지 · 알림 (notice / notification)
- ✅ 공지 목록 (`/notices`) — 등록·수정은 카탈로그 관리 공지 탭 (§4.17)
- ✅ 푸시 알림 수신 (`firebase_messaging`, 백그라운드 핸들러 포함)
- ✅ 포그라운드 로컬 알림 (`flutter_local_notifications`)
- ✅ FCM 토큰 Firestore 저장 (`fcmTokens`)
- ✅ 알림 설정 (`/profile/notifications`, `pushEnabled` 존중)
- ✅ 주문 상태 변경 푸시 — Functions `sendBeanOrderStatusPush` / `sendPickupOrderStatusPush` (주문 문서 트리거, FCM 멀티캐스트 + 딥링크, 무효 토큰 정리)
  - 원두 주문은 `/profile/orders`, 픽업 주문은 `/profile/orders/track/{orderId}`로 보낸다. 픽업은 지금 어느 단계인지가 알림을 누르는 까닭이다
- ✅ 포인트 변동 푸시 — Functions `sendPointsChangePush` (`points/{uid}` 트리거, `/points` 딥링크)
  - 이력 항목의 `id`로 이번 쓰기에 새로 붙은 것만 골라낸다. 쓰는 쪽이 모두 앞에 붙이므로 아는 id를 만나면 멈춘다
  - 한 번의 쓰기에 사용과 적립이 같이 들어오면(주문 결제) 알림 하나로 묶는다. 한 번 결제하고 알림을 두 번 받을 까닭이 없다
  - 주문 취소로 돌려준 포인트는 알리지 않는다. 취소 알림이 이미 "사용하신 포인트와 쿠폰은 돌려드렸어요"라고 말한다. 판별은 취소가 붙여 준 `cancelled` 표시로 한다 — 문구에 '취소'가 들어갔는지로 가리면 사용자가 적는 사용 설명 때문에 멀쩡한 알림이 사라진다
  - 한 번에 다섯 건까지만 알린다. 이력 배열을 통째로 다시 쓰는 일이 생겨도 옛 알림이 쏟아지지 않는다
  - 문구는 받침에 따라 조사를 고른다 (`픽업 주문으로` / `매장 결제로`)
- ✅ 알림 설정의 항목별 토글을 서버가 존중한다 — `pushEnabled`가 꺼져 있으면 전부, `pointsEnabled`가 꺼져 있으면 포인트 알림만 보내지 않는다. **주문 상태는 따로 끄지 못한다** (돈과 물건이 걸린 일이다)
- ✅ **알림함** (`/notifications`) — 보낸 푸시를 앱 안에서 다시 본다
  - 홈·사업자 홈의 종 아이콘이 알림함으로 가고, 안 읽은 수를 뱃지로 얹는다. 게스트는 알림함이 빌 수밖에 없어 공지로 보낸다
  - 항목을 누르면 읽음으로 바뀌고, 알림에 적힌 앱 경로가 있으면 그리로 옮긴다. 앱 경로(`/`로 시작)가 아닌 값은 버린다
  - 모두 읽음 / 밀어서 지우기 / 모두 지우기(확인 후)
  - 서버가 알림함에 남기는 일은 **푸시 설정과 무관하다**. 푸시를 꺼 둔 사람도 앱을 열면 주문이 어디까지 갔는지 볼 수 있어야 한다
  - 항목 id는 `주문id:상태`(포인트는 `points:이력id`)라 트리거가 두 번 돌아도 겹치지 않고, 이미 있는 항목은 그대로 둬 사용자가 표시한 읽음을 되돌리지 않는다
  - 트리거는 같은 사건으로 두 번 불릴 수 있다. **알림함에 실제로 새로 붙은 항목만 푸시**하므로 재실행이 같은 푸시를 다시 보내지 않는다
  - 문서 하나(`notifications/{uid}`)에 배열로 쌓고 최근 50건만 남긴다 — 탈퇴 정리가 문서 삭제 한 번으로 끝나고, 모두 읽음도 쓰기 한 번이면 된다
  - 분류는 **서버가 만들어 주는 것만** 둔다 (주문 / 포인트). 선물은 받는 사람이 계정이 아니라 이름·연락처로 남고, 이벤트는 회원 전체에 뿌리는 일이라 둘 다 알림을 만들 곳이 아직 없다
  - 알림함 적재는 푸시 설정과 무관하지만, **푸시 발송은 항목별 토글을 따른다** (§4.13 알림 설정)
  - 50건 상한은 보안 규칙에서도 지킨다. 문서가 1MiB를 넘으면 서버 쓰기가 조용히 실패해 그 사람만 새 알림을 못 받게 된다

### 4.14 내 정보 (profile)
- ✅ 프로필 화면 (`/profile`) — 아바타·닉네임·로그인 유도
- ✅ 나의 활동: 주문 내역, 쿠폰함, 즐겨찾기, 구독, 선물 내역, 친구 초대
- ✅ 설정: 알림함 (`/notifications`), 알림 설정, 보안 (`/profile/security`), 화면 테마 (`/profile/appearance`), 결제 수단, 배송지 관리 (`/profile/addresses`)
- ✅ 기타: 고객센터, 이용약관, 개인정보처리방침, 사업자 정보
- ✅ 계정: 로그아웃, 회원 탈퇴
- ✅ 앱 버전 동적 표시 (`package_info_plus`)

### 4.15 사업자 · 도매 (wholesale)
- ✅ 사업자 홈 (`BusinessHomeScreen`) — 사업자 계정 로그인 시 기본 진입
- ✅ 사업자 계정 등록 (`/profile/business`) — 상호·사업자번호·담당자·연락처, Functions `registerBusinessProfile`
- ✅ 도매 견적 요청 (`/wholesale/quote`)
- ✅ 견적 내역 (`/wholesale/quotes`)

### 4.16 앱 운영 (core)
- ✅ 오프라인 감지 배너 (`connectivity_plus` — 연결 끊기면 상단 안내)
- ✅ 원격 최소 지원 버전 차단 (`firebase_remote_config` — 구버전이면 업데이트 화면으로 차단)
- ✅ 원격 공지 플래그 (`notice_enabled` / `notice_message`)
- ✅ 스토어 리뷰 요청 (`in_app_review` — 주문 3회 달성 시 1회)
- ✅ 성능 모니터링 (`firebase_performance` — 릴리스 빌드에서만 수집)
- ✅ 크래시 리포팅 (Crashlytics 전역 에러 핸들러)
- ✅ 이벤트 분석 (Analytics) — `add_to_cart` · `begin_checkout` · `purchase` · `order_failed`
  - `order_failed`의 `reason`이 핵심이다. 결제 승인 뒤 서버가 거절하는 일(품절, 가격 변경,
    쿠폰 선점, 포인트 부족)이 얼마나 잦은지는 이 값으로만 보인다
  - 이벤트는 `await` 하지 않는다. 관측이 주문을 기다리게 하면 안 된다
  - Firebase가 뜨지 않은 자리에서는 아무것도 하지 않는 구현이 대신 들어간다
- ✅ 화면 테마 — 라이트/다크 두 벌을 두고 **시스템 설정 / 라이트 / 다크** 중에서 고른다 (`/profile/appearance`)
  - 색은 `FoxtrotPalette`(`ThemeExtension`)에 담아 밝기별로 한 벌씩 만들고, 화면은 색 상수 대신
    `context.palette`로 읽는다. 화면이 팔레트를 거치지 않고 색을 박아 쓰면 라이트에서 대비가 무너진다
  - 고른 값은 기기에만 남는다 (`shared_preferences`의 `theme_mode`). 계정을 따라다니지 않는다
  - 저장값은 `main`에서 미리 읽어 `storedThemeModeProvider`로 주입한다. 첫 프레임이 다른 테마로
    잠깐 그려지는 것을 막기 위해서다
  - 기본값은 **시스템 설정**

- ✅ 다국어 — 한국어와 영어 두 벌을 두고 **시스템 설정 / 한국어 / English** 중에서 고른다 (`/profile/language`)
  - 문구는 `lib/l10n/app_ko.arb`(원본)와 `app_en.arb`에 담고, `flutter gen-l10n`이 `AppLocalizations`를 만든다.
    화면은 `AppLocalizations.of(context)`로 읽는다
  - **enum에 이름을 박지 않는다.** 주문 상태·로스팅 정도·분쇄도처럼 화면에 뜨는 이름은 언어를 타므로
    `<feature>_labels.dart`의 `AppLocalizations` 확장이 꺼내 온다 (예: `l10n.beanOrderStatusLabel(status)`)
  - **모델은 문장을 만들지 않는다.** `firstItemName`·`itemCount`처럼 사실만 들고, "외 N건"은 화면이 붙인다.
    BuildContext가 없는 provider·도메인은 까닭만 올려 보낸다 (`LocationUnavailable`, `MembershipQrException`)
  - 고른 값은 기기에만 남는다 (`shared_preferences`의 `locale`, 비우면 기기 설정). 계정을 따라다니지 않는다
  - 저장값은 `main`에서 미리 읽어 `storedLocaleProvider`로 주입한다. 첫 프레임이 다른 언어로 그려지지 않게 한다
  - 기본값은 **시스템 설정**. 기기 언어가 한국어도 영어도 아니면 한국어로 뜬다

#### 번역하지 않는 것

| 대상 | 왜 |
|------|-----|
| 이용약관 · 개인정보처리방침 본문 | 법적 효력이 있는 문서다. 기계 번역은 원문과 다른 의무를 말할 수 있어, 법률 검토를 거친 번역문이 있을 때만 넣는다. 화면에 한국어 원문만 효력이 있다고 적어 둔다 |
| 포인트 내역 설명 (`원두 주문`, `선불권 충전` 등) | Firestore에 그대로 저장된다. 번역하면 이미 쌓인 내역과 새 내역이 서로 다른 말을 하게 된다 |
| 자동 발급 쿠폰의 제목·설명 | 위와 같다. 쿠폰 문서에 저장되는 값이다 |
| 메뉴·원두·매장·공지·배너 내용 | 매장이 직접 올리는 글이다. 등록된 언어 그대로 보인다 |
| 사업자 등록 정보 값, 네이버 SDK `clientName`, 토스 결제수단 인자(`'카드'`) | 등록된 사실이거나 API 인자다 |
| Android 알림 채널 이름 | `const`로 앱을 켤 때 한 번 등록한다. 그 시점에는 읽는 사람의 언어를 알 수 없다 |


### 4.17 매장 운영 도구 (admin)

포인트 화면의 **직원 모드** 카드에서 들어가는 관리자 전용 화면들. 모두 `admin` 커스텀 클레임이 있어야
쓰기가 통과한다 (콜러블은 클레임을 직접 확인하고, 마스터 데이터는 보안 규칙이 막는다).

- ✅ 주문 관리 (`/points/orders`) — 진행 중인 주문 상태 진행, 매장 취소, 실패한 환불 재시도
  - **환불 실패 탭**에는 주문이 서지 못한 채 남은 결제도 함께 뜬다 (요약이 `주문 미성립 결제`)
- ✅ 회원 QR 스캔 적립 (`/points/earn-scan`)
- ✅ 카탈로그 관리 (`/points/catalog`) — 탭 5종
  - 메뉴 · 원두: 등록·수정·내리기 + 목록에서 품절 토글
  - 배너: 홈 이벤트 배너 등록·수정·내리기 (제목·설명·아이콘·노출 순서)
  - 매장: 매장 등록·수정·내리기 (주소·전화·좌표·영업시간·편의시설·노출 순서·매장 공지·혼잡도)
  - 공지: 공지 등록·수정·내리기 (제목·본문·분류·게시일·중요 표시)
  - 목록 조회가 `sortOrder`(공지는 `createdAt` 내림차순)로 정렬하므로 저장 시 이 필드를
    **항상 함께 쓴다**. 값이 없는 문서는 쿼리에서 통째로 빠져 앱에 보이지 않는다
  - 매장 좌표는 매장 찾기의 거리 정렬에 그대로 쓰이므로 위도 ±90 · 경도 ±180 범위를 입력 단계에서 검증한다
  - 공지의 게시일이 곧 노출 순서다. 날짜만 고르고 시각은 그대로 두어 같은 날 올린 공지끼리의 순서를 지킨다
  - 혼잡도는 고른 시각(`congestionUpdatedAt`)을 함께 저장한다. 같은 값을 다시 골라도 시각만 새로 찍어
    직원이 "아직 혼잡"을 갱신할 수 있게 하고, 3시간이 지난 값은 고객 화면에서 숨긴다.
    숨긴 뒤에는 자동 집계(§4.19)가 그 자리를 메우므로, 직원이 안 눌러도 혼잡도가 비지 않는다

### 4.18 친구 초대 (referral)

- ✅ 초대 코드 발급 (`/profile/referral`) — 계정마다 6자리 코드 1개. 첫 진입 시 `issueReferralCode`가 발급한다
- ✅ 초대 코드 입력 — 친구 코드를 입력하면 **양쪽 모두 3,000P** 즉시 적립 (`redeemReferralCode`)
- ✅ 초대 현황 — 초대한 친구 수, 받은 보상, 남은 초대 횟수
- ✅ 코드·초대 문구 클립보드 복사
- 규칙
  - 코드는 계정당 **한 번만** 입력할 수 있다 (`referrals/{uid}.redeemedCode`)
  - 본인 코드는 사용할 수 없다
  - 초대 보상은 **한 사람당 최대 10명**까지 받는다
  - 코드 글자는 `ABCDEFGHJKLMNPQRSTUVWXYZ23456789` — 0/O, 1/I처럼 받아적기 헷갈리는 글자를 뺐다.
    입력값은 대문자로 맞추고 공백·구분 기호를 지운 뒤 검사한다
  - 보상은 결제가 없는 적립이므로 포인트 히스토리에 `earn` 항목(`친구 초대 보상` / `초대 코드 입력 보상`)으로 남는다
  - 지급 판단·한도 검사·중복 차단은 **전부 서버(콜러블 트랜잭션)** 에서 한다. 클라이언트는 `referrals` 쓰기 권한이 없다

### 4.19 혼잡도 자동 집계 (store activity)

- ✅ 진행 중인 픽업 주문 수로 매장별 혼잡도를 서버가 잰다 (`store_activity/{storeId}`)
- ✅ 매장 찾기·매장 상세가 직원이 올린 값 대신 이 값을 보여 준다. 상세에는
  "진행 중인 주문 N건으로 자동 집계했어요"로 근거를 함께 밝힌다
- 집계 방법
  - 픽업 주문 문서가 바뀔 때(`sendPickupOrderStatusPush`) **상태가 달라진 주문의 매장만** 다시 센다
  - 세는 대상은 `active_orders` 색인 중 `received` · `preparing` 픽업 주문.
    픽업대에 나온(`ready`) 주문은 바를 붙잡지 않으므로 빼고, 이를 위해 색인에 `storeId`를 함께 담는다
  - 매장 단위로 통째로 다시 세므로 트리거가 한 번 실패해 수치가 어긋나도
    그 매장의 다음 주문에서 저절로 맞는다 (증감 방식이면 어긋난 값이 남는다)
  - 단계: **0~2건 여유 / 3~6건 보통 / 7건 이상 혼잡**. 기준은 서버에만 두고
    클라이언트는 서버가 적어 준 단계를 읽기만 한다
- 신선도
  - 밀린 주문(1건 이상)이 **2시간** 넘게 그대로면 직원이 상태를 안 넘긴 것일 수 있어 보여 주지 않는다
  - 반면 **0건은 시간이 지나도 그대로 여유로 본다**. 새 주문이 들어오면 트리거가 곧바로 다시 쓰므로
    오래된 0건은 낡은 값이 아니라 한산하다는 뜻이다
- `store_activity`는 공개 읽기이고 쓰기는 전면 차단한다 (트리거만 쓴다)

## 5. 비기능 요구사항

### 5.1 Firestore 컬렉션

| 컬렉션 | 용도 | 클라이언트 접근 |
|--------|------|-----------------|
| `users` | 계정 프로필 | 본인 읽기/쓰기 |
| `points` | 포인트 잔액·히스토리 | 본인 읽기 / **생성만 가능**(잔액 0·히스토리 비어있을 때) / 수정·삭제는 서버 |
| `points/{uid}/charges` | 충전 기록 | 본인 읽기, 쓰기 전면 차단 |
| `favorites` · `notificationSettings` · `fcmTokens` · `paymentMethods` · `deliveryAddresses` | 사용자별 설정 | 본인 읽기/쓰기 |
| `notifications` | 사용자별 알림함 (최근 50건) | 본인 읽기/쓰기 — `items` 배열 50건 이하만 (새 알림은 서버 트리거가 쓴다) |
| `orders` · `pickup_orders` | 주문 (사용자당 1문서에 배열) | 본인 읽기 / 쓰기는 admin·서버만 |
| `subscriptions` · `gifts` · `wholesale_quotes` | 구독·선물·견적 | 본인 읽기/쓰기 |
| `reviews` | 리뷰 | 로그인 사용자 읽기 / 본인만 쓰기 |
| `product_stats` | 판매량 집계 | 공개 읽기 / 쓰기는 admin·서버만 |
| `active_orders` | 진행 중인 주문 색인 (주문 1건 = 문서 1개, 트리거가 유지) | admin 읽기 / 쓰기 전면 차단 |
| `store_activity` | 매장별 혼잡도 자동 집계 (매장 1곳 = 문서 1개, 트리거가 유지) | 공개 읽기 / 쓰기 전면 차단 |
| `refund_failures` | 취소는 됐으나 환불이 실패한 주문, 그리고 **주문이 서지 못한 채 남은 결제** | admin 읽기 / 쓰기 전면 차단 |

`menus`·`beans` 문서의 `imageUrl`은 매장이 올린 사진의 Storage 주소다. 비어 있으면 화면이
분류별 기본 사진으로 대신한다.

### 5.1.1 Cloud Storage

| 경로 | 용도 | 접근 |
|------|------|------|
| `products/{menu\|bean}/{파일명}` | 매장이 올린 상품 사진 | 공개 읽기 / admin만 쓰기, 5MB 미만 JPEG·PNG·WebP |
| 그 밖 | — | 전면 차단 |

- 읽기를 여는 이유는 홈·메뉴가 로그인 전에 열리기 때문이다. 여기서 막으면 사진만 빈칸이 된다
- 파일명에 시각을 붙인다. 같은 이름으로 덮어쓰면 앱과 CDN이 옛 사진을 한동안 계속 보여 준다
- 앱도 규칙과 **같은 선**(5MB 미만, 이미지 3종)에서 먼저 막는다. 어긋나면 매장이 다 올린 뒤에 거절당한다
| `coupons` | 쿠폰 | 소유자 읽기 / 자동 쿠폰 생성·`isUsed: true` 처리만 |
| `menus` · `beans` · `banners` · `notices` · `stores` | 마스터 데이터 | 공개 읽기 / 쓰기는 admin |
| `referrals` | 초대 코드·초대 실적 | 본인 읽기 / 쓰기 전면 차단 (서버만) |
| `referral_codes` | 코드 → 회원 매핑 | **읽기·쓰기 전면 차단**. 남의 코드 열거를 막기 위해 서버 전용 |
| `payment_usages` | 결제 멱등 키 | **규칙 미정의 → 전면 차단**. 서버(Admin SDK) 전용 |

> 규칙 최하단에 `match /{document=**} { allow read, write: if false; }` 캐치올이 있어, 명시되지 않은 경로는 기본 차단된다.

### 5.2 Cloud Functions (`functions/`, Node 22, v2, `asia-northeast3`)

| 함수 | 종류 | 역할 |
|------|------|------|
| `placeOrder` | callable | 주문 생성 — 카탈로그 단가·품절 대조, 쿠폰 검증, 포인트 차감·적립, 결제 검증·멱등, 판매량 집계 |
| `cancelOrder` | callable | 주문 취소 — 포인트 환급·적립 회수, 쿠폰 복원, 결제 환불. admin은 다른 회원의 진행 중 주문도 취소 가능 |
| `updateOrderStatus` | callable | 주문 상태 한 단계 진행 — **admin 클레임 필수**, 되돌리기·건너뛰기 차단 |
| `retryRefund` | callable | 실패한 환불 재시도 — **admin 클레임 필수**. 결제 상태를 먼저 조회해 이미 취소된 건은 재요청하지 않음 |
| `usePoints` | callable | 포인트 사용 (잔액 검증) |
| `chargePoints` | callable | 선불권 충전 (금액·보너스 검증, 멱등) |
| `earnPointsByMembership` | callable | 매장 적립 — **admin 클레임 필수** |
| `confirmTossPayment` | callable | 토스 결제 승인 (금액 검증) |
| `registerBusinessProfile` | callable | 사업자 계정 등록 |
| `issueReferralCode` | callable | 초대 코드 발급·조회 (없으면 겹치지 않는 코드를 선점해 생성) |
| `redeemReferralCode` | callable | 초대 코드 사용 — 본인·중복·한도 검사 후 양쪽에 보상 적립 |
| `signInWithKakao` / `signInWithNaver` | callable | 소셜 토큰 검증 → Firebase 커스텀 토큰 발급 |
| `backfillCouponUids` | callable | 쿠폰 `uid` 백필 (운영 도구, admin) |
| `backfillActiveOrders` | callable | 진행 중 주문 색인 재생성 (운영 도구, admin — 색인 도입 후 1회) |
| `sendBeanOrderStatusPush` | Firestore 트리거 | 원두 주문 — `active_orders` 색인 갱신 + FCM 푸시 |
| `sendPickupOrderStatusPush` | Firestore 트리거 | 픽업 주문 — `active_orders` 색인 갱신 + 매장 혼잡도 재집계 + FCM 푸시 |
| `sendPointsChangePush` | Firestore 트리거 | 포인트 이력이 붙으면 알림함 적재 + FCM 푸시 |
| `cleanUpDeletedUserData` | Auth 트리거 (v1 `onDelete`) | 탈퇴 사용자 데이터 정리 |

### 5.3 권한

| 권한 | 용도 | 선언 위치 |
|------|------|-----------|
| 알림 | 푸시 알림 | Android `POST_NOTIFICATIONS`, iOS APNs |
| 카메라 | 관리자 회원 QR 스캔 | iOS `NSCameraUsageDescription` (Android는 `mobile_scanner` 매니페스트 병합) |
| 위치 | 매장 찾기 | iOS `NSLocationWhenInUseUsageDescription` (Android는 `geolocator` 병합) |
| 사진 | 매장이 메뉴·원두 사진 등록 | iOS `NSPhotoLibraryUsageDescription` (Android는 `image_picker` 매니페스트 병합) |

### 5.4 환경 설정

- Firebase 설정: `lib/firebase_options.dart` (초기화 실패 시 로컬 폴백 동작)
- 소셜 로그인 키 (`--dart-define`): `KAKAO_NATIVE_APP_KEY`, `KAKAO_JS_APP_KEY`, `NAVER_CLIENT_ID`, `NAVER_CLIENT_SECRET`, `NAVER_URL_SCHEME`
  - ⚠️ `NAVER_CLIENT_SECRET`은 **웹 빌드에 주입 금지** (번들에 포함될 수 있음. 네이버 SDK 초기화는 `!kIsWeb` 가드)
  - iOS 스킴은 `ios/Flutter/SocialLogin.xcconfig`에서 관리
- 토스페이먼츠: `TOSS_CLIENT_KEY` (dart-define), `TOSS_SECRET_KEY` (Functions 시크릿)
- Remote Config 키 4종은 `remoteconfig.template.json`에 **소스로 둔다**: `min_supported_version`, `store_url`, `notice_enabled`, `notice_message`
  - 값도 소스에서 고친다. **콘솔에서 고친 값은 다음 배포에 덮인다** — 공지 문구를 급히 띄우더라도 커밋을 지나가게 해서 무엇이 왜 켜졌는지 남긴다
  - 기본값은 모두 비어 있거나 꺼짐이라, 채우기 전에는 아무것도 차단하지 않고 아무 배너도 뜨지 않는다
- Android: minSdk 23, compileSdk 37, AGP 9.0.1
- 자산: `assets/images/menu/`, Pretendard 폰트

### 5.5 배포 파이프라인 (GitHub Actions)

| 워크플로 | 시점 | 하는 일 |
|----------|------|---------|
| `ci.yml` | PR · `main` 푸시 | `dart format` 확인 · `flutter analyze` · `flutter test` / `functions` 단위 테스트 / 보안 규칙·색인 검사 |
| `deploy.yml` | `main` 푸시 중 `functions/**` · `firestore.rules` · `storage.rules` · `firestore.indexes.json` · `firebase.json`이 바뀐 경우, 또는 수동 실행 | 함수 테스트와 규칙 테스트를 모두 통과하면 규칙·함수를 올리고, Storage 규칙과 색인은 각각 따로 올린다 |

- 자동화 대상은 **서버에 올라가는 것(함수·보안 규칙)뿐**이다. 앱 빌드는 스토어 배포와 묶여 있어 다루지 않는다
- 배포 자격 증명은 저장소 시크릿 `FIREBASE_SERVICE_ACCOUNT`(서비스 계정 키 JSON) 하나다.
  러너가 임시 파일로 풀어 `GOOGLE_APPLICATION_CREDENTIALS`로 넘기고, 성공·실패와 관계없이 지운다
- 함수 시크릿(`TOSS_SECRET_KEY` 등)은 Secret Manager에 있으므로 워크플로가 값을 알 필요가 없다
- `--force`로 소스에서 사라진 함수를 지운다. 손으로 올린 함수가 남아 규칙을 우회하는 일이 없도록 소스를 정답으로 둔다.
  내용이 그대로인 함수는 CLI가 건너뛰므로 규칙만 고쳐도 배포가 길어지지 않는다
- 배포는 겹쳐 돌지 않는다(`concurrency: deploy-firebase`, 취소 없음). 중간에 끊으면 함수 일부만 올라간 상태가 남는다
- 게이트는 함수 테스트와 **보안 규칙 단위 테스트** 둘이다. 규칙 테스트가 깨지면 배포 잡이 시작되지 않는다
- 배포는 세 단계로 나뉜다. 한 명령에 묶으면 아직 준비되지 않은 하나 때문에 나머지가 통째로 막힌다
  - **규칙·함수** — `--force`로 소스에서 사라진 함수를 지운다
  - **Storage 규칙** — 버킷이 없으면 CLI가 맨 앞에서 멈춘다. 그래서 규칙·함수 뒤로 뺐다
  - **색인** — `--force` 없이. 지울 것이 있으면 배포가 멈추고 사람이 본다

#### 보안 규칙 단위 테스트 (`firestore_tests/`)

- Firestore 에뮬레이터 위에서 `@firebase/rules-unit-testing`으로 실제 규칙 파일을 걸고 요청을 던진다. 규칙 문서를 흉내 내지 않고 `firestore.rules`를 그대로 읽는다
- `npm --prefix firestore_tests test` — `firebase emulators:exec`가 에뮬레이터를 띄우고 `node --test`를 돌린 뒤 내린다. **JDK가 필요하다** (에뮬레이터가 JVM에서 돈다)
- 파일로 나눠 두었다: 계정·포인트(`rules_account`), 주문·서버 색인(`rules_orders`), 쿠폰·초대(`rules_rewards`), 카탈로그·기본 차단(`rules_catalog`), 상품 사진(`rules_storage`)
- Storage 규칙은 필요한 파일만 올린다 (`testEnvironment(name, {storage: true})`). 에뮬레이터가 규칙을
  프로젝트별로 두지 않아, 모든 파일이 올리면 나중에 정리하는 쪽이 먼저 돌던 쪽의 규칙을 지운다
- `indexes.test.js`는 에뮬레이터 없이 소스를 훑어 복합 색인이 필요한 쿼리가 `firestore.indexes.json`에
  선언돼 있는지 본다. 처음엔 `.collection(상수)`를 못 읽어 **한 건도 못 찾은 채 통과**했다.
  "선언한 색인은 전부 쓰인다"와 "찾은 쿼리가 0건이면 실패"가 그 빈 통과를 막는다
- `node --test`는 파일마다 프로세스를 따로 띄우므로 파일마다 프로젝트 ID를 달리 준다. 같은 ID를 쓰면 나란히 도는 파일이 서로의 문서를 지운다
- 테스트가 정말 무는지 보려면 규칙을 풀어 놓은 사본을 만들고 `FIRESTORE_RULES=<사본 경로>`로 걸어 본다. 통과하면 그 규칙은 아직 지켜지지 않는 것이다

## 6. 화면 및 라우팅

`/login`을 제외한 모든 화면은 하단 탭 셸(`AppShell`) 내부에 표시된다.

공개 경로: `/`, `/login`, `/notices`, `/stores` 및 그 하위(`/stores/:storeId`), `/menu` 및 그 하위 **열람 화면**(`/menu/item/:menuId`, `/menu/beans/:beanId`).
단, `/menu` 하위라도 **거래 흐름은 로그인 필요**: `/menu/cart`, `/menu/beans-cart`, `/menu/gift` (`protectedMenuPaths`).

| 경로 | 화면 | 탭 |
|------|------|-----|
| `/` | 홈 (계정 유형별 분기) | 홈 |
| `/notices` | 공지 목록 | 홈 |
| `/notifications` | 알림함 | 홈 |
| `/stores` | 매장 찾기 | 홈 |
| `/stores/:storeId` | 매장 상세 | 홈 |
| `/wholesale/quote` | 도매 견적 요청 | 홈 |
| `/wholesale/quotes` | 도매 견적 내역 | 홈 |
| `/login` | 로그인 | — |
| `/menu` | 메뉴 | 주문 |
| `/menu/item/:menuId` | 메뉴 상세 | 주문 |
| `/menu/cart` | 픽업 장바구니 | 주문 |
| `/menu/beans/:beanId` | 원두 상세 | 주문 |
| `/menu/beans-cart` | 원두 장바구니 | 주문 |
| `/menu/gift` | 원두 선물하기 | 주문 |
| `/points` | 포인트 | 페이 |
| `/points/charge` | 선불권 충전 | 페이 |
| `/points/earn-scan` | 관리자 회원 QR 스캔 적립 | 페이 |
| `/points/orders` | 관리자 주문 관리 | 페이 |
| `/points/catalog` | 관리자 카탈로그 관리 (메뉴·원두·배너·매장·공지 등록·수정) | 페이 |
| `/profile` | 내 정보 | 마이 |
| `/profile/orders` | 주문 내역 | 마이 |
| `/profile/orders/track/:orderId` | 주문 상태 추적 | 마이 |
| `/profile/coupons` | 쿠폰함 | 마이 |
| `/profile/favorites` | 즐겨찾기 메뉴 | 마이 |
| `/profile/subscriptions` | 정기구독 관리 | 마이 |
| `/profile/gifts` | 선물 내역 | 마이 |
| `/profile/referral` | 친구 초대 | 마이 |
| `/profile/appearance` | 화면 테마 | 마이 |
| `/profile/notifications` | 알림 설정 | 마이 |
| `/profile/payment-methods` | 결제 수단 관리 | 마이 |
| `/profile/addresses` | 배송지 관리 | 마이 |
| `/profile/business` | 사업자 계정 등록 | 마이 |
| `/profile/security` | 보안 설정 | 마이 |
| `/profile/language` | 언어 설정 | 마이 |
| `/profile/support` | 고객센터 | 마이 |
| `/profile/terms` | 이용약관 | 마이 |
| `/profile/privacy` | 개인정보처리방침 | 마이 |

## 7. 백로그 (미구현)

### 7.1 기능

지금은 비어 있다.

### 7.2 기술 · 운영

1. ⬜ 이용약관·개인정보처리방침의 영문본 — 법률 검토를 거친 번역문이 있어야 넣을 수 있다 (§4.16 참고)
2. ⬜ 저장소 시크릿 `FIREBASE_SERVICE_ACCOUNT` 등록 (미등록 시 `deploy.yml`이 첫 단계에서 멈춘다)
3. ⬜ 토스페이먼츠 운영 키 발급 및 등록 (미설정 시 테스트 키·모의 결제로 동작)
4. ⬜ 매장 지도 SDK 도입 검토 (네이버/카카오 지도 — API 키 및 네이티브 설정 필요)
5. ⬜ `store_url` 채우기 — 스토어에 앱을 올린 뒤 android/ios 조건을 붙인다. 지금은 비어 있어 업데이트 안내의 이동 버튼이 숨는다

## 8. 이번 정리에서 반영한 문서-코드 차이

### 8.1 코드에 있으나 문서에 없던 것 (추가함)

- **사업자(B2B) 라인 전체** — 사업자 계정 유형, 역할별 홈 분기, 도매 견적 요청/내역, `registerBusinessProfile`. 기존 문서에 `도매`라는 단어가 한 번도 없었음
- **픽업 주문(사이렌 오더)** 상세 — 픽업 번호 채번, 상태 5단계, 취소 규칙
- **구독 / 선물 / 리뷰** — 백로그에 "구현 완료" 취소선으로만 남아 있던 것을 기능 항목으로 승격
- **Cloud Functions 9개** — 문서에는 3개만 기재되어 있었음 (실제 12개)
- **Firestore 컬렉션 7종** — `pickup_orders`, `subscriptions`, `gifts`, `wholesale_quotes`, `reviews`, `product_stats`, `payment_usages`, `points/{uid}/charges`
- **앱 운영 기능** — 오프라인 배너, 원격 강제 업데이트, 스토어 리뷰 요청, 성능 모니터링
- **회원 탈퇴 및 데이터 정리**, **재주문**, **주문 상태 추적 화면**
- **서버 경유 쓰기 원칙** — 금액이 걸린 모든 쓰기가 콜러블을 지나도록 바뀐 구조

### 8.2 문서에 있으나 코드에 없던 것 (삭제함)

- **`qrTokens` 1회용 토큰 방식** — 컬렉션·보안 규칙 모두 존재하지 않음. 매장 적립은 **회원 멤버십 QR을 관리자가 스캔**하는 방식(`earnPointsByMembership`)으로 대체됨
- **"카테고리 탭 4개 (커피/논커피/디저트/원두)"** — 실제는 5종(드립 커피/에스프레소/음료/티/디저트)
- **"구독 주기 2주/4주"** — 실제는 매주/격주/매월
- **§6.3 선불권 포인트 충전 상세 기획서** — 구현이 끝나 기획 문서로서의 역할을 다함. 정책·금액표만 §4.7로 옮기고 플로우/체크리스트는 삭제
- **완료된 백로그 7건의 취소선 항목** — 기능 섹션으로 이동
- **"프로필 사진 변경 폐지" 이력** — 관련 기능·의존성이 모두 정리 대상이 되어 §7.2로 통합

### 8.3 판단이 필요한 항목 (미결)

아래는 코드와 문서를 맞추는 것만으로 정리되지 않는, **제품 결정이 필요한** 사항이다.

1. **`webview_flutter`의 위치** — 토스 결제창 전용으로 1개 파일에서만 쓰인다. 결제 SDK 전환 시 제거 대상
2. ~~**게스트 로컬 폴백의 유지 여부**~~ → **결정됨 (2026-08-17): 게스트를 열람 전용으로 축소.**
   비회원 주문은 서버를 거치지 않아 `LocalPaymentsRepository`가 **실제 결제 없이 승인을 반환**하고 픽업 번호까지 발급했다. 매장에 존재하지 않는 주문을 고객이 성립된 것으로 믿을 수 있어 제거했다.
   - 로컬 repository 자체는 **테스트 인프라로 유지**한다 (테스트 63개 파일 중 27개가 의존하며, 골든·라우터 테스트는 Firebase를 초기화하지 않아 전 화면이 로컬 샘플 데이터로 렌더된다)
   - **정리 완료 (2026-08-29)**: 주문 컨트롤러의 레거시 분기(`cloudCheckout == null`)를 없앴다. `BeanCheckout` / `PickupCheckout` 인터페이스를 두고 콜러블과 로컬 구현이 각각 따르므로, 컨트롤러는 둘을 구분하지 않는다
3. ~~**`FirestoreBeanOrdersRepository` / `FirestorePickupOrdersRepository`의 쓰기 메서드**~~ → **결정됨 (2026-08-29): 읽기 전용으로 정리.**
   보안 규칙이 `orders/{uid}`·`pickup_orders/{uid}`의 클라이언트 쓰기를 막아 트랜잭션이 항상 거절당하는 경로였다. 쓰기 쪽은 `WritableBeanOrdersRepository` / `WritablePickupOrdersRepository`로 갈라 로컬 저장소만 구현하게 두고, 그 쓰기를 위해 있던 직렬화 함수(`beanOrdersToFirestore` 등)도 함께 지웠다
4. ~~**다크 모드**~~ → **결정됨 (2026-08-19): 라이트 테마를 지원한다.**
   기본값은 시스템 설정을 따르고, 원하면 `/profile/appearance`에서 고정할 수 있다

## 9. 변경 이력

| 날짜 | 내용 |
|------|------|
| 2026-08-07 | 원두 주문/결제 백엔드 연동, 주문 내역 데이터 기반 전환. 추천도 기반 백로그 도입. 쿠폰 매장 사용 처리 + 주문 상태 푸시 알림. 쿠폰 할인 적용. 프로필 사진 변경 요구사항 폐지 |
| 2026-08-08 | 실결제(PG) 연동 — 토스페이먼츠 결제창 + `confirmTossPayment` 서버 승인 |
| 2026-08-16 | 재주문 구현. 멤버십 등급제 도입 후 폐지(고정 10% 적립률로 환원). 스탬프 적립 폐지 → 포인트 체계로 대체. 선불권 포인트 충전 기획 및 구현 완료 |
| 2026-08-17 | 비회원 주문 폐지 — 장바구니·선물을 로그인 필요로 전환하고 게스트 안내 카드 제거. 게스트는 열람 전용. 미사용 의존성 7종 정리 |
| 2026-08-18 | 매장 운영 도구 3종 — 주문 상태 관리(`updateOrderStatus`), 주문 취소 시 실제 결제 환불 및 매장 취소, 품절 관리. 픽업 주문 푸시 알림과 취소 알림 추가. 주문 관리 화면이 `active_orders` 색인을 읽도록 변경. 환불 실패 건 조회·재시도(`retryRefund`)와 고객 화면 환불 상태 노출. 메뉴·원두 등록·수정 도구 |
| 2026-08-19 | 화면 테마 — 다크 고정에서 라이트/다크 두 벌로 확장. 색 상수를 `FoxtrotPalette` 테마 확장으로 옮기고 화면 46개가 `context.palette`를 읽도록 바꿨다. `/profile/appearance`에서 시스템 설정·라이트·다크를 고르고 기기에 저장한다 |
| 2026-08-19 | 친구 초대 리퍼럴 — `/profile/referral` 신설. 계정별 6자리 초대 코드(`issueReferralCode`)와 코드 입력 시 양쪽 3,000P 지급(`redeemReferralCode`). 한 번만 입력·본인 코드 불가·최대 10명 한도를 서버 트랜잭션에서 검사하고 `referrals`·`referral_codes`는 클라이언트 쓰기를 막았다 |
| 2026-08-19 | 매장 상세 강화 — `/stores/:storeId` 신설. 영업시간 문자열을 해석해 영업 중/종료를 표시하고, 매장 공지와 매장이 직접 올리는 혼잡도(3시간 뒤 자동 숨김)를 `CafeStore`에 추가. 매장 관리 화면에서 둘 다 편집 |
| 2026-08-20 | 배포 파이프라인 — GitHub Actions 도입. `ci.yml`이 PR·`main`에서 `flutter analyze`·`flutter test`와 함수 테스트를 돌리고, `deploy.yml`이 함수·규칙이 바뀐 `main` 푸시에서 함수 테스트를 통과한 뒤 `firestore:rules`와 `functions`를 배포한다. 자격 증명은 시크릿 하나(`FIREBASE_SERVICE_ACCOUNT`)로 좁히고 배포가 겹쳐 돌지 않게 막았다 |
| 2026-08-20 | 혼잡도 자동 집계 — 직원이 올린 값이 없거나 낡으면 진행 중인 픽업 주문 수로 잰 값을 보여 준다. 픽업 주문 트리거가 바뀐 매장만 `active_orders`에서 다시 세어 `store_activity`에 적고(0~2 여유 / 3~6 보통 / 7+ 혼잡), 색인에 `storeId`를 추가했다. 밀린 주문이 2시간 넘게 그대로면 감추되 0건은 그대로 여유로 본다 |
| 2026-08-29 | 보안 규칙 단위 테스트 도입 — 에뮬레이터 위에서 `firestore.rules`를 그대로 걸고 32개 테스트를 돌린다. `ci.yml`·`deploy.yml`이 이를 게이트로 삼아, 규칙이 사람 눈만 거쳐 배포되던 구멍을 막았다 |
| 2026-08-29 | 주문 죽은 경로 정리 — 주문 컨트롤러의 레거시 분기를 없애고 `BeanCheckout`·`PickupCheckout` 인터페이스로 한 갈래를 만들었다. 규칙상 실행될 수 없던 Firestore 주문 저장소의 쓰기 메서드와 직렬화 함수를 지우고, 주문 문서 테스트를 서버가 쓰는 모양으로 다시 썼다 |
| 2026-08-30 | 다국어 지원 — `flutter_localizations`와 ARB 두 벌(779개)을 두고 `/profile/language`에서 시스템 설정·한국어·English를 고른다. 화면 문자열 전부를 l10n으로 옮기면서, 이름을 품고 있던 도메인 enum 12종과 문장을 만들던 모델 게터를 걷어냈다. 법률 문서·저장되는 값·매장이 올린 글은 그대로 두고 그 이유를 문서에 남겼다 |
| 2026-08-30 | 결제 고아 건 차단 — `placeOrder`가 쓰기 트랜잭션에서 실패했을 때만 결제를 되돌렸다. 품절·가격 변경·쿠폰 선점처럼 **결제를 확인하기 전에** 던지는 검사에서는 돈만 빠져나가고 주문도 기록도 없었다. 반대로 중복 제출은 이미 성립한 주문의 결제를 환불했다. 이제 요청이 들어온 순간부터 결제 번호를 붙잡아 어디서 실패하든 되돌리되, `이미 처리된 결제입니다`만 예외로 둔다. 취소까지 실패하면 `refund_failures`로 간다 |
| 2026-08-30 | Firestore 색인을 소스로 — `firestore.indexes.json` 신설. 복합 색인 2종이 콘솔에만 있어 새 환경에서는 주문 관리 화면과 혼잡도 트리거가 깨졌다. 색인은 `--force` 없이 따로 배포한다 |
| 2026-08-30 | 상품 사진 — 매장이 메뉴·원두 사진을 올린다 (Cloud Storage). 없으면 기존처럼 분류별 기본 사진을 쓴다. Storage 보안 규칙과 그 테스트를 함께 넣었다 |
| 2026-08-30 | 관측·정리 — Analytics 이벤트 4종을 실제로 남기기 시작했다(그동안 의존성만 있고 호출은 0건이었다). 미사용 의존성 3종 제거, `dart format` CI 게이트 도입과 전체 정렬, 라벨 없던 컨트롤 5곳에 접근성 이름표 |
| 2026-08-30 | 배포 — 규칙·함수 18개·색인 2개를 운영에 올렸다. 초대 코드 함수 2개는 파이프라인이 계속 실패해 **한 번도 배포된 적이 없었고**, 복합 색인은 콘솔에도 0개라 주문 관리 화면 쿼리가 실제로 깨져 있었다. Storage는 버킷 미설정이라 보류 |
| 2026-08-30 | 엄격 분석 — `strict-casts`·`strict-inference`·`strict-raw-types`를 켜고 콜러블 호출 15곳의 암묵적 `dynamic`을 걷어냈다. 사진은 그리는 크기만큼만 디코딩하고, 바텀시트 6곳은 키보드만 구독한다. 함수 런타임을 Node 22로 올렸다(20은 2026-10-30 지원 종료) |
| 2026-08-19 | 공지 등록·수정 도구 — 카탈로그 관리에 공지 탭 추가. `noticeToFirestore` 직렬화와 게시일(`createdAt`) 편집으로 마스터 데이터 5종을 모두 앱에서 관리한다 |
| 2026-08-19 | 배너·매장 등록·수정 도구 — 상품 관리 화면을 **카탈로그 관리**로 넓혀 탭 4종(메뉴·원두·배너·매장)으로 재구성. `EventBanner`·`CafeStore`에 `sortOrder` 추가 및 쓰기 직렬화. 배너 아이콘 표를 홈 캐러셀과 관리자 화면이 함께 쓰도록 통합 |
| 2026-08-17 | 주문·포인트·쿠폰 쓰기를 Cloud Functions 콜러블로 이관. 보안 규칙 강화 — 서버 가격 검증, 쿠폰 복원 서버 전용화, 판매량 서버 집계. 앱 운영 기능 추가(오프라인 배너·원격 강제 업데이트·리뷰 요청·성능 모니터링). **본 문서를 코드 기준으로 전면 재작성** |
| 2026-08-30 | 알림함 — 보낸 푸시가 기기에서 사라지면 끝이던 것을 `notifications/{uid}` 문서에 최근 50건까지 남기고 `/notifications`에서 다시 보게 했다. 홈 종 아이콘에 안 읽은 수 뱃지를 얹고, 읽음·삭제는 본인이, 새 알림은 주문 상태 트리거가 쓴다. 알림함 적재는 푸시 설정과 분리해 푸시를 꺼 둔 사람도 주문 진행을 볼 수 있다. 두 홈이 따로 갖고 있던 원형 아이콘 버튼은 `CircleIconButton` 하나로 합쳤다 |
| 2026-08-30 | 알림함을 채우는 곳을 늘렸다 — 포인트 트리거(`sendPointsChangePush`)가 적립·사용·충전·초대 보상을 알린다. 한 결제에서 생긴 사용·적립은 알림 하나로 묶고, 취소 환급은 취소 알림이 이미 말하므로 건너뛴다. 저장만 되고 아무도 읽지 않던 알림 설정의 항목별 토글을 서버가 보게 했고(주문 상태는 따로 끄지 못한다), 픽업 알림은 주문 내역이 아니라 추적 화면으로 보낸다. 만들어 주는 곳이 없던 분류 둘(선물·이벤트)은 걷어냈다 |
| 2026-08-30 | 원격 설정을 소스로 — 콘솔에만 있어야 했던 Remote Config 키 4종을 `remoteconfig.template.json`에 적고 배포 파이프라인에 얹었다. 키가 없어 앱이 늘 기본값으로만 돌던 것을 끝내고, 최소 지원 버전·운영 공지를 누가 언제 왜 바꿨는지 커밋에 남긴다 |
| 2026-08-30 | 포인트 사용 잠금 — 포인트를 쓰는 주문 앞에 기기 잠금 확인을 걸었다(`/profile/security`에서 끌 수 있다). 카드 결제는 결제창이 이미 본인을 확인하므로 두 번 묻지 않고, 잠금이 없는 기기는 통과시켜 포인트가 묶이지 않게 했다 |
| 2026-08-30 | Android 빌드 복구 — `firebase_core` 4.14.0이 없앤 심볼을 `firebase_auth` 6.5.6이 아직 부르고 있어 APK가 아예 만들어지지 않았다. CI가 analyze·test만 돌려 아무도 모르고 있었다. `firebase_auth`를 6.6.1로 올려 맞췄다 |
