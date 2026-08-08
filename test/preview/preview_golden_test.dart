import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cafe_app/core/theme/app_theme.dart';
import 'package:cafe_app/core/utils/text_utils.dart';
import 'package:cafe_app/core/widgets/app_shell.dart';
import 'package:cafe_app/features/auth/domain/auth_models.dart';
import 'package:cafe_app/features/auth/presentation/auth_providers.dart';
import 'package:cafe_app/features/auth/presentation/login_screen.dart';
import 'package:cafe_app/features/beans/data/local_beans_repository.dart';
import 'package:cafe_app/features/beans/domain/bean_models.dart';
import 'package:cafe_app/features/beans/presentation/bean_cart_providers.dart';
import 'package:cafe_app/features/beans/presentation/bean_cart_screen.dart';
import 'package:cafe_app/features/beans/presentation/bean_detail_screen.dart';
import 'package:cafe_app/features/coupon/presentation/coupon_list_screen.dart';
import 'package:cafe_app/features/coupon/presentation/coupons_providers.dart';
import 'package:cafe_app/features/menu/presentation/favorite_menu_screen.dart';
import 'package:cafe_app/features/menu/presentation/menu_detail_screen.dart';
import 'package:cafe_app/features/menu/presentation/menu_screen.dart';
import 'package:cafe_app/features/notice/presentation/notice_list_screen.dart';
import 'package:cafe_app/features/order/presentation/order_history_screen.dart';
import 'package:cafe_app/features/payment/data/local_payments_repository.dart';
import 'package:cafe_app/features/payment/domain/payment_models.dart';
import 'package:cafe_app/features/payment/presentation/toss_payment_screen.dart';
import 'package:cafe_app/features/store/presentation/store_list_screen.dart';
import 'package:cafe_app/features/points/presentation/points_screen.dart';
import 'package:cafe_app/features/points/presentation/qr_scan_screen.dart';
import 'package:cafe_app/features/profile/presentation/delivery_address_screen.dart';
import 'package:cafe_app/features/profile/presentation/notification_settings_screen.dart';
import 'package:cafe_app/features/profile/presentation/payment_methods_screen.dart';
import 'package:cafe_app/features/profile/presentation/policy_screen.dart';
import 'package:cafe_app/features/profile/presentation/profile_screen.dart';
import 'package:cafe_app/features/profile/presentation/support_screen.dart';
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
  const pretendardWeights = [
    'Regular',
    'Medium',
    'SemiBold',
    'Bold',
    'ExtraBold',
  ];
  for (final weight in pretendardWeights) {
    await _loadFont('Pretendard', 'assets/fonts/Pretendard-$weight.otf');
  }
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

Future<void> precacheAssetImages(WidgetTester tester) async {
  await tester.runAsync(() async {
    for (final element in find.byType(Image).evaluate()) {
      final image = element.widget as Image;
      await precacheImage(image.image, element);
    }
  });
  await tester.pumpAndSettle();
}

Future<void> expectGolden(Finder finder, String name) async {
  if (!autoUpdateGoldenFiles) {
    markTestSkipped('골든 스크린샷은 --update-goldens 실행 시에만 생성/비교합니다.');
    return;
  }
  await expectLater(finder, matchesGoldenFile('../../preview/$name.png'));
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
      appName: '폭스트롯',
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
      'bean_orders': jsonEncode({
        'orders': [
          {
            'id': 'order-2',
            'items': [
              {
                'beanId': 'ethiopia-yirgacheffe-aricha',
                'beanName': '에티오피아 예가체프 아리차 에이미 G1',
                'weight': 'g200',
                'grind': 'handDrip',
                'quantity': 2,
                'unitPrice': 18000,
              },
              {
                'beanId': 'brazil-monte-belo-yellow-bourbon',
                'beanName': '브라질 몬테 벨로 옐로우버본',
                'weight': 'g500',
                'grind': 'wholeBean',
                'quantity': 1,
                'unitPrice': 32000,
              },
            ],
            'totalAmount': 68000,
            'usedPoints': 3000,
            'earnedPoints': 6200,
            'couponId': 'bean-order-3000',
            'couponTitle': '원두 주문 3,000원 할인',
            'couponDiscount': 3000,
            'paymentKey': 'preview-payment-key',
            'paymentMethod': '카드',
            'status': 'roasting',
            'createdAt': '2026-08-03T16:40:00.000',
          },
          {
            'id': 'order-1',
            'items': [
              {
                'beanId': 'guatemala-antigua-la-gloria',
                'beanName': '과테말라 안티구아 라 글로리아 SHB',
                'weight': 'g200',
                'grind': 'wholeBean',
                'quantity': 1,
                'unitPrice': 16000,
              },
            ],
            'totalAmount': 16000,
            'usedPoints': 0,
            'earnedPoints': 1600,
            'status': 'delivered',
            'createdAt': '2026-07-22T13:10:00.000',
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

  Future<void> pumpScreen(
    WidgetTester tester,
    Widget screen, {
    List<Override> overrides = const [],
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
          ...overrides,
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: buildAppTheme(),
          home: screen,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await precacheAssetImages(tester);
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
    await precacheAssetImages(tester);
  }

  testWidgets('홈 화면(게스트) 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpApp(tester);

    await expectGolden(find.byType(AppShell), 'home_screen');
  });

  testWidgets('홈 화면(로그인) 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpApp(tester, user: _previewUser);

    await expectGolden(find.byType(AppShell), 'home_screen_logged_in');
  });

  testWidgets('알림 목록 화면 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpScreen(tester, const NoticeListScreen());

    await expectGolden(find.byType(NoticeListScreen), 'notice_list_screen');
  });

  testWidgets('매장 찾기 화면 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpScreen(tester, const StoreListScreen());

    await expectGolden(find.byType(StoreListScreen), 'store_list_screen');
  });

  testWidgets('포인트 화면 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpScreen(tester, const PointsScreen());

    await expectGolden(find.byType(PointsScreen), 'points_screen');
  });

  testWidgets('QR 스캔 적립 화면 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpScreen(
      tester,
      QrScanScreen(
        scannerBuilder: (context, onDetect) =>
            const ColoredBox(color: Color(0xFF1C1B1A)),
      ),
    );

    await expectGolden(find.byType(QrScanScreen), 'qr_scan_screen');
  });

  testWidgets('메뉴 화면 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpScreen(tester, const MenuScreen());

    await expectGolden(find.byType(MenuScreen), 'menu_screen');
  });

  testWidgets('메뉴 상세 화면 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpScreen(
      tester,
      const MenuDetailScreen(menuId: 'espresso-vanilla-latte'),
    );

    await expectGolden(find.byType(MenuDetailScreen), 'menu_detail_screen');
  });

  testWidgets('즐겨찾기 메뉴 화면 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpScreen(tester, const FavoriteMenuScreen());

    await expectGolden(find.byType(FavoriteMenuScreen), 'favorite_menu_screen');
  });

  testWidgets('원두 목록 화면 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpScreen(tester, const MenuScreen());

    final tabContext = tester.element(find.byType(TabBarView));
    DefaultTabController.of(tabContext).animateTo(5);
    await tester.pumpAndSettle();

    await expectGolden(find.byType(MenuScreen), 'beans_list_screen');
  });

  testWidgets('원두 상세 화면 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpScreen(
      tester,
      const BeanDetailScreen(beanId: 'ethiopia-yirgacheffe-aricha'),
    );

    await expectGolden(find.byType(BeanDetailScreen), 'bean_detail_screen');
  });

  testWidgets('원두 주문 바텀시트 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpScreen(
      tester,
      const BeanDetailScreen(beanId: 'ethiopia-yirgacheffe-aricha'),
    );

    await tester.tap(find.text('주문하기'));
    await tester.pumpAndSettle();

    await expectGolden(find.byType(MaterialApp), 'bean_order_sheet');
  });

  Future<void> fillBeanCart(WidgetTester tester, Finder finder) async {
    final container = ProviderScope.containerOf(tester.element(finder));
    final beans = await LocalBeansRepository().loadBeans();
    final notifier = container.read(beanCartProvider.notifier);
    notifier.add(
      bean: beans[0],
      weight: BeanWeight.g200,
      grind: GrindOption.handDrip,
    );
    notifier.add(
      bean: beans[1],
      weight: BeanWeight.g500,
      grind: GrindOption.wholeBean,
      quantity: 2,
    );
    await tester.pumpAndSettle();
  }

  testWidgets('원두 장바구니 화면 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpScreen(
      tester,
      const BeanCartScreen(),
      overrides: [couponNowProvider.overrideWithValue(DateTime(2026, 8, 3))],
    );

    await fillBeanCart(tester, find.byType(BeanCartScreen));

    await expectGolden(find.byType(BeanCartScreen), 'bean_cart_screen');
  });

  testWidgets('원두 장바구니 쿠폰 선택 바텀시트 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpScreen(
      tester,
      const BeanCartScreen(),
      overrides: [couponNowProvider.overrideWithValue(DateTime(2026, 8, 3))],
    );

    await fillBeanCart(tester, find.byType(BeanCartScreen));

    await tester.tap(find.text('쿠폰 선택'));
    await tester.pumpAndSettle();

    await expectGolden(find.byType(MaterialApp), 'bean_cart_coupon_sheet');
  });

  testWidgets('원두 장바구니 빈 화면 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpScreen(tester, const BeanCartScreen());

    await expectGolden(find.byType(BeanCartScreen), 'bean_cart_screen_empty');
  });

  testWidgets('원두 목록 장바구니 바 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpScreen(tester, const MenuScreen());

    final tabContext = tester.element(find.byType(TabBarView));
    DefaultTabController.of(tabContext).animateTo(5);
    await tester.pumpAndSettle();

    await fillBeanCart(tester, find.byType(MenuScreen));

    await expectGolden(find.byType(MenuScreen), 'beans_list_cart_bar');
  });

  testWidgets('토스 결제 화면 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpScreen(
      tester,
      TossPaymentScreen(
        request: const PaymentRequest(
          orderId: 'bean-preview-0001',
          orderName: '에티오피아 예가체프 아리차 에이미 G1 외 1건',
          amount: 59000,
        ),
        repository: LocalPaymentsRepository(),
        webViewBuilder: (context) => const ColoredBox(color: foxtrotBlack),
      ),
    );

    await expectGolden(find.byType(TossPaymentScreen), 'toss_payment_screen');
  });

  testWidgets('로그인 화면 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpScreen(tester, const LoginScreen());

    await expectGolden(find.byType(LoginScreen), 'login_screen');
  });

  testWidgets('프로필 화면(게스트) 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpScreen(tester, const ProfileScreen());

    await expectGolden(find.byType(ProfileScreen), 'profile_screen');
  });

  testWidgets('알림 설정 화면 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpScreen(tester, const NotificationSettingsScreen());

    await expectGolden(
      find.byType(NotificationSettingsScreen),
      'notification_settings_screen',
    );
  });

  testWidgets('주문 내역 화면 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpScreen(tester, const OrderHistoryScreen());

    await expectGolden(find.byType(OrderHistoryScreen), 'order_history_screen');
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

    await expectGolden(find.byType(CouponListScreen), 'coupon_list_screen');
  });

  testWidgets('쿠폰 사용 바텀시트 스크린샷', (WidgetTester tester) async {
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

    await tester.tap(find.text('웰컴 아메리카노 1잔'.keepWord).first);
    await tester.pumpAndSettle();

    await expectGolden(find.byType(MaterialApp), 'coupon_use_sheet');
  });

  testWidgets('결제 수단 관리 화면 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpScreen(tester, const PaymentMethodsScreen());

    await expectGolden(find.byType(PaymentMethodsScreen), 'payment_methods_screen');
  });

  testWidgets('배송지 관리 화면 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpScreen(tester, const DeliveryAddressScreen());

    await expectGolden(
      find.byType(DeliveryAddressScreen),
      'delivery_address_screen',
    );
  });

  testWidgets('고객센터 화면 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpScreen(tester, const SupportScreen());

    await expectGolden(find.byType(SupportScreen), 'support_screen');
  });

  testWidgets('이용약관 화면 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpScreen(tester, const PolicyScreen(type: PolicyType.terms));

    await expectGolden(find.byType(PolicyScreen), 'terms_screen');
  });

  testWidgets('개인정보처리방침 화면 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpScreen(tester, const PolicyScreen(type: PolicyType.privacy));

    await expectGolden(find.byType(PolicyScreen), 'privacy_screen');
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

    await expectGolden(find.byType(ProfileScreen), 'profile_screen_logged_in');
  });

  testWidgets('회원 탈퇴 확인 다이얼로그 스크린샷', (WidgetTester tester) async {
    await configureView(tester);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            FakeAuthRepository(user: _previewUser),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: buildAppTheme(),
          home: const ProfileScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('회원 탈퇴'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(find.text('회원 탈퇴'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('회원 탈퇴'));
    await tester.pumpAndSettle();

    await expectGolden(find.byType(MaterialApp), 'delete_account_dialog');
  });
}
