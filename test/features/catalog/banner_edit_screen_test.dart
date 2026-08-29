import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cafe_app/core/theme/app_theme.dart';
import 'package:cafe_app/features/catalog/presentation/banner_edit_screen.dart';
import 'package:cafe_app/features/catalog/presentation/catalog_admin_providers.dart';
import 'package:cafe_app/features/home/domain/banner_models.dart';
import 'package:cafe_app/features/home/presentation/banner_icons.dart';

import 'fake_catalog_admin_repository.dart';

import '../../support/localized_app.dart';

void main() {
  late FakeCatalogAdminRepository repository;

  setUp(() => repository = FakeCatalogAdminRepository());

  Future<void> pumpScreen(WidgetTester tester, {EventBanner? banner}) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          catalogAdminRepositoryProvider.overrideWithValue(repository),
        ],
        child: MaterialApp(
          locale: testLocale,
          localizationsDelegates: testLocalizationsDelegates,
          supportedLocales: testSupportedLocales,
          theme: buildAppTheme(),
          home: BannerEditScreen(banner: banner),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('제목이 비어 있으면 저장하지 않는다', (tester) async {
    await pumpScreen(tester);

    await tester.tap(find.text('등록'));
    await tester.pumpAndSettle();

    expect(find.text('제목을 입력해 주세요.'), findsOneWidget);
    expect(repository.savedBanner, isNull);
  });

  testWidgets('새 배너는 빈 id로 저장해 서버가 문서를 새로 만들게 한다', (tester) async {
    await pumpScreen(tester);

    await tester.enterText(find.byType(TextFormField).at(0), '친구 초대 이벤트');
    await tester.enterText(find.byType(TextFormField).at(1), '친구를 초대하면 3,000P');
    await tester.enterText(find.byType(TextFormField).last, '2');
    await tester.tap(find.text('등록'));
    await tester.pumpAndSettle();

    expect(
      repository.savedBanner,
      const EventBanner(
        id: '',
        title: '친구 초대 이벤트',
        subtitle: '친구를 초대하면 3,000P',
        sortOrder: 2,
      ),
    );
  });

  testWidgets('아이콘을 바꿔 저장하면 그 아이콘 값이 넘어간다', (tester) async {
    await pumpScreen(
      tester,
      banner: const EventBanner(
        id: 'banner-1',
        title: '원두 정기 구독',
        subtitle: '매달 새로운 원두를 집에서',
        icon: 'sparkles',
      ),
    );

    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text(bannerIconChoices['bean']!.label).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('저장'));
    await tester.pumpAndSettle();

    expect(repository.savedBanner?.icon, 'bean');
    expect(repository.savedBanner?.id, 'banner-1');
  });

  testWidgets('표에 없는 아이콘이 저장돼 있으면 기본 아이콘으로 되돌린다', (tester) async {
    await pumpScreen(
      tester,
      banner: const EventBanner(
        id: 'banner-2',
        title: '이벤트',
        subtitle: '설명',
        icon: 'unknown-icon',
      ),
    );

    await tester.tap(find.text('저장'));
    await tester.pumpAndSettle();

    expect(repository.savedBanner?.icon, defaultBannerIcon);
  });
}
