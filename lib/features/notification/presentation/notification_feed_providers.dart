import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/presentation/auth_providers.dart';
import '../data/firestore_notification_feed_repository.dart';
import '../data/local_notification_feed_repository.dart';
import '../domain/notification_feed_repository.dart';
import '../domain/notification_models.dart';

final notificationFeedRepositoryProvider = Provider<NotificationFeedRepository>(
  (ref) {
    try {
      if (Firebase.apps.isNotEmpty) {
        final user = ref.watch(authStateProvider).value;
        if (user != null) {
          return FirestoreNotificationFeedRepository(uid: user.uid);
        }
      }
    } catch (_) {}
    return LocalNotificationFeedRepository();
  },
);

final notificationFeedProvider = StreamProvider<List<AppNotification>>((ref) {
  return ref.watch(notificationFeedRepositoryProvider).watchNotifications();
});

/// 종 아이콘의 뱃지 숫자. 아직 못 읽어 온 동안은 0으로 둬서
/// 홈 화면이 알림함을 기다리지 않게 한다.
final unreadNotificationCountProvider = Provider<int>((ref) {
  final notifications =
      ref.watch(notificationFeedProvider).value ?? const <AppNotification>[];
  return notifications.where((notification) => !notification.isRead).length;
});

/// "3분 전"을 재는 기준 시각. 골든 스크린샷에서 시각을 고정하려고 열어 둔다.
final notificationClockProvider = Provider<DateTime Function()>(
  (ref) => DateTime.now,
);
