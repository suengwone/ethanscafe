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
<string>스탬프 QR코드 스캔을 위해 카메라 접근이 필요합니다.</string>

<!-- 위치 (매장 찾기) -->
<key>NSLocationWhenInUseUsageDescription</key>
<string>가까운 매장을 찾기 위해 위치 정보가 필요합니다.</string>

<!-- 사진 라이브러리 -->
<key>NSPhotoLibraryUsageDescription</key>
<string>프로필 사진 설정을 위해 사진 접근이 필요합니다.</string>
```

### 카카오 로그인 설정
```xml
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>kakaokompassauth</string>
    <string>kakaolink</string>
</array>

<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>kakao{YOUR_KAKAO_APP_KEY}</string>
        </array>
    </dict>
</array>
```

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
`android/app/src/main/AndroidManifest.xml`:

```xml
<activity 
    android:name="com.kakao.sdk.auth.AuthCodeHandlerActivity"
    android:exported="true">
    <intent-filter>
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="kakao{YOUR_KAKAO_APP_KEY}" />
    </intent-filter>
</activity>
```

## 6. 환경 변수 설정

`.env` 파일 생성:

```env
# 카카오 로그인
KAKAO_NATIVE_APP_KEY=your_kakao_app_key

# Firebase (자동 생성됨)
# firebase_options.dart에서 관리
```

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

2. **Cloud Firestore**
   - 데이터베이스 만들기
   - 프로덕션 모드로 시작
   - 위치: asia-northeast3 (서울)

3. **Storage**
   - 시작하기 클릭
   - 프로덕션 모드로 시작

4. **Cloud Messaging** (푸시 알림)
   - 자동 활성화됨

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
    
    // 스탬프는 본인 것만
    match /stamps/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
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