import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/notification_feed_repository.dart';
import '../domain/notification_models.dart';

/// Firebase가 없거나 로그인하지 않은 기기에서 쓰는 알림함.
///
/// 서버 푸시가 닿지 않으므로 대개 비어 있고, 앱이 직접 남긴 알림만 담는다.
class LocalNotificationFeedRepository implements NotificationFeedRepository {
  static const storageKey = 'notification_feed';

  final _changes = StreamController<List<AppNotification>>.broadcast();

  @override
  Stream<List<AppNotification>> watchNotifications() async* {
    yield await _load();
    yield* _changes.stream;
  }

  @override
  Future<void> markRead(String id) {
    return _update(
      (items) => items
          .map((item) => item.id == id ? item.copyWith(isRead: true) : item)
          .toList(),
    );
  }

  @override
  Future<void> markAllRead() {
    return _update(
      (items) => items.map((item) => item.copyWith(isRead: true)).toList(),
    );
  }

  @override
  Future<void> remove(String id) {
    return _update((items) => items.where((item) => item.id != id).toList());
  }

  @override
  Future<void> clear() => _update((items) => const []);

  /// 앱이 직접 받은 알림을 최신순 맨 앞에 붙인다.
  ///
  /// 지금 앱에서 부르는 곳은 없다. 로컬 모드에는 알림을 만들어 주는 서버가 없어
  /// 알림함이 비어 있기 때문이다. 나중에 포그라운드 푸시를 여기에 남기게 되면
  /// 이 자리가 그 입구가 되고, 그때까지는 저장소 동작을 재는 테스트가 쓴다.
  Future<void> add(AppNotification notification) {
    return _update((items) => [notification, ...items]);
  }

  Future<List<AppNotification>> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(storageKey);
    if (raw == null) {
      return const [];
    }
    final items = (jsonDecode(raw) as List<dynamic>)
        .map((item) => _fromJson(item as Map<String, dynamic>))
        .toList();
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items;
  }

  Future<void> _update(
    List<AppNotification> Function(List<AppNotification>) change,
  ) async {
    final updated = change(await _load());
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      storageKey,
      jsonEncode(updated.map(_toJson).toList()),
    );
    _changes.add(updated);
  }
}

Map<String, dynamic> _toJson(AppNotification notification) {
  return {
    'id': notification.id,
    'title': notification.title,
    'body': notification.body,
    'category': notification.category.name,
    'createdAt': notification.createdAt.toIso8601String(),
    'isRead': notification.isRead,
    if (notification.route != null) 'route': notification.route,
  };
}

AppNotification _fromJson(Map<String, dynamic> json) {
  return AppNotification(
    id: json['id'] as String? ?? '',
    title: json['title'] as String? ?? '',
    body: json['body'] as String? ?? '',
    category:
        AppNotificationCategory.values.asNameMap()[json['category']] ??
        AppNotificationCategory.order,
    createdAt: DateTime.parse(json['createdAt'] as String),
    isRead: json['isRead'] as bool? ?? false,
    route: json['route'] as String?,
  );
}
