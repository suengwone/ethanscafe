import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/firebase/firestore_converters.dart';
import '../domain/notification_feed_repository.dart';
import '../domain/notification_models.dart';

/// 알림함은 사용자 문서 하나에 배열로 담긴다.
///
/// 배열이라 서버가 새 알림을 붙이는 쓰기와 사용자가 읽음 표시를 하는 쓰기가
/// 같은 문서를 다투므로, 클라이언트 쪽 수정은 전부 트랜잭션으로 감싼다.
/// 그래야 방금 도착한 알림을 읽음 처리가 덮어쓰지 않는다.
class FirestoreNotificationFeedRepository
    implements NotificationFeedRepository {
  FirestoreNotificationFeedRepository({
    required this.uid,
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final String uid;
  final FirebaseFirestore _firestore;

  static const collectionPath = 'notifications';

  DocumentReference<Map<String, dynamic>> get _doc =>
      _firestore.collection(collectionPath).doc(uid);

  @override
  Stream<List<AppNotification>> watchNotifications() {
    return _doc.snapshots().map((snapshot) {
      final data = snapshot.data();
      if (data == null) {
        return const <AppNotification>[];
      }
      return appNotificationsFromFirestore(data);
    });
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

  Future<void> _update(
    List<AppNotification> Function(List<AppNotification>) change,
  ) {
    return _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(_doc);
      final data = snapshot.data();
      if (data == null) {
        return;
      }
      final updated = change(appNotificationsFromFirestore(data));
      transaction.set(_doc, {
        'items': updated.map(appNotificationToFirestore).toList(),
      }, SetOptions(merge: true));
    });
  }
}

List<AppNotification> appNotificationsFromFirestore(Map<String, dynamic> data) {
  final items = ((data['items'] as List<dynamic>?) ?? const [])
      .map((item) => appNotificationFromFirestore(item as Map<String, dynamic>))
      .toList();
  items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return items;
}

AppNotification appNotificationFromFirestore(Map<String, dynamic> data) {
  final route = data['route'] as String?;
  return AppNotification(
    id: data['id'] as String? ?? '',
    title: data['title'] as String? ?? '',
    body: data['body'] as String? ?? '',
    category:
        AppNotificationCategory.values.asNameMap()[data['category']] ??
        AppNotificationCategory.order,
    createdAt: firestoreDateTime(data['createdAt']),
    isRead: data['isRead'] as bool? ?? false,
    route: route != null && route.startsWith('/') ? route : null,
  );
}

Map<String, dynamic> appNotificationToFirestore(AppNotification notification) {
  return {
    'id': notification.id,
    'title': notification.title,
    'body': notification.body,
    'category': notification.category.name,
    'createdAt': Timestamp.fromDate(notification.createdAt),
    'isRead': notification.isRead,
    if (notification.route != null) 'route': notification.route,
  };
}
