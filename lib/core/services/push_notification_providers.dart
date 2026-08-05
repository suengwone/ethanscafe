import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/auth_providers.dart';
import '../../router/app_router.dart';
import 'fcm_token_repository.dart';
import 'push_notification_service.dart';

bool get _isPushSupported {
  if (kIsWeb) {
    return false;
  }
  try {
    return Firebase.apps.isNotEmpty;
  } catch (_) {
    return false;
  }
}

final pushNotificationServiceProvider = Provider<PushNotificationService?>(
  (ref) {
    if (!_isPushSupported) {
      return null;
    }
    final service = PushNotificationService(
      onNavigate: (route) => ref.read(routerProvider).go(route),
    );
    ref.onDispose(service.dispose);
    return service;
  },
);

final fcmTokenRepositoryProvider = Provider<FcmTokenRepository?>((ref) {
  if (!_isPushSupported) {
    return null;
  }
  final user = ref.watch(authStateProvider).value;
  if (user == null) {
    return null;
  }
  return FirestoreFcmTokenRepository(uid: user.uid);
});

final pushNotificationSetupProvider = Provider<void>((ref) {
  final service = ref.watch(pushNotificationServiceProvider);
  if (service == null) {
    return;
  }
  service.initialize().catchError((Object e) {
    debugPrint('Push notification initialization failed: $e');
  });

  final repository = ref.watch(fcmTokenRepositoryProvider);
  if (repository == null) {
    return;
  }
  final subscription = service.tokenStream().listen(
    (token) {
      repository.saveToken(token).catchError((Object e) {
        debugPrint('FCM token save failed: $e');
      });
    },
    onError: (Object e) {
      debugPrint('FCM token stream failed: $e');
    },
  );
  ref.onDispose(subscription.cancel);
});
