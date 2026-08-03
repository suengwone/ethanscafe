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
| 라우팅 | go_router |
| 백엔드 | Firebase (Auth, Firestore, Storage, Messaging, Analytics, Crashlytics, Functions) |
| 모델/직렬화 | freezed, json_serializable |
| 로컬 저장소 | shared_preferences |
| 아키텍처 | Feature-first 구조 (`lib/features/{기능}/{data,domain,presentation}` + `lib/core/{constants,services,utils,widgets}`) |

## 3. 기능 요구사항

### 3.1 인증 (auth)
- [x] 로그인 화면 UI (`/login`)
- [ ] 카카오 로그인 (kakao_flutter_sdk_user)
- [ ] 구글 로그인 (google_sign_in)
- [ ] Apple 로그인 (sign_in_with_apple, iOS 필수)
- [x] 비로그인(게스트) 모드로 둘러보기
- [ ] Firebase Auth 연동 및 로그인 상태 유지
- [ ] 로그아웃

### 3.2 홈 (home)
- [x] 메인 화면 (`/`) — 6개 기능 카드 그리드
  - 메뉴, 포인트, 매장 찾기, 알림, 원두 쇼핑, 내 정보
- [ ] 매장 찾기 화면 (geolocator 활용, `features/store` 폴더만 생성됨)
- [ ] 알림 목록 화면 (`features/notice` 폴더만 생성됨)
- [ ] 원두 쇼핑 화면 (미구현)
- [ ] 이벤트 배너 (carousel_slider 활용 예정)

### 3.3 메뉴 (menu)
- [x] 메뉴 화면 (`/menu`) — 카테고리 탭 4개
  - 커피 / 논커피 / 디저트 / 원두
- [x] 메뉴 리스트 (이름, 설명, 가격, NEW 뱃지)
- [ ] 메뉴 상세 페이지 (미구현)
- [ ] Firestore 연동 (현재 하드코딩 데이터)
- [ ] 메뉴 이미지 표시 (cached_network_image 활용 예정)
- [ ] 즐겨찾기 메뉴 등록

### 3.4 포인트 (points)
- [x] 포인트 화면 (`/points`)
- [x] 결제 1회당 결제 금액의 10% 포인트 적립 (원 단위 내림)
- [x] 적립 포인트를 현금처럼 사용 (잔액 한도 내 차감, 잔액 초과 사용 방지)
- [x] 포인트 잔액 표시
- [x] 멤버십 QR 코드 표시 (qr_flutter, 로컬 생성 멤버십 ID)
- [x] 포인트 히스토리 (적립/사용 내역, 결제 금액 기록)
- [x] 로컬 저장 (shared_preferences) 및 기존 스탬프 멤버십 ID 마이그레이션
- [ ] 매장측 QR 스캔을 통한 적립 (mobile_scanner)
- [ ] Firestore 연동 (현재 로컬 저장 기반)

> 변경 이력: 기존 스탬프 적립(10개당 무료 음료 쿠폰) 기능은 폐지되고 포인트 적립/사용 기능으로 대체됨.

### 3.5 내 정보 (profile)
- [x] 프로필 화면 (`/profile`)
- [x] 프로필 헤더 (아바타, 닉네임, 로그인 유도)
- [x] 나의 활동: 주문 내역, 쿠폰함(뱃지 카운트), 즐겨찾기 메뉴
- [x] 설정: 알림 설정, 결제 수단 관리, 배송지 관리
- [x] 기타: 고객센터, 이용약관, 개인정보처리방침, 사업자 정보
- [x] 계정: 로그아웃
- [ ] 각 항목 상세 화면 (전부 미구현, onTap 빈 상태)
- [ ] 프로필 사진 변경 (image_picker)
- [ ] 앱 버전 동적 표시 (package_info_plus, 현재 하드코딩)

### 3.6 알림
- [ ] 푸시 알림 수신 (firebase_messaging)
- [ ] 로컬 알림 (flutter_local_notifications)
- [ ] 알림 권한 요청 (permission_handler)

## 4. 비기능 요구사항

### 4.1 백엔드/데이터
- Firestore 컬렉션 설계: `users`, `menus`, `points`
- 보안 규칙: 본인 데이터만 읽기/쓰기, 메뉴는 공개 읽기, 쓰기는 admin 권한
- 리전: asia-northeast3 (서울)

### 4.2 권한
| 권한 | 용도 |
|------|------|
| 카메라 | 포인트 적립 QR 스캔 |
| 위치 | 매장 찾기 |
| 사진 | 프로필 사진 설정 |
| 알림 | 푸시 알림 |

### 4.3 환경 설정
- `.env`로 카카오 앱 키 관리 (flutter_dotenv) — 미생성
- Firebase 설정: `flutterfire configure` → `firebase_options.dart` 생성 — 미생성 (FIREBASE_SETUP.md 참고)
- Android minSdk 23 이상 — 현재 `flutter.minSdkVersion` 기본값 사용 중
- 앱 자산: `assets/{images,icons,fonts}` 폴더 생성됨, pubspec.yaml에 미등록
- 모니터링: Crashlytics, Analytics

## 5. 화면 및 라우팅

| 경로 | 화면 | 상태 |
|------|------|------|
| `/` | 홈 | 구현됨 |
| `/login` | 로그인 | UI만 구현 |
| `/menu` | 메뉴 | UI만 구현 (임시 데이터) |
| `/points` | 포인트 | 구현됨 (로컬 데이터) |
| `/profile` | 내 정보 | UI만 구현 |

## 6. 향후 작업 우선순위 (제안)

1. Firebase 초기화 및 소셜 로그인 연동
2. Firestore 데이터 모델 정의 (freezed) 및 메뉴/포인트 실데이터 연동
3. QR 스캔 기반 포인트 적립/사용 플로우
4. 푸시 알림 연동
5. 매장 찾기 / 주문 내역 / 쿠폰함 등 하위 화면 구현
