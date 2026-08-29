import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:naver_login_sdk/naver_login_sdk.dart';
import 'core/l10n/locale_providers.dart';
import 'core/services/push_notification_providers.dart';
import 'core/services/push_notification_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_mode_providers.dart';
import 'core/widgets/offline_banner.dart';
import 'core/widgets/update_gate.dart';
import 'features/coupon/presentation/auto_coupon_providers.dart';
import 'l10n/app_localizations.dart';
import 'firebase_options.dart';
import 'router/app_router.dart';

const _kakaoNativeAppKey = String.fromEnvironment('KAKAO_NATIVE_APP_KEY');
const _kakaoJavaScriptAppKey = String.fromEnvironment('KAKAO_JS_APP_KEY');
const _naverClientId = String.fromEnvironment('NAVER_CLIENT_ID');
const _naverClientSecret = String.fromEnvironment('NAVER_CLIENT_SECRET');
const _naverUrlScheme = String.fromEnvironment('NAVER_URL_SCHEME');

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
    // 디버그 빌드의 측정값이 실사용 지표를 흐리지 않게 릴리스에서만 수집한다.
    try {
      await FirebasePerformance.instance.setPerformanceCollectionEnabled(
        !kDebugMode,
      );
    } catch (e) {
      debugPrint('Performance monitoring setup skipped: $e');
    }
  }
  if (_kakaoNativeAppKey.isNotEmpty || _kakaoJavaScriptAppKey.isNotEmpty) {
    KakaoSdk.init(
      nativeAppKey: _kakaoNativeAppKey.isNotEmpty ? _kakaoNativeAppKey : null,
      javaScriptAppKey: _kakaoJavaScriptAppKey.isNotEmpty
          ? _kakaoJavaScriptAppKey
          : null,
    );
  }
  if (!kIsWeb && _naverClientId.isNotEmpty && _naverClientSecret.isNotEmpty) {
    try {
      await NaverLoginSDK.initialize(
        urlScheme: _naverUrlScheme.isNotEmpty ? _naverUrlScheme : null,
        clientId: _naverClientId,
        clientSecret: _naverClientSecret,
        clientName: '폭스트롯',
      );
    } catch (e) {
      debugPrint('Naver SDK initialization skipped: $e');
    }
  }
  final storedThemeMode = await loadStoredThemeMode();
  final storedLocale = await loadStoredLocale();
  runApp(
    ProviderScope(
      overrides: [
        storedThemeModeProvider.overrideWithValue(storedThemeMode),
        storedLocaleProvider.overrideWithValue(storedLocale),
      ],
      child: const CafeApp(),
    ),
  );
}

class CafeApp extends ConsumerWidget {
  const CafeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(pushNotificationSetupProvider);
    ref.watch(autoCouponSetupProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: buildAppTheme(brightness: Brightness.light),
      darkTheme: buildAppTheme(),
      themeMode: ref.watch(themeModeProvider),
      // null이면 기기 언어를 따른다.
      locale: ref.watch(localeProvider),
      supportedLocales: supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      builder: (context, child) => OfflineBanner(
        child: UpdateGate(child: child ?? const SizedBox.shrink()),
      ),
    );
  }
}
