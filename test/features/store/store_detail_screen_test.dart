import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cafe_app/core/theme/app_theme.dart';
import 'package:cafe_app/core/utils/text_utils.dart';
import 'package:cafe_app/features/store/domain/store_models.dart';
import 'package:cafe_app/features/store/presentation/store_detail_screen.dart';
import 'package:cafe_app/features/store/presentation/stores_providers.dart';

void main() {
  final now = DateTime(2026, 8, 19, 15); // 수요일 15시

  final store = CafeStore(
    id: 'macheon',
    name: '폭스트롯 마천점',
    address: '서울 송파구 성내천로 189 1층',
    phone: '010-7730-2388',
    latitude: 37.501458,
    longitude: 127.149322,
    weekdayHours: '09:00 - 21:00',
    weekendHours: '10:00 - 18:00',
    services: ['핸드드립 바', '테라스'],
    notice: '8월 22일은 정기 휴무입니다.',
    congestion: StoreCongestion.busy,
    congestionUpdatedAt: now.subtract(const Duration(minutes: 20)),
  );

  Future<void> pumpScreen(
    WidgetTester tester, {
    required CafeStore store,
    String storeId = 'macheon',
    DateTime? clock,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          storesProvider.overrideWith((ref) async => [store]),
          storeClockProvider.overrideWithValue(() => clock ?? now),
        ],
        child: MaterialApp(
          theme: buildAppTheme(),
          home: StoreDetailScreen(storeId: storeId),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('영업 중인 매장은 오늘 영업시간과 함께 영업 중으로 보여 준다', (tester) async {
    await pumpScreen(tester, store: store);

    expect(find.text('폭스트롯 마천점'.keepWord), findsOneWidget);
    expect(find.text('영업 중'), findsOneWidget);
    expect(find.text('오늘 09:00 - 21:00'.keepWord), findsOneWidget);
  });

  testWidgets('주말에는 주말 영업시간으로 판단한다', (tester) async {
    // 토요일 19시 — 주말은 18시에 닫는다.
    await pumpScreen(
      tester,
      store: store,
      clock: DateTime(2026, 8, 22, 19),
    );

    expect(find.text('영업 종료'), findsOneWidget);
    expect(find.text('오늘 10:00 - 18:00'.keepWord), findsOneWidget);
  });

  testWidgets('매장 공지와 편의시설을 보여 준다', (tester) async {
    await pumpScreen(tester, store: store);

    expect(find.text('매장 공지'), findsOneWidget);
    expect(find.text('8월 22일은 정기 휴무입니다.'.keepWord), findsOneWidget);
    expect(find.text('핸드드립 바'), findsOneWidget);
  });

  testWidgets('방금 올린 혼잡도를 보여 준다', (tester) async {
    await pumpScreen(tester, store: store);

    expect(find.text('현재 혼잡'), findsOneWidget);
  });

  testWidgets('오래된 혼잡도는 숨긴다', (tester) async {
    await pumpScreen(
      tester,
      store: store.copyWith(
        congestionUpdatedAt: now.subtract(const Duration(hours: 5)),
      ),
    );

    expect(find.text('현재 혼잡'), findsNothing);
  });

  testWidgets('내린 매장으로 들어오면 안내를 보여 준다', (tester) async {
    await pumpScreen(tester, store: store, storeId: 'gone');

    expect(find.text('문 닫은 매장이거나 없는 매장입니다.'), findsOneWidget);
  });
}
