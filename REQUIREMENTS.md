# Ethan's Cafe 앱 요구사항 정의서

## 1. 개요

| 항목 | 내용 |
|------|------|
| 앱 이름 | Ethan's Cafe |
| 플랫폼 | iOS, Android (Flutter) |
| 목적 | 카페 고객용 멤버십/포인트 적립 및 메뉴 안내 앱 |
| 번들 ID | Android: com.ethanscafe.cafe_app / iOS: com.ethanscafe.cafeApp |

## 2. 기술 스택

| 구분 | 기술 |
|------|------|
| 프레임워크 | Flutter (Dart SDK ^3.12.2) |
| 상태 관리 | Riverpod (flutter_riverpod, riverpod_annotation) |
| 라우팅 | go_router (StatefulShellRoute 탭 셸 + 로그인 리다이렉트) |
| 백엔드 | Firebase (Auth, Firestore, Messaging, Analytics, Crashlytics) |
| 모델/직렬화 | freezed, json_serializable |
| 로컬 저장소 | shared_preferences (게스트/오프라인 폴백) |
| 아키텍처 | Feature-first 구조 (`lib/features/{기능}/{data,domain,presentation}` + `lib/core/{constants,firebase,services,theme,utils,widgets}`) |

> 데이터 레이어 공통 패턴: 기능별 repository 인터페이스(domain)에 대해 Firestore 구현과 로컬 구현을 두고, Firebase 초기화·로그인 여부에 따라 provider에서 선택한다.

## 3. 기능 요구사항

### 3.1 인증 (auth)
- [x] 로그인 화면 UI (`/login`)
- [x] 카카오 로그인 (kakao_flutter_sdk_user, Firebase OIDC `oidc.kakao` 연동)
- [x] 구글 로그인 (google_sign_in)
- [x] Apple 로그인 (iOS)
- [x] 비로그인(게스트) 모드로 둘러보기 (공개 경로 외 접근 시 `/login` 리다이렉트)
- [x] Firebase Auth 연동 및 로그인 상태 유지 (`authStateChanges` 기반)
- [x] 로그아웃

### 3.2 홈 (home)
- [x] 메인 화면 (`/`) — 스타벅스 스타일 홈
  - 인사말 헤더 (로그인 시 닉네임 표시, 게스트는 로그인 버튼)
  - 리워드 카드 (포인트 잔액, 탭 시 포인트 이동)
  - 이벤트 배너 캐러셀 (Firestore `banners` + 로컬 폴백)
  - 추천 메뉴 가로 스크롤 (전체보기 → 메뉴)
- [x] 하단 탭 내비게이션 (홈/주문/페이/마이, StatefulShellRoute)
- [x] 이벤트 배너 (carousel_slider 활용)
- [x] 매장 찾기 화면 (`/stores`, geolocator 현재 위치 기반)
- [x] 알림(공지) 목록 화면 (`/notices`)
- [x] 원두 쇼핑 — 메뉴 원두 탭 + 원두 상세 + 장바구니 (3.3, 3.7 참고)

### 3.3 메뉴 (menu)
- [x] 메뉴 화면 (`/menu`) — 카테고리 탭 4개 (커피/논커피/디저트/원두)
- [x] 메뉴 리스트 (이름, 설명, 가격, NEW 뱃지, 이미지)
- [x] 메뉴 상세 페이지 (`/menu/item/:menuId`)
- [x] Firestore 연동 (`menus` 컬렉션 + 로컬 폴백)
- [x] 메뉴 이미지 표시 (카테고리별 로컬 asset 이미지, `assets/images/menu/`)
- [x] 즐겨찾기 메뉴 등록 (로그인 시 Firestore `favorites`, 게스트는 로컬 저장 / 목록: `/profile/favorites`)

### 3.4 포인트 (points)
- [x] 포인트 화면 (`/points`)
- [x] 결제 1회당 결제 금액의 10% 포인트 적립 (원 단위 내림)
- [x] 적립 포인트를 현금처럼 사용 (잔액 한도 내 차감, 잔액 초과 사용 방지)
- [x] 포인트 잔액 표시
- [x] 멤버십 QR 코드 표시 (qr_flutter, 로컬 생성 멤버십 ID)
- [x] 포인트 히스토리 (적립/사용 내역, 결제 금액 기록)
- [x] 매장측 QR 스캔을 통한 적립 (`/points/scan`, mobile_scanner + Firestore `qrTokens` 1회용 토큰 검증)
- [x] Firestore 연동 (로그인 시 `points` 컬렉션, 게스트는 shared_preferences + 기존 스탬프 멤버십 ID 마이그레이션)

> 변경 이력: 기존 스탬프 적립(10개당 무료 음료 쿠폰) 기능은 폐지되고 포인트 적립/사용 기능으로 대체됨.

### 3.5 내 정보 (profile)
- [x] 프로필 화면 (`/profile`)
- [x] 프로필 헤더 (아바타, 닉네임, 로그인 유도)
- [x] 나의 활동: 주문 내역(`/profile/orders`, 포인트 결제 기록 기반), 쿠폰함(`/profile/coupons`, 뱃지 카운트), 즐겨찾기 메뉴(`/profile/favorites`)
- [x] 설정: 알림 설정(`/profile/notifications`), 결제 수단 관리(`/profile/payment-methods`), 배송지 관리(`/profile/addresses`)
- [x] 기타: 고객센터(`/profile/support`), 이용약관(`/profile/terms`), 개인정보처리방침(`/profile/privacy`), 사업자 정보
- [x] 계정: 로그아웃
- [x] 앱 버전 동적 표시 (package_info_plus)

> 변경 이력: 프로필 사진 변경(image_picker) 요구사항은 폐지됨 (2026-08-07).

### 3.6 알림 (notification)
- [x] 푸시 알림 수신 (firebase_messaging, 백그라운드 핸들러 포함)
- [x] 로컬 알림 표시 (flutter_local_notifications, 포그라운드 수신 시)
- [x] 알림 권한 요청
- [x] FCM 토큰 Firestore 저장 (`fcmTokens`, 로그인 사용자 본인만 관리)
- [x] Android/iOS 네이티브 푸시 설정

### 3.7 원두 쇼핑 (beans)
- [x] 원두 목록 (메뉴 원두 탭, Firestore `beans` + 로컬 폴백)
- [x] 원두 상세 화면 (`/menu/beans/:beanId`, 주문 수량/옵션 바텀시트)
- [x] 원두 장바구니 (`/menu/beans-cart`, 수량 편집·합계·주문 접수 안내)
- [ ] 원두 주문/결제 백엔드 연동 (현재 주문하기는 접수 안내 스낵바만 표시)

## 4. 비기능 요구사항

### 4.1 백엔드/데이터
- Firestore 컬렉션: `users`, `points`, `favorites`, `notificationSettings`, `fcmTokens`, `paymentMethods`, `deliveryAddresses`, `qrTokens`, `menus`, `beans`, `banners`, `notices`, `stores`, `coupons`
- 보안 규칙 (`firestore.rules`):
  - 사용자별 데이터(`users`, `points`, `favorites`, `notificationSettings`, `fcmTokens`, `paymentMethods`, `deliveryAddresses`): 본인만 읽기/쓰기
  - 공개 콘텐츠(`menus`, `beans`, `banners`, `notices`, `stores`, `coupons`): 공개 읽기, 쓰기는 admin 커스텀 클레임
  - `qrTokens`: 생성/삭제는 admin, 사용자는 미사용 토큰을 1회 사용 처리만 가능
- 리전: asia-northeast3 (서울)

### 4.2 권한
| 권한 | 용도 |
|------|------|
| 카메라 | 포인트 적립 QR 스캔 |
| 위치 | 매장 찾기 |
| 알림 | 푸시 알림 |

### 4.3 환경 설정
- Firebase 설정: `lib/firebase_options.dart` 생성 완료 (초기화 실패 시 로컬 폴백으로 동작)
- 카카오 앱 키: `--dart-define=KAKAO_NATIVE_APP_KEY=...`, `--dart-define=KAKAO_JS_APP_KEY=...` 로 주입 (미주입 시 카카오 SDK 초기화 생략)
- Android minSdk 23 이상 적용됨
- 앱 자산: `assets/images/menu/` (메뉴 이미지), Pretendard 폰트 등록됨
- 모니터링: Crashlytics(전역 에러 핸들러 연결), Analytics

## 5. 화면 및 라우팅

| 경로 | 화면 | 상태 |
|------|------|------|
| `/` | 홈 (탭: 홈) | 구현됨 |
| `/notices` | 알림(공지) 목록 | 구현됨 |
| `/stores` | 매장 찾기 | 구현됨 |
| `/login` | 로그인 | 구현됨 (카카오/구글/Apple) |
| `/menu` | 메뉴 (탭: 주문) | 구현됨 |
| `/menu/item/:menuId` | 메뉴 상세 | 구현됨 |
| `/menu/beans/:beanId` | 원두 상세 | 구현됨 |
| `/menu/beans-cart` | 원두 장바구니 | 구현됨 (결제 연동 제외) |
| `/points` | 포인트 (탭: 페이) | 구현됨 |
| `/points/scan` | QR 스캔 적립 | 구현됨 |
| `/profile` | 내 정보 (탭: 마이) | 구현됨 |
| `/profile/orders` | 주문 내역 | 구현됨 |
| `/profile/coupons` | 쿠폰함 | 구현됨 |
| `/profile/favorites` | 즐겨찾기 메뉴 | 구현됨 |
| `/profile/notifications` | 알림 설정 | 구현됨 |
| `/profile/payment-methods` | 결제 수단 관리 | 구현됨 |
| `/profile/addresses` | 배송지 관리 | 구현됨 |
| `/profile/support` | 고객센터 | 구현됨 |
| `/profile/terms` | 이용약관 | 구현됨 |
| `/profile/privacy` | 개인정보처리방침 | 구현됨 |

- `/login`을 제외한 화면은 하단 탭 셸(`AppShell`, 홈/주문/페이/마이) 내부에서 표시된다.
- 공개 경로: `/`, `/login`, `/menu`(하위 포함), `/notices`, `/stores` — 그 외는 로그인 필요.

## 6. 향후 작업 (제안)

1. 원두 장바구니 주문/결제 백엔드 연동 (주문 컬렉션 설계 포함)
2. 실제 주문 시스템 도입 시 주문 내역 화면을 포인트 기록 기반에서 주문 데이터 기반으로 전환
3. 미사용 의존성 정리 (image_picker, flutter_dotenv, webview_flutter 등 사용 여부 재검토)
4. 관리자용 QR 토큰 발급 도구 / 메뉴·배너 관리 방안 마련
