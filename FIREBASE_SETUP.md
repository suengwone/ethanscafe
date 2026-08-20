# Firebase 설정 가이드

## 1. Firebase 프로젝트 생성

1. [Firebase Console](https://console.firebase.google.com)에 접속
2. "프로젝트 만들기" 클릭
3. 프로젝트 이름: `ethanscafe` (또는 원하는 이름)
4. Google Analytics 활성화 (선택사항)

## 2. FlutterFire CLI 설치

```bash
# FlutterFire CLI 설치
dart pub global activate flutterfire_cli

# Firebase CLI 설치 (없는 경우)
npm install -g firebase-tools
```

## 3. Firebase 프로젝트 연결

프로젝트 루트에서 실행:

```bash
# Firebase 로그인
firebase login

# Flutter 앱과 Firebase 연결
flutterfire configure

# 플랫폼 선택: iOS, Android 선택
# 번들 ID는 자동으로 com.ethanscafe.cafe_app 사용됨
```

이 명령어는 자동으로:
- iOS/Android 앱을 Firebase에 등록
- `lib/firebase_options.dart` 파일 생성
- 필요한 설정 파일 다운로드

## 4. iOS 추가 설정

### Info.plist 권한 추가
`ios/Runner/Info.plist`에 추가:

```xml
<!-- 카메라 (QR 스캔) -->
<key>NSCameraUsageDescription</key>
<string>포인트 적립 QR코드 스캔을 위해 카메라 접근이 필요합니다.</string>

<!-- 위치 (매장 찾기) -->
<key>NSLocationWhenInUseUsageDescription</key>
<string>가까운 매장을 찾기 위해 위치 정보가 필요합니다.</string>

<!-- 사진 라이브러리 -->
<key>NSPhotoLibraryUsageDescription</key>
<string>프로필 사진 설정을 위해 사진 접근이 필요합니다.</string>
```

### 카카오/네이버 로그인 설정

`ios/Runner/Info.plist`에는 카카오/네이버 URL 스킴과 쿼리 스킴이 이미 등록되어 있다.
스킴 값은 `ios/Flutter/SocialLogin.xcconfig`에서 주입되므로 실제 키로 교체한다:

```
// ios/Flutter/SocialLogin.xcconfig
KAKAO_NATIVE_APP_KEY = 실제_카카오_네이티브_앱_키
NAVER_URL_SCHEME = 네이버_개발자센터에_등록한_URL_스킴
```

### Apple 로그인 설정

- `ios/Runner/Runner.entitlements`에 Sign in with Apple이 등록되어 있다.
- Apple Developer 콘솔의 앱 ID에서 "Sign in with Apple" capability를 켜야 한다.
- Firebase Console > Authentication > Sign-in method에서 Apple을 활성화한다.

## 5. Android 추가 설정

### minSdkVersion 수정
`android/app/build.gradle.kts`:

```kotlin
android {
    defaultConfig {
        minSdk = 23  // Firebase 요구사항
    }
}
```

### 카카오 로그인 설정

`android/app/src/main/AndroidManifest.xml`에 카카오 리다이렉트 액티비티가 등록되어 있다.
스킴의 앱 키는 빌드 시 `--dart-define=KAKAO_NATIVE_APP_KEY=...` 값이 그대로 주입된다
(`android/app/build.gradle.kts`의 dart-defines 파싱 참조).

네이버 로그인은 Android에서 별도 매니페스트 설정이 필요 없다.

## 6. 환경 변수 설정

`.env` 파일 생성:

```env
# 카카오 로그인
KAKAO_NATIVE_APP_KEY=your_kakao_app_key

# 네이버 로그인
NAVER_CLIENT_ID=your_naver_client_id
NAVER_CLIENT_SECRET=your_naver_client_secret
NAVER_URL_SCHEME=your_naver_url_scheme  # iOS 전용

# Firebase (자동 생성됨)
# firebase_options.dart에서 관리
```

실행/빌드 시 dart-define으로 주입한다:

```bash
flutter run \
  --dart-define=KAKAO_NATIVE_APP_KEY=... \
  --dart-define=NAVER_CLIENT_ID=... \
  --dart-define=NAVER_CLIENT_SECRET=... \
  --dart-define=NAVER_URL_SCHEME=...
```

네이버 로그인은 Firebase 기본 제공 provider가 아니므로 Cloud Functions의
`signInWithNaver` callable이 네이버 프로필 조회 후 Firebase 커스텀 토큰을 발급한다
(`firebase deploy --only functions` 필요).

## 7. main.dart 수정

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Firebase 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    const ProviderScope(
      child: CafeApp(),
    ),
  );
}
```

## 8. Firebase 서비스 활성화

Firebase Console에서 활성화:

1. **Authentication**
   - Sign-in method에서 활성화:
     - 이메일/비밀번호
     - Google
     - Apple (iOS)
     - OpenID Connect (`oidc.kakao`, 카카오 OpenID Connect 활성화 필요)
     - 네이버는 별도 provider 없이 커스텀 토큰으로 로그인된다

2. **Cloud Firestore**
   - 데이터베이스 만들기
   - 프로덕션 모드로 시작
   - 위치: asia-northeast3 (서울)

3. **Cloud Messaging** (푸시 알림)
   - 자동 활성화됨

> 참고: Cloud Functions를 쓰므로 **Blaze(종량제) 요금제가 필요하다**. 결제 승인·포인트 적립처럼
> 금액이 걸린 쓰기가 전부 콜러블을 지난다. Storage는 사용하지 않는다.

## 9. Firestore 보안 규칙

`firestore.rules`:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // 인증된 사용자만 읽기/쓰기
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // 메뉴는 모든 사용자가 읽기 가능
    match /menus/{document=**} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.token.admin == true;
    }
  }
}
```

## 10. 테스트

```bash
# iOS 시뮬레이터에서 실행
flutter run -d ios

# Android 에뮬레이터에서 실행
flutter run -d android
```

## 11. 배포 (GitHub Actions)

함수와 보안 규칙은 `main`에 올라가면 `.github/workflows/deploy.yml`이 배포한다
(`functions/**` · `firestore.rules` · `firebase.json`이 바뀐 커밋에서만. 수동 실행도 된다).
배포 전에 함수 단위 테스트가 먼저 돌고, 실패하면 배포하지 않는다.

### 서비스 계정 준비

1. [GCP 콘솔 > IAM > 서비스 계정](https://console.cloud.google.com/iam-admin/serviceaccounts)에서
   `foxtrot-3bdba` 프로젝트에 배포 전용 계정을 만든다 (예: `github-deployer`)
2. 역할을 부여한다. 규칙만 올릴 때보다 함수 배포가 요구하는 것이 많다:
   - Firebase Rules Admin — `firestore.rules` 배포
   - Cloud Functions Admin — 함수 생성·갱신·삭제
   - Service Account User — 함수가 쓰는 런타임 서비스 계정을 대신 지정
   - Cloud Build Editor / Artifact Registry Administrator — 2세대 함수는 빌드를 거쳐 올라간다
   - Secret Manager Admin — `TOSS_SECRET_KEY` 등 `defineSecret` 값을 함수에 연결
3. 키(JSON)를 발급받아 GitHub 저장소 **Settings > Secrets and variables > Actions**에
   `FIREBASE_SERVICE_ACCOUNT` 이름으로 파일 내용 전체를 붙여 넣는다

시크릿이 없으면 워크플로가 배포를 시도하지 않고 첫 단계에서 멈춘다.

### 손으로 배포하기

```bash
firebase deploy --only firestore:rules,functions
```

프로젝트는 `.firebaserc`에 기본값으로 적혀 있어 `--project`를 붙이지 않아도 된다.

> 함수 시크릿은 저장소가 아니라 Secret Manager에 둔다:
> `firebase functions:secrets:set TOSS_SECRET_KEY`

## 추가 리소스

- [FlutterFire 문서](https://firebase.flutter.dev/)
- [Firebase Console](https://console.firebase.google.com/)
- [카카오 개발자](https://developers.kakao.com/)

## 문제 해결

### iOS 빌드 오류
```bash
cd ios
pod install
pod update
```

### Android 빌드 오류
- Gradle 동기화: Android Studio에서 "Sync Now" 클릭
- 캐시 정리: `flutter clean && flutter pub get`