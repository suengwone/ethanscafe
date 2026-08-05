import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'core/services/push_notification_providers.dart';
import 'core/services/push_notification_service.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'router/app_router.dart';

const _kakaoNativeAppKey = String.fromEnvironment('KAKAO_NATIVE_APP_KEY');
const _kakaoJavaScriptAppKey = String.fromEnvironment('KAKAO_JS_APP_KEY');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var firebaseReady = false;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firebaseReady = true;
  } catch (e) {
    debugPrint('Firebase initialization skipped: $e');
  }
  if (firebaseReady && !kIsWeb) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }
  if (_kakaoNativeAppKey.isNotEmpty || _kakaoJavaScriptAppKey.isNotEmpty) {
    KakaoSdk.init(
      nativeAppKey:
          _kakaoNativeAppKey.isNotEmpty ? _kakaoNativeAppKey : null,
      javaScriptAppKey:
          _kakaoJavaScriptAppKey.isNotEmpty ? _kakaoJavaScriptAppKey : null,
    );
  }
  runApp(
    const ProviderScope(
      child: CafeApp(),
    ),
  );
}

class CafeApp extends ConsumerWidget {
  const CafeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(pushNotificationSetupProvider);
    final router = ref.watch(routerProvider);
    
    return MaterialApp.router(
      title: '폭스트롯',
      theme: buildAppTheme(),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}