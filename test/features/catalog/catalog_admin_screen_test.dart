import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cafe_app/core/theme/app_theme.dart';
import 'package:cafe_app/features/catalog/presentation/banner_edit_screen.dart';
import 'package:cafe_app/features/catalog/presentation/catalog_admin_screen.dart';
import 'package:cafe_app/features/catalog/presentation/notice_edit_screen.dart';
import 'package:cafe_app/features/catalog/presentation/store_edit_screen.dart';
import 'package:cafe_app/features/home/domain/banner_models.dart';
import 'package:cafe_app/features/home/presentation/home_providers.dart';
import 'package:cafe_app/features/notice/domain/notice_models.dart';
import 'package:cafe_app/features/notice/presentation/notices_providers.dart';
import 'package:cafe_app/features/store/domain/store_models.dart';
import 'package:cafe_app/features/store/presentation/stores_providers.dart';

void main() {
  const banner = EventBanner(
    id: 'banner-1',
    title: '여름 시즌 신메뉴 출시',
    subtitle: '시원한 콜드브루와 함께 여름을 즐겨보세요',
    icon: 'snowflake',
    sortOrder: 1,
  );

  const store = CafeStore(
    id: 'macheon',
    name: '폭스트롯 마천점',
    address: '서울 송파구 성내천로 189 1층',
    phone: '010-7730-2388',
    latitude: 37.501458,
    longitude: 127.149322,
    weekdayHours: '09:00 - 21:00',
    weekendHours: '09:00 - 21:00',
  );

  final notice = Notice(
    id: 'notice-hours',
    title: '8월 영업시간 안내',
    body: '8월 한 달간 매일 오전 8시부터 오후 10시까지 운영합니다.',
    category: NoticeCategory.notice,
    createdAt: DateTime(2026, 8, 1, 10),
    isImportant: true,
  );

  Future<void> pumpScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          bannersProvider.overrideWith((ref) async => const [banner]),
          storesProvider.overrideWith((ref) async => const [store]),
          noticesProvider.overrideWith((ref) async => [notice]),
        ],
        child: MaterialApp(
          theme: buildAppTheme(),
          home: const CatalogAdminScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> openTab(WidgetTester tester, String label) async {
    await tester.tap(find.widgetWithText(Tab, label));
    await tester.pumpAndSettle();
  }

  testWidgets('배너 탭은 등록된 배너를 보여준다', (tester) async {
    await pumpScreen(tester);
    await openTab(tester, '배너');

    expect(find.text('여름 시즌 신메뉴 출시'), findsOneWidget);
    expect(find.text('시원한 콜드브루와 함께 여름을 즐겨보세요'), findsOneWidget);
    // 배너는 품절 개념이 없으므로 스위치를 두지 않는다.
    expect(find.byType(Switch), findsNothing);
  });

  testWidgets('배너를 누르면 그 배너의 수정 화면이 열린다', (tester) async {
    await pumpScreen(tester);
    await openTab(tester, '배너');

    await tester.tap(find.text('여름 시즌 신메뉴 출시'));
    await tester.pumpAndSettle();

    expect(find.text('배너 수정'), findsOneWidget);
    expect(
      tester.widget<BannerEditScreen>(find.byType(BannerEditScreen)).banner,
      banner,
    );
  });

  testWidgets('매장 탭은 등록된 매장을 보여주고 수정 화면을 연다', (tester) async {
    await pumpScreen(tester);
    await openTab(tester, '매장');

    expect(find.text('폭스트롯 마천점'), findsOneWidget);

    await tester.tap(find.text('폭스트롯 마천점'));
    await tester.pumpAndSettle();

    expect(find.text('매장 수정'), findsOneWidget);
    expect(
      tester.widget<StoreEditScreen>(find.byType(StoreEditScreen)).store,
      store,
    );
  });

  testWidgets('공지 탭은 등록된 공지를 분류·게시일과 함께 보여주고 수정 화면을 연다', (tester) async {
    await pumpScreen(tester);
    await openTab(tester, '공지');

    expect(find.text('8월 영업시간 안내'), findsOneWidget);
    expect(find.text('공지 · 2026.08.01'), findsOneWidget);

    await tester.tap(find.text('8월 영업시간 안내'));
    await tester.pumpAndSettle();

    expect(find.text('공지 수정'), findsOneWidget);
    expect(
      tester.widget<NoticeEditScreen>(find.byType(NoticeEditScreen)).notice,
      notice,
    );
  });

  testWidgets('등록 버튼은 보고 있는 탭에 맞는 등록 화면을 연다', (tester) async {
    await pumpScreen(tester);
    await openTab(tester, '배너');

    expect(find.text('배너 등록'), findsOneWidget);
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.byType(BannerEditScreen), findsOneWidget);
    expect(
      tester.widget<BannerEditScreen>(find.byType(BannerEditScreen)).banner,
      isNull,
    );

    await tester.pageBack();
    await tester.pumpAndSettle();
    await openTab(tester, '매장');

    expect(find.text('매장 등록'), findsOneWidget);
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.byType(StoreEditScreen), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await openTab(tester, '공지');

    expect(find.text('공지 등록'), findsOneWidget);
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.byType(NoticeEditScreen), findsOneWidget);
  });
}
