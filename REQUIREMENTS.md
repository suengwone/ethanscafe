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
| 백엔드 | Firebase — Auth, Firestore, Functions, Messaging, Analytics, Crashlytics, Remote Config, Performance |
| 결제 | 토스페이먼츠 (결제창 WebView + 서버 승인) |
| 모델/직렬화 | freezed, json_serializable |
| 로컬 저장소 | shared_preferences (게스트/오프라인 폴백) |
| 아키텍처 | Feature-first (`lib/features/{기능}/{data,domain,presentation}` + `lib/core/{constants,firebase,services,theme,utils,widgets}`) |

> **데이터 레이어 공통 패턴**: 기능별 repository 인터페이스(domain)에 대해 Firestore 구현과 로컬 구현을 두고, Firebase 초기화 여부·로그인 여부에 따라 provider가 선택한다.
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
- ✅ 혼잡도 — 매장이 직접 올리는 값(여유/보통/혼잡). 올린 지 3시간이 지나면 자동으로 숨긴다
- ✅ 매장 공지 — 매장별 한 줄 공지. 목록과 상세에 함께 뜬다

### 4.13 공지 · 알림 (notice / notification)
- ✅ 공지 목록 (`/notices`) — 등록·수정은 카탈로그 관리 공지 탭 (§4.17)
- ✅ 푸시 알림 수신 (`firebase_messaging`, 백그라운드 핸들러 포함)
- ✅ 포그라운드 로컬 알림 (`flutter_local_notifications`)
- ✅ FCM 토큰 Firestore 저장 (`fcmTokens`)
- ✅ 알림 설정 (`/profile/notifications`, `pushEnabled` 존중)
- ✅ 주문 상태 변경 푸시 — Functions `sendBeanOrderStatusPush` (`orders/{uid}` 트리거, FCM 멀티캐스트 + `/profile/orders` 딥링크, 무효 토큰 정리)

### 4.14 내 정보 (profile)
- ✅ 프로필 화면 (`/profile`) — 아바타·닉네임·로그인 유도
- ✅ 나의 활동: 주문 내역, 쿠폰함, 즐겨찾기, 구독, 선물 내역, 친구 초대
- ✅ 설정: 화면 테마 (`/profile/appearance`), 알림 설정, 결제 수단, 배송지 관리 (`/profile/addresses`)
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
- ✅ 크래시 리포팅 (Crashlytics 전역 에러 핸들러), 이벤트 분석 (Analytics)
- ✅ 화면 테마 — 라이트/다크 두 벌을 두고 **시스템 설정 / 라이트 / 다크** 중에서 고른다 (`/profile/appearance`)
  - 색은 `FoxtrotPalette`(`ThemeExtension`)에 담아 밝기별로 한 벌씩 만들고, 화면은 색 상수 대신
    `context.palette`로 읽는다. 화면이 팔레트를 거치지 않고 색을 박아 쓰면 라이트에서 대비가 무너진다
  - 고른 값은 기기에만 남는다 (`shared_preferences`의 `theme_mode`). 계정을 따라다니지 않는다
  - 저장값은 `main`에서 미리 읽어 `storedThemeModeProvider`로 주입한다. 첫 프레임이 다른 테마로
    잠깐 그려지는 것을 막기 위해서다
  - 기본값은 **시스템 설정**

### 4.17 매장 운영 도구 (admin)

포인트 화면의 **직원 모드** 카드에서 들어가는 관리자 전용 화면들. 모두 `admin` 커스텀 클레임이 있어야
쓰기가 통과한다 (콜러블은 클레임을 직접 확인하고, 마스터 데이터는 보안 규칙이 막는다).

- ✅ 주문 관리 (`/points/orders`) — 진행 중인 주문 상태 진행, 매장 취소, 실패한 환불 재시도
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
    직원이 "아직 혼잡"을 갱신할 수 있게 하고, 3시간이 지난 값은 고객 화면에서 숨긴다

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

## 5. 비기능 요구사항

### 5.1 Firestore 컬렉션

| 컬렉션 | 용도 | 클라이언트 접근 |
|--------|------|-----------------|
| `users` | 계정 프로필 | 본인 읽기/쓰기 |
| `points` | 포인트 잔액·히스토리 | 본인 읽기 / **생성만 가능**(잔액 0·히스토리 비어있을 때) / 수정·삭제는 서버 |
| `points/{uid}/charges` | 충전 기록 | 본인 읽기, 쓰기 전면 차단 |
| `favorites` · `notificationSettings` · `fcmTokens` · `paymentMethods` · `deliveryAddresses` | 사용자별 설정 | 본인 읽기/쓰기 |
| `orders` · `pickup_orders` | 주문 (사용자당 1문서에 배열) | 본인 읽기 / 쓰기는 admin·서버만 |
| `subscriptions` · `gifts` · `wholesale_quotes` | 구독·선물·견적 | 본인 읽기/쓰기 |
| `reviews` | 리뷰 | 로그인 사용자 읽기 / 본인만 쓰기 |
| `product_stats` | 판매량 집계 | 공개 읽기 / 쓰기는 admin·서버만 |
| `active_orders` | 진행 중인 주문 색인 (주문 1건 = 문서 1개, 트리거가 유지) | admin 읽기 / 쓰기 전면 차단 |
| `refund_failures` | 취소는 됐으나 환불이 실패한 주문 | admin 읽기 / 쓰기 전면 차단 |
| `coupons` | 쿠폰 | 소유자 읽기 / 자동 쿠폰 생성·`isUsed: true` 처리만 |
| `menus` · `beans` · `banners` · `notices` · `stores` | 마스터 데이터 | 공개 읽기 / 쓰기는 admin |
| `referrals` | 초대 코드·초대 실적 | 본인 읽기 / 쓰기 전면 차단 (서버만) |
| `referral_codes` | 코드 → 회원 매핑 | **읽기·쓰기 전면 차단**. 남의 코드 열거를 막기 위해 서버 전용 |
| `payment_usages` | 결제 멱등 키 | **규칙 미정의 → 전면 차단**. 서버(Admin SDK) 전용 |

> 규칙 최하단에 `match /{document=**} { allow read, write: if false; }` 캐치올이 있어, 명시되지 않은 경로는 기본 차단된다.

### 5.2 Cloud Functions (`functions/`, Node 20, v2, `asia-northeast3`)

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
| `sendPickupOrderStatusPush` | Firestore 트리거 | 픽업 주문 — `active_orders` 색인 갱신 + FCM 푸시 |
| `cleanUpDeletedUserData` | Auth 트리거 (v1 `onDelete`) | 탈퇴 사용자 데이터 정리 |

### 5.3 권한

| 권한 | 용도 | 선언 위치 |
|------|------|-----------|
| 알림 | 푸시 알림 | Android `POST_NOTIFICATIONS`, iOS APNs |
| 카메라 | 관리자 회원 QR 스캔 | iOS `NSCameraUsageDescription` (Android는 `mobile_scanner` 매니페스트 병합) |
| 위치 | 매장 찾기 | iOS `NSLocationWhenInUseUsageDescription` (Android는 `geolocator` 병합) |

### 5.4 환경 설정

- Firebase 설정: `lib/firebase_options.dart` (초기화 실패 시 로컬 폴백 동작)
- 소셜 로그인 키 (`--dart-define`): `KAKAO_NATIVE_APP_KEY`, `KAKAO_JS_APP_KEY`, `NAVER_CLIENT_ID`, `NAVER_CLIENT_SECRET`, `NAVER_URL_SCHEME`
  - ⚠️ `NAVER_CLIENT_SECRET`은 **웹 빌드에 주입 금지** (번들에 포함될 수 있음. 네이버 SDK 초기화는 `!kIsWeb` 가드)
  - iOS 스킴은 `ios/Flutter/SocialLogin.xcconfig`에서 관리
- 토스페이먼츠: `TOSS_CLIENT_KEY` (dart-define), `TOSS_SECRET_KEY` (Functions 시크릿)
- Remote Config 키 (Firebase 콘솔에서 설정 필요): `min_supported_version`, `store_url`, `notice_enabled`, `notice_message` — 미설정 시 기본값이 비어 있어 아무것도 차단하지 않음
- Android: minSdk 23, compileSdk 37, AGP 9.0.1
- 자산: `assets/images/menu/`, Pretendard 폰트

## 6. 화면 및 라우팅

`/login`을 제외한 모든 화면은 하단 탭 셸(`AppShell`) 내부에 표시된다.

공개 경로: `/`, `/login`, `/notices`, `/stores` 및 그 하위(`/stores/:storeId`), `/menu` 및 그 하위 **열람 화면**(`/menu/item/:menuId`, `/menu/beans/:beanId`).
단, `/menu` 하위라도 **거래 흐름은 로그인 필요**: `/menu/cart`, `/menu/beans-cart`, `/menu/gift` (`protectedMenuPaths`).

| 경로 | 화면 | 탭 |
|------|------|-----|
| `/` | 홈 (계정 유형별 분기) | 홈 |
| `/notices` | 공지 목록 | 홈 |
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
| `/profile/support` | 고객센터 | 마이 |
| `/profile/terms` | 이용약관 | 마이 |
| `/profile/privacy` | 개인정보처리방침 | 마이 |

## 7. 백로그 (미구현)

### 7.1 기능

| 추천도 | 기능 | 설명 |
|--------|------|------|
| ★ | 다국어 지원 | 영어 로케일 (`flutter_localizations`) |

### 7.2 기술 · 운영

1. ⬜ Cloud Functions / 보안 규칙 배포 파이프라인
2. ⬜ 토스페이먼츠 운영 키 발급 및 등록 (미설정 시 테스트 키·모의 결제로 동작)
3. ⬜ Remote Config 키 4종 콘솔 등록 (`min_supported_version`, `store_url`, `notice_enabled`, `notice_message`)
4. ⬜ 생체 인증(`local_auth`) 적용 여부 결정 — 적용 시 결제/포인트 사용 중 어디에 걸지 정해야 함
5. ⬜ 매장 지도 SDK 도입 검토 (네이버/카카오 지도 — API 키 및 네이티브 설정 필요)
6. ⬜ 혼잡도 자동 집계 — 현재는 직원이 직접 올린다. 진행 중인 주문 수로 추정할지 결정 필요

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
   - **남은 작업**: 주문 컨트롤러의 레거시 분기(`cloudCheckout == null`)는 아직 코드에 남아 있다. 운영에서는 도달 불가하지만 제거하려면 체크아웃 repository에 인터페이스를 도입하고 테스트 2개 파일을 다시 써야 한다
3. **`FirestoreBeanOrdersRepository` / `FirestorePickupOrdersRepository`의 쓰기 메서드** — 보안 규칙상 클라이언트 쓰기가 차단되어 실행될 수 없는 죽은 경로. 읽기 전용으로 정리할지 결정 필요
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
| 2026-08-19 | 공지 등록·수정 도구 — 카탈로그 관리에 공지 탭 추가. `noticeToFirestore` 직렬화와 게시일(`createdAt`) 편집으로 마스터 데이터 5종을 모두 앱에서 관리한다 |
| 2026-08-19 | 배너·매장 등록·수정 도구 — 상품 관리 화면을 **카탈로그 관리**로 넓혀 탭 4종(메뉴·원두·배너·매장)으로 재구성. `EventBanner`·`CafeStore`에 `sortOrder` 추가 및 쓰기 직렬화. 배너 아이콘 표를 홈 캐러셀과 관리자 화면이 함께 쓰도록 통합 |
| 2026-08-17 | 주문·포인트·쿠폰 쓰기를 Cloud Functions 콜러블로 이관. 보안 규칙 강화 — 서버 가격 검증, 쿠폰 복원 서버 전용화, 판매량 서버 집계. 앱 운영 기능 추가(오프라인 배너·원격 강제 업데이트·리뷰 요청·성능 모니터링). **본 문서를 코드 기준으로 전면 재작성** |
