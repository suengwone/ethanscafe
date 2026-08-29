import 'package:cafe_app/features/notification/data/firestore_notification_feed_repository.dart';
import 'package:cafe_app/features/notification/domain/notification_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('appNotificationFromFirestore', () {
    test('Firestore 항목을 AppNotification으로 변환한다', () {
      final createdAt = DateTime(2026, 8, 30, 9, 41);
      final notification = appNotificationFromFirestore({
        'id': 'order-1:ready',
        'title': '주문하신 음료가 나왔어요',
        'body': '바닐라 라떼 주문을 픽업대에서 찾아가세요.',
        'category': 'order',
        'createdAt': Timestamp.fromDate(createdAt),
        'isRead': true,
        'route': '/profile/orders',
      });

      expect(notification.id, 'order-1:ready');
      expect(notification.category, AppNotificationCategory.order);
      expect(notification.createdAt, createdAt);
      expect(notification.isRead, isTrue);
      expect(notification.route, '/profile/orders');
    });

    test('알 수 없는 분류는 주문으로 대체한다', () {
      final notification = appNotificationFromFirestore({
        'id': 'n1',
        'title': '제목',
        'body': '본문',
        'category': 'unknown',
        'createdAt': '2026-08-30T09:00:00.000',
      });

      expect(notification.category, AppNotificationCategory.order);
      expect(notification.isRead, isFalse);
    });

    test('앱 경로가 아닌 route는 버린다', () {
      final notification = appNotificationFromFirestore({
        'id': 'n1',
        'title': '제목',
        'body': '본문',
        'category': 'event',
        'createdAt': '2026-08-30T09:00:00.000',
        'route': 'https://example.com/promo',
      });

      expect(notification.route, isNull);
    });
  });

  test('알림함은 최신순으로 정렬된다', () {
    final notifications = appNotificationsFromFirestore({
      'items': [
        {
          'id': 'old',
          'title': '지난 알림',
          'body': '본문',
          'category': 'order',
          'createdAt': '2026-08-28T09:00:00.000',
        },
        {
          'id': 'new',
          'title': '새 알림',
          'body': '본문',
          'category': 'order',
          'createdAt': '2026-08-30T09:00:00.000',
        },
      ],
    });

    expect(notifications.map((item) => item.id), ['new', 'old']);
  });

  test('알림함이 비어 있으면 빈 목록을 준다', () {
    expect(appNotificationsFromFirestore(const {}), isEmpty);
  });

  test('AppNotification을 Firestore 항목으로 되돌린다', () {
    final createdAt = DateTime(2026, 8, 30, 9, 41);
    final data = appNotificationToFirestore(
      AppNotification(
        id: 'order-1:ready',
        title: '제목',
        body: '본문',
        category: AppNotificationCategory.points,
        createdAt: createdAt,
        isRead: true,
      ),
    );

    expect(data['category'], 'points');
    expect(data['isRead'], isTrue);
    expect((data['createdAt'] as Timestamp).toDate(), createdAt);
    expect(data.containsKey('route'), isFalse);
  });
}
