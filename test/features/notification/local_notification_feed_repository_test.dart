import 'package:cafe_app/features/notification/data/local_notification_feed_repository.dart';
import 'package:cafe_app/features/notification/domain/notification_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

AppNotification _notification(String id, {bool isRead = false, int day = 30}) {
  return AppNotification(
    id: id,
    title: '제목 $id',
    body: '본문 $id',
    category: AppNotificationCategory.order,
    createdAt: DateTime(2026, 8, day, 9),
    isRead: isRead,
  );
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('저장한 알림을 최신순으로 돌려준다', () async {
    final repository = LocalNotificationFeedRepository();
    await repository.add(_notification('old', day: 28));
    await repository.add(_notification('new', day: 30));

    final notifications = await repository.watchNotifications().first;

    expect(notifications.map((item) => item.id), ['new', 'old']);
  });

  test('읽음 표시는 해당 알림에만 붙는다', () async {
    final repository = LocalNotificationFeedRepository();
    await repository.add(_notification('a'));
    await repository.add(_notification('b'));

    await repository.markRead('a');
    final notifications = await repository.watchNotifications().first;

    expect(notifications.firstWhere((item) => item.id == 'a').isRead, isTrue);
    expect(notifications.firstWhere((item) => item.id == 'b').isRead, isFalse);
  });

  test('모두 읽음은 전부를 읽음으로 바꾼다', () async {
    final repository = LocalNotificationFeedRepository();
    await repository.add(_notification('a'));
    await repository.add(_notification('b'));

    await repository.markAllRead();
    final notifications = await repository.watchNotifications().first;

    expect(notifications.every((item) => item.isRead), isTrue);
  });

  test('알림을 하나씩 지우고 모두 지울 수 있다', () async {
    final repository = LocalNotificationFeedRepository();
    await repository.add(_notification('a'));
    await repository.add(_notification('b'));

    await repository.remove('a');
    expect(
      (await repository.watchNotifications().first).map((item) => item.id),
      ['b'],
    );

    await repository.clear();
    expect(await repository.watchNotifications().first, isEmpty);
  });

  test('바뀐 알림함은 듣고 있는 쪽에도 흘러간다', () async {
    final repository = LocalNotificationFeedRepository();
    final changes = repository.watchNotifications().skip(1).first;

    await repository.add(_notification('a'));

    expect((await changes).single.id, 'a');
  });

  test('저장된 알림이 없으면 빈 목록으로 시작한다', () async {
    expect(
      await LocalNotificationFeedRepository().watchNotifications().first,
      isEmpty,
    );
  });
}
