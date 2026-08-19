import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cafe_app/core/theme/app_theme.dart';
import 'package:cafe_app/features/catalog/presentation/catalog_admin_providers.dart';
import 'package:cafe_app/features/catalog/presentation/store_edit_screen.dart';
import 'package:cafe_app/features/store/domain/store_models.dart';

import 'fake_catalog_admin_repository.dart';

void main() {
  late FakeCatalogAdminRepository repository;

  setUp(() => repository = FakeCatalogAdminRepository());

  const store = CafeStore(
    id: 'macheon',
    name: '폭스트롯 마천점',
    address: '서울 송파구 성내천로 189 1층',
    phone: '010-7730-2388',
    latitude: 37.501458,
    longitude: 127.149322,
    weekdayHours: '09:00 - 21:00',
    weekendHours: '09:00 - 21:00',
    services: ['핸드드립 바', '카카오페이'],
    sortOrder: 1,
  );

  Future<void> pumpScreen(WidgetTester tester, {CafeStore? store}) async {
    // 입력 칸이 많아 기본 화면 높이로는 ListView가 아래쪽 칸을 만들지 않는다.
    tester.view.physicalSize = const Size(1200, 4200);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          catalogAdminRepositoryProvider.overrideWithValue(repository),
        ],
        child: MaterialApp(
          theme: buildAppTheme(),
          home: StoreEditScreen(store: store),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> enterField(
    WidgetTester tester,
    String label,
    String value,
  ) async {
    await tester.enterText(find.widgetWithText(TextFormField, label), value);
  }

  Future<void> fillNewStore(WidgetTester tester) async {
    const values = {
      '매장 이름': '폭스트롯 판교점',
      '주소': '경기 성남시 분당구 판교역로 230',
      '전화번호': '0502-5553-5036',
      '위도': '37.401221',
      '경도': '127.110935',
      '평일 영업시간': '08:00 - 18:30',
      '주말 영업시간': '10:00 - 19:00',
      '편의시설': '무료주차 2시간, 테라스',
      '노출 순서': '2',
    };
    for (final entry in values.entries) {
      await enterField(tester, entry.key, entry.value);
    }
  }

  testWidgets('좌표가 비어 있으면 저장하지 않는다', (tester) async {
    await pumpScreen(tester);

    await enterField(tester, '매장 이름', '폭스트롯 판교점');
    await tester.tap(find.text('등록'));
    await tester.pumpAndSettle();

    expect(find.text('위도를 -90 ~ 90 사이 숫자로 입력해 주세요.'), findsOneWidget);
    expect(find.text('경도를 -180 ~ 180 사이 숫자로 입력해 주세요.'), findsOneWidget);
    expect(repository.savedStore, isNull);
  });

  testWidgets('위도 범위를 벗어나면 저장하지 않는다', (tester) async {
    await pumpScreen(tester);
    await fillNewStore(tester);
    await enterField(tester, '위도', '137.4');

    await tester.tap(find.text('등록'));
    await tester.pumpAndSettle();

    expect(find.text('위도를 -90 ~ 90 사이 숫자로 입력해 주세요.'), findsOneWidget);
    expect(repository.savedStore, isNull);
  });

  testWidgets('새 매장은 빈 id로 저장하고 편의시설은 쉼표로 나눈다', (tester) async {
    await pumpScreen(tester);
    await fillNewStore(tester);

    await tester.tap(find.text('등록'));
    await tester.pumpAndSettle();

    expect(
      repository.savedStore,
      const CafeStore(
        id: '',
        name: '폭스트롯 판교점',
        address: '경기 성남시 분당구 판교역로 230',
        phone: '0502-5553-5036',
        latitude: 37.401221,
        longitude: 127.110935,
        weekdayHours: '08:00 - 18:30',
        weekendHours: '10:00 - 19:00',
        services: ['무료주차 2시간', '테라스'],
        sortOrder: 2,
      ),
    );
  });

  testWidgets('기존 매장은 저장한 값을 그대로 채워 보여준다', (tester) async {
    await pumpScreen(tester, store: store);

    expect(find.text('매장 수정'), findsOneWidget);
    expect(find.text('37.501458'), findsOneWidget);
    expect(find.text('핸드드립 바, 카카오페이'), findsOneWidget);

    await tester.tap(find.text('저장'));
    await tester.pumpAndSettle();

    expect(repository.savedStore, store);
  });

  testWidgets('매장 내리기는 확인을 받은 뒤에만 지운다', (tester) async {
    await pumpScreen(tester, store: store);

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();
    await tester.tap(find.text('닫기'));
    await tester.pumpAndSettle();

    expect(repository.deletedStoreId, isNull);

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();
    await tester.tap(find.text('매장 내리기').last);
    await tester.pumpAndSettle();

    expect(repository.deletedStoreId, 'macheon');
  });
}
