import 'notification_models.dart';

abstract class NotificationFeedRepository {
  /// 최신 알림이 앞에 오도록 정렬된 목록을 흘려보낸다.
  Stream<List<AppNotification>> watchNotifications();

  Future<void> markRead(String id);

  Future<void> markAllRead();

  Future<void> remove(String id);

  Future<void> clear();
}
