import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cafe_app/core/theme/app_theme.dart';
import 'package:cafe_app/core/widgets/app_shell.dart';
import 'package:cafe_app/features/auth/domain/auth_models.dart';
import 'package:cafe_app/features/auth/presentation/auth_providers.dart';
import 'package:cafe_app/features/auth/presentation/login_screen.dart';
import 'package:cafe_app/features/beans/presentation/bean_detail_screen.dart';
import 'package:cafe_app/features/coupon/presentation/coupon_list_screen.dart';
import 'package:cafe_app/features/coupon/presentation/coupons_providers.dart';
import 'package:cafe_app/features/menu/presentation/favorite_menu_screen.dart';
import 'package:cafe_app/features/menu/presentation/menu_detail_screen.dart';
import 'package:cafe_app/features/menu/presentation/menu_screen.dart';
import 'package:cafe_app/features/notice/presentation/notice_list_screen.dart';
import 'package:cafe_app/features/store/presentation/store_list_screen.dart';
import 'package:cafe_app/features/points/presentation/points_screen.dart';
import 'package:cafe_app/features/profile/presentation/notification_settings_screen.dart';
import 'package:cafe_app/features/profile/presentation/profile_screen.dart';
import 'package:cafe_app/router/app_router.dart';

import '../features/auth/fake_auth_repository.dart';

Future<void> _loadFont(String family, String path) async {
  final file = File(path);
  if (!file.existsSync()) {
    return;
  }
  final bytes = await file.readAsBytes();
  final fontLoader = FontLoader(family)
    ..addFont(Future.value(ByteData.view(bytes.buffer)));
  await fontLoader.load();
}

Future<void> _loadPackageFont(String family, String assetKey) async {
  final fontLoader = FontLoader(family)..addFont(rootBundle.load(assetKey));
  await fontLoader.load();
}

const _lucideFonts = {
  'Lucide': 'assets/lucide.ttf',
  'Lucide300': 'assets/build_font/LucideVariable-w300.ttf',
  'Lucide600': 'assets/build_font/LucideVariable-w600.ttf',
};

Future<void> _loadFonts() async {
  await _loadFont('Roboto', '/System/Library/Fonts/AppleSDGothicNeo.ttc');

  final flutterRoot = Platform.environment['FLUTTER_ROOT'];
  if (flutterRoot != null) {
    await _loadFont(
      'MaterialIcons',
      '$flutterRoot/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
    );
  }

  for (final entry in _lucideFonts.entries) {
    await _loadPackageFont(
      'packages/lucide_icons_flutter/${entry.key}',
      'packages/lucide_icons_flutter/${entry.value}',
    );
  }
}

const _previewUser = AppUser(
  uid: 'preview-user',
  displayName: '이단',
  email: 'ethan@example.com',
  providerId: 'google',
);

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await _loadFonts();
  });

  setUp(() {
    PackageInfo.setMockInitialValues(
      appName: "Ethan's Cafe",
      packageName: 'com.ethanscafe.cafe_app',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: '',
    );
    SharedPreferences.setMockInitialValues({
      'favorite_menu_ids': [
        'espresso-vanilla-latte',
        'beverage-matcha-latte',
      ],
      'points_data': jsonEncode({
        'membershipId': 'MEMBER-12345678',
        'balance': 1250,
        'history': [
          {
            'id': 'h3',
            'type': 'earn',
            'description': '매장 결제',
            'amount': 550,
            'paymentAmount': 5500,
            'createdAt': '2026-08-01T10:30:00.000',
          },
          {
            'id': 'h2',
            'type': 'use',
            'description': '포인트 결제',
            'amount': -500,
            'createdAt': '2026-07-25T14:05:00.000',
          },
          {
            'id': 'h1',
            'type': 'earn',
            'description': '매장 결제',
            'amount': 1200,
            'paymentAmount': 12000,
            'createdAt': '2026-07-20T09:12:00.000',
          },
        ],
      }),
    });
  });

  Future<void> configureView(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);
  }

  Future<void> pumpScreen(WidgetTester tester, Widget screen) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: buildAppTheme(),
          home: screen,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> pumpApp(WidgetTester tester, {AppUser? user}) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            FakeAuthRepository(user: user),
          ),
        ],
        child: Consumer(
          builder: (context, ref, _) {
            final router = ref.watch(routerProvider);
            return MaterialApp.router(
              theme: buildAppTheme(),
              routerConfig: router,
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('홈 화면(게스트) 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpApp(tester);

    await expectLater(
      find.byType(AppShell),
      matchesGoldenFile('../../preview/home_screen.png'),
    );
  });

  testWidgets('홈 화면(로그인) 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpApp(tester, user: _previewUser);

    await expectLater(
      find.byType(AppShell),
      matchesGoldenFile('../../preview/home_screen_logged_in.png'),
    );
  });

  testWidgets('알림 목록 화면 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpScreen(tester, const NoticeListScreen());

    await expectLater(
      find.byType(NoticeListScreen),
      matchesGoldenFile('../../preview/notice_list_screen.png'),
    );
  });

  testWidgets('매장 찾기 화면 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpScreen(tester, const StoreListScreen());

    await expectLater(
      find.byType(StoreListScreen),
      matchesGoldenFile('../../preview/store_list_screen.png'),
    );
  });

  testWidgets('포인트 화면 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpScreen(tester, const PointsScreen());

    await expectLater(
      find.byType(PointsScreen),
      matchesGoldenFile('../../preview/points_screen.png'),
    );
  });

  testWidgets('메뉴 화면 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpScreen(tester, const MenuScreen());

    await expectLater(
      find.byType(MenuScreen),
      matchesGoldenFile('../../preview/menu_screen.png'),
    );
  });

  testWidgets('메뉴 상세 화면 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpScreen(
      tester,
      const MenuDetailScreen(menuId: 'espresso-vanilla-latte'),
    );

    await expectLater(
      find.byType(MenuDetailScreen),
      matchesGoldenFile('../../preview/menu_detail_screen.png'),
    );
  });

  testWidgets('즐겨찾기 메뉴 화면 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpScreen(tester, const FavoriteMenuScreen());

    await expectLater(
      find.byType(FavoriteMenuScreen),
      matchesGoldenFile('../../preview/favorite_menu_screen.png'),
    );
  });

  testWidgets('원두 목록 화면 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpScreen(tester, const MenuScreen());

    final tabContext = tester.element(find.byType(TabBarView));
    DefaultTabController.of(tabContext).animateTo(5);
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MenuScreen),
      matchesGoldenFile('../../preview/beans_list_screen.png'),
    );
  });

  testWidgets('원두 상세 화면 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpScreen(
      tester,
      const BeanDetailScreen(beanId: 'ethiopia-yirgacheffe-aricha'),
    );

    await expectLater(
      find.byType(BeanDetailScreen),
      matchesGoldenFile('../../preview/bean_detail_screen.png'),
    );
  });

  testWidgets('원두 주문 바텀시트 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpScreen(
      tester,
      const BeanDetailScreen(beanId: 'ethiopia-yirgacheffe-aricha'),
    );

    await tester.tap(find.text('주문하기'));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../../preview/bean_order_sheet.png'),
    );
  });

  testWidgets('로그인 화면 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpScreen(tester, const LoginScreen());

    await expectLater(
      find.byType(LoginScreen),
      matchesGoldenFile('../../preview/login_screen.png'),
    );
  });

  testWidgets('프로필 화면(게스트) 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpScreen(tester, const ProfileScreen());

    await expectLater(
      find.byType(ProfileScreen),
      matchesGoldenFile('../../preview/profile_screen.png'),
    );
  });

  testWidgets('알림 설정 화면 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpScreen(tester, const NotificationSettingsScreen());

    await expectLater(
      find.byType(NotificationSettingsScreen),
      matchesGoldenFile('../../preview/notification_settings_screen.png'),
    );
  });

  testWidgets('쿠폰함 화면 스크린샷', (WidgetTester tester) async {
    await configureView(tester);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            FakeAuthRepository(user: _previewUser),
          ),
          couponNowProvider.overrideWithValue(DateTime(2026, 8, 3)),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: buildAppTheme(),
          home: const CouponListScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(CouponListScreen),
      matchesGoldenFile('../../preview/coupon_list_screen.png'),
    );
  });

  testWidgets('프로필 화면(로그인) 스크린샷', (WidgetTester tester) async {
    await configureView(tester);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            FakeAuthRepository(user: _previewUser),
          ),
        ],
        child: MaterialApp(
          theme: buildAppTheme(),
          home: const ProfileScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(ProfileScreen),
      matchesGoldenFile('../../preview/profile_screen_logged_in.png'),
    );
  });
}
