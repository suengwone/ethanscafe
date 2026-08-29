import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:cafe_app/core/theme/app_theme.dart';
import 'package:cafe_app/features/store/domain/store_models.dart';
import 'package:cafe_app/features/store/presentation/store_list_screen.dart';
import 'package:cafe_app/features/store/presentation/stores_providers.dart';

import '../../support/localized_app.dart';

void main() {
  final now = DateTime(2026, 8, 19, 22); // 수요일 22시 — 마감 뒤

  const store = CafeStore(
    id: 'macheon',
    name: '폭스트롯 마천점',
    address: '서울 송파구 성내천로 189 1층',
    phone: '010-7730-2388',
    latitude: 37.501458,
    longitude: 127.149322,
    weekdayHours: '09:00 - 21:00',
    weekendHours: '10:00 - 18:00',
  );

  Future<void> pumpScreen(
    WidgetTester tester, {
    Map<String, StoreActivity> activity = const {},
  }) async {
    final router = GoRouter(
      initialLocation: '/stores',
      routes: [
        GoRoute(
          path: '/stores',
          builder: (context, state) => const StoreListScreen(),
          routes: [
            GoRoute(
              path: ':storeId',
              builder: (context, state) => Scaffold(
                body: Text('매장 상세 ${state.pathParameters['storeId']}'),
              ),
            ),
          ],
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          storesProvider.overrideWith((ref) async => [store]),
          storeActivityProvider.overrideWith((ref) async => activity),
          storeClockProvider.overrideWithValue(() => now),
        ],
        child: MaterialApp.router(
          locale: testLocale,
          localizationsDelegates: testLocalizationsDelegates,
          supportedLocales: testSupportedLocales,
          theme: buildAppTheme(),
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('마감한 매장은 영업 종료로 보여 준다', (tester) async {
    await pumpScreen(tester);

    expect(find.text('영업 종료'), findsOneWidget);
  });

  testWidgets('직원이 올린 값이 없으면 자동 집계 혼잡도를 보여 준다', (tester) async {
    await pumpScreen(
      tester,
      activity: {
        'macheon': StoreActivity(
          storeId: 'macheon',
          activeOrders: 9,
          congestion: StoreCongestion.busy,
          updatedAt: now.subtract(const Duration(minutes: 3)),
        ),
      },
    );

    expect(find.text('현재 혼잡'), findsOneWidget);
  });

  testWidgets('매장을 누르면 매장 상세로 간다', (tester) async {
    await pumpScreen(tester);

    await tester.tap(find.byType(Card));
    await tester.pumpAndSettle();

    expect(find.text('매장 상세 macheon'), findsOneWidget);
  });
}
