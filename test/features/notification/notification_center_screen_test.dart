import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cafe_app/core/theme/app_theme.dart';
import 'package:cafe_app/core/utils/text_utils.dart';
import 'package:cafe_app/features/notification/domain/notification_feed_repository.dart';
import 'package:cafe_app/features/notification/domain/notification_models.dart';
import 'package:cafe_app/features/notification/presentation/notification_center_screen.dart';
import 'package:cafe_app/features/notification/presentation/notification_feed_providers.dart';

import '../../support/localized_app.dart';

final _now = DateTime(2026, 8, 30, 10);

class FakeNotificationFeedRepository implements NotificationFeedRepository {
  FakeNotificationFeedRepository(this._items);

  List<AppNotification> _items;
  final _changes = StreamController<List<AppNotification>>.broadcast();

  @override
  Stream<List<AppNotification>> watchNotifications() async* {
    yield _items;
    yield* _changes.stream;
  }

  @override
  Future<void> markRead(String id) async {
    _emit(
      _items
          .map((item) => item.id == id ? item.copyWith(isRead: true) : item)
          .toList(),
    );
  }

  @override
  Future<void> markAllRead() async {
    _emit(_items.map((item) => item.copyWith(isRead: true)).toList());
  }

  @override
  Future<void> remove(String id) async {
    _emit(_items.where((item) => item.id != id).toList());
  }

  @override
  Future<void> clear() async => _emit(const []);

  void _emit(List<AppNotification> items) {
    _items = items;
    _changes.add(items);
  }
}

AppNotification _notification(
  String id, {
  required String title,
  bool isRead = false,
  Duration ago = const Duration(minutes: 3),
  AppNotificationCategory category = AppNotificationCategory.order,
}) {
  return AppNotification(
    id: id,
    title: title,
    body: '$title 본문',
    category: category,
    createdAt: _now.subtract(ago),
    isRead: isRead,
  );
}

final _menuButton = find.byWidgetPredicate(
  (widget) => widget is PopupMenuButton,
);

void main() {
  Future<FakeNotificationFeedRepository> pumpScreen(
    WidgetTester tester,
    List<AppNotification> notifications,
  ) async {
    final repository = FakeNotificationFeedRepository(notifications);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          notificationFeedRepositoryProvider.overrideWithValue(repository),
          notificationClockProvider.overrideWithValue(() => _now),
        ],
        child: MaterialApp(
          locale: testLocale,
          localizationsDelegates: testLocalizationsDelegates,
          supportedLocales: testSupportedLocales,
          theme: buildAppTheme(),
          home: const NotificationCenterScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return repository;
  }

  testWidgets('받은 알림이 없으면 빈 안내를 보여준다', (tester) async {
    await pumpScreen(tester, const []);

    expect(find.text('받은 알림이 없어요'), findsOneWidget);
    expect(find.text('모두 읽음'), findsNothing);
  });

  testWidgets('알림을 최신 목록 그대로 보여준다', (tester) async {
    await pumpScreen(tester, [
      _notification('a', title: '주문하신 음료가 나왔어요'),
      _notification(
        'b',
        title: '포인트가 적립됐어요',
        category: AppNotificationCategory.points,
        ago: const Duration(hours: 5),
        isRead: true,
      ),
    ]);

    expect(find.text('주문하신 음료가 나왔어요'.keepWord), findsOneWidget);
    expect(find.text('포인트가 적립됐어요'.keepWord), findsOneWidget);
    expect(find.text('3분 전'), findsOneWidget);
    expect(find.text('5시간 전'), findsOneWidget);
  });

  testWidgets('모두 읽음을 누르면 안 읽은 알림이 사라진다', (tester) async {
    final repository = await pumpScreen(tester, [
      _notification('a', title: '주문하신 음료가 나왔어요'),
    ]);

    await tester.tap(find.text('모두 읽음'));
    await tester.pumpAndSettle();

    expect(repository._items.single.isRead, isTrue);
    expect(find.text('모두 읽음'), findsNothing);
  });

  testWidgets('알림을 누르면 읽음으로 바뀐다', (tester) async {
    final repository = await pumpScreen(tester, [
      _notification('a', title: '주문하신 음료가 나왔어요'),
    ]);

    await tester.tap(find.text('주문하신 음료가 나왔어요'.keepWord));
    await tester.pumpAndSettle();

    expect(repository._items.single.isRead, isTrue);
  });

  testWidgets('밀어서 지우면 목록에서 빠진다', (tester) async {
    final repository = await pumpScreen(tester, [
      _notification('a', title: '주문하신 음료가 나왔어요'),
      _notification('b', title: '포인트가 적립됐어요'),
    ]);

    await tester.drag(
      find.text('주문하신 음료가 나왔어요'.keepWord),
      const Offset(-500, 0),
    );
    await tester.pumpAndSettle();

    expect(repository._items.map((item) => item.id), ['b']);
    // 목록에서 빼는 일은 저장소가 흘려보낸 새 목록이 한다.
    expect(find.text('주문하신 음료가 나왔어요'.keepWord), findsNothing);
    expect(find.text('포인트가 적립됐어요'.keepWord), findsOneWidget);
  });

  testWidgets('모두 지우기는 확인을 받고 나서 비운다', (tester) async {
    final repository = await pumpScreen(tester, [
      _notification('a', title: '주문하신 음료가 나왔어요'),
    ]);

    await tester.tap(_menuButton);
    await tester.pumpAndSettle();
    await tester.tap(find.text('모두 지우기').last);
    await tester.pumpAndSettle();

    expect(find.text('알림을 모두 지울까요?'), findsOneWidget);
    await tester.tap(find.text('취소'));
    await tester.pumpAndSettle();
    expect(repository._items, hasLength(1));

    await tester.tap(_menuButton);
    await tester.pumpAndSettle();
    await tester.tap(find.text('모두 지우기').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('모두 지우기').last);
    await tester.pumpAndSettle();

    expect(repository._items, isEmpty);
    expect(find.text('받은 알림이 없어요'), findsOneWidget);
  });
}
