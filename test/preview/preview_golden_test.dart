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
import 'package:cafe_app/features/auth/domain/account_models.dart';
import 'package:cafe_app/features/auth/domain/auth_models.dart';
import 'package:cafe_app/features/auth/presentation/account_providers.dart';
import 'package:cafe_app/features/auth/presentation/auth_providers.dart';
import 'package:cafe_app/features/auth/presentation/business_register_screen.dart';
import 'package:cafe_app/features/auth/presentation/login_screen.dart';
import 'package:cafe_app/features/beans/data/local_beans_repository.dart';
import 'package:cafe_app/features/beans/domain/bean_models.dart';
import 'package:cafe_app/features/beans/presentation/bean_cart_providers.dart';
import 'package:cafe_app/features/beans/presentation/bean_cart_screen.dart';
import 'package:cafe_app/features/beans/presentation/bean_detail_screen.dart';
import 'package:cafe_app/features/coupon/presentation/coupon_list_screen.dart';
import 'package:cafe_app/features/coupon/presentation/coupons_providers.dart';
import 'package:cafe_app/features/gift/presentation/bean_gift_screen.dart';
import 'package:cafe_app/features/gift/presentation/gift_history_screen.dart';
import 'package:cafe_app/features/menu/data/local_menu_repository.dart';
import 'package:cafe_app/features/menu/domain/menu_models.dart';
import 'package:cafe_app/features/menu/presentation/favorite_menu_screen.dart';
import 'package:cafe_app/features/menu/presentation/menu_detail_screen.dart';
import 'package:cafe_app/features/menu/presentation/menu_screen.dart';
import 'package:cafe_app/features/notice/presentation/notice_list_screen.dart';
import 'package:cafe_app/features/order/domain/order_models.dart';
import 'package:cafe_app/features/order/presentation/order_history_screen.dart';
import 'package:cafe_app/features/payment/data/local_payments_repository.dart';
import 'package:cafe_app/features/payment/domain/payment_models.dart';
import 'package:cafe_app/features/payment/presentation/toss_payment_screen.dart';
import 'package:cafe_app/features/pickup/presentation/pickup_cart_providers.dart';
import 'package:cafe_app/features/pickup/presentation/pickup_cart_screen.dart';
import 'package:cafe_app/features/pickup/presentation/pickup_order_tracking_screen.dart';
import 'package:cafe_app/features/store/data/local_stores_repository.dart';
import 'package:cafe_app/features/store/presentation/store_list_screen.dart';
import 'package:cafe_app/features/subscription/presentation/subscription_list_screen.dart';
import 'package:cafe_app/features/wholesale/presentation/business_home_screen.dart';
import 'package:cafe_app/features/wholesale/presentation/wholesale_quote_history_screen.dart';
import 'package:cafe_app/features/wholesale/presentation/wholesale_quote_screen.dart';
import 'package:cafe_app/features/points/presentation/points_screen.dart';
import 'package:cafe_app/features/points/presentation/qr_scan_screen.dart';
import 'package:cafe_app/features/points/presentation/staff_qr_issue_screen.dart';
import 'package:cafe_app/features/profile/presentation/delivery_address_screen.dart';
import 'package:cafe_app/features/profile/presentation/notification_settings_screen.dart';
import 'package:cafe_app/features/profile/presentation/payment_methods_screen.dart';
import 'package:cafe_app/features/profile/presentation/policy_screen.dart';
import 'package:cafe_app/features/profile/presentation/profile_screen.dart';
import 'package:cafe_app/features/profile/presentation/support_screen.dart';
import 'package:cafe_app/router/app_router.dart';

import '../features/auth/fake_account_repository.dart';
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

const _previewBusinessProfile = AccountProfile(
  type: AccountType.business,
  business: BusinessProfile(
    companyName: '카페 어라운드',
    businessNumber: '220-81-62517',
    managerName: '김사장',
    phone: '010-1234-5678',
  ),
);

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
      'pickup_orders': jsonEncode({
        'orders': [
          {
            'id': 'pickup-2',
            'storeId': 'macheon',
            'storeName': '폭스트롯 마천점',
            'pickupNumber': 5,
            'items': [
              {
                'menuId': 'espresso-cafe-latte',
                'menuName': '카페 라떼',
                'option': 'HOT',
                'quantity': 1,
                'unitPrice': 5500,
              },
              {
                'menuId': 'beverage-matcha-latte',
                'menuName': '말차 라떼',
                'option': 'ICED',
                'quantity': 1,
                'unitPrice': 6500,
              },
            ],
            'totalAmount': 12000,
            'usedPoints': 0,
            'earnedPoints': 1200,
            'paymentKey': 'preview-pickup-key-2',
            'paymentMethod': '카드',
            'status': 'received',
            'createdAt': '2026-08-14T10:05:00.000',
          },
          {
            'id': 'pickup-1',
            'storeId': 'macheon',
            'storeName': '폭스트롯 마천점',
            'pickupNumber': 3,
            'items': [
              {
                'menuId': 'espresso-vanilla-latte',
                'menuName': '바닐라 라떼',
                'option': 'ICED',
                'quantity': 2,
                'unitPrice': 6000,
              },
              {
                'menuId': 'dessert-croissant',
                'menuName': '크루아상',
                'quantity': 1,
                'unitPrice': 4500,
              },
            ],
            'totalAmount': 16500,
            'usedPoints': 500,
            'earnedPoints': 1600,
            'paymentKey': 'preview-pickup-key',
            'paymentMethod': '카드',
            'status': 'pickedUp',
            'createdAt': '2026-08-05T11:20:00.000',
          },
        ],
      }),
      'product_stats': jsonEncode({
        'drip-indonesia-mandheling-g1': {
          'productId': 'drip-indonesia-mandheling-g1',
          'ratingSum': 15,
          'ratingCount': 3,
          'salesCount': 12,
        },
        'ethiopia-yirgacheffe-aricha': {
          'productId': 'ethiopia-yirgacheffe-aricha',
          'ratingSum': 10,
          'ratingCount': 2,
          'salesCount': 8,
        },
        'drip-peru-el-babaco-bourbon': {
          'productId': 'drip-peru-el-babaco-bourbon',
          'ratingSum': 12,
          'ratingCount': 3,
          'salesCount': 30,
        },
        'brazil-monte-belo-yellow-bourbon': {
          'productId': 'brazil-monte-belo-yellow-bourbon',
          'ratingSum': 8,
          'ratingCount': 2,
          'salesCount': 30,
        },
      }),
      'product_reviews': jsonEncode({
        'reviews': [
          {
            'id': 'review-1',
            'productId': 'guatemala-antigua-la-gloria',
            'productType': 'bean',
            'productName': '과테말라 안티구아 라 글로리아 SHB',
            'orderId': 'order-1',
            'rating': 5,
            'comment': '고소하고 묵직해서 매일 내려 마셔요',
            'createdAt': '2026-07-23T10:00:00.000',
          },
        ],
      }),
      'bean_subscriptions': jsonEncode({
        'subscriptions': [
          {
            'id': 'subscription-2',
            'beanId': 'ethiopia-yirgacheffe-aricha',
            'beanName': '에티오피아 예가체프 아리차 에이미 G1',
            'weight': 'g200',
            'grind': 'handDrip',
            'quantity': 1,
            'cycle': 'biweekly',
            'unitPrice': 18000,
            'status': 'active',
            'nextDeliveryDate': '2026-08-17T09:00:00.000',
            'createdAt': '2026-07-20T10:00:00.000',
          },
          {
            'id': 'subscription-1',
            'beanId': 'brazil-monte-belo-yellow-bourbon',
            'beanName': '브라질 몬테 벨로 옌로우버본',
            'weight': 'g500',
            'grind': 'wholeBean',
            'quantity': 2,
            'cycle': 'monthly',
            'unitPrice': 32000,
            'status': 'paused',
            'nextDeliveryDate': '2026-08-30T09:00:00.000',
            'createdAt': '2026-06-15T14:30:00.000',
          },
        ],
      }),
      'bean_gifts': jsonEncode({
        'gifts': [
          {
            'id': 'gift-2',
            'beanId': 'ethiopia-yirgacheffe-aricha',
            'beanName': '에티오피아 예가체프 아리차 에이미 G1',
            'weight': 'g200',
            'grind': 'wholeBean',
            'quantity': 1,
            'unitPrice': 18000,
            'recipientName': '김선물',
            'recipientPhone': '010-9876-5432',
            'message': '생일 축하해! 향긋한 아침 되길 바라요.',
            'status': 'sent',
            'createdAt': '2026-08-04T18:20:00.000',
          },
          {
            'id': 'gift-1',
            'beanId': 'drip-peru-el-babaco-bourbon',
            'beanName': '페루 엘 바바코 버본',
            'weight': 'g500',
            'grind': 'handDrip',
            'quantity': 2,
            'unitPrice': 30000,
            'recipientName': '박원두',
            'recipientPhone': '010-2222-3333',
            'message': '',
            'status': 'redeemed',
            'createdAt': '2026-07-18T11:05:00.000',
          },
        ],
      }),
      'wholesale_quotes': jsonEncode({
        'quotes': [
          {
            'id': 'quote-2',
            'companyName': '카페 어라운드',
            'items': [
              {
                'beanId': 'peru-el-babaco-bourbon',
                'beanName': '페루 엘 바바코 버번',
                'kg': 30,
                'pricePerKg': 39000,
              },
              {
                'beanId': 'ethiopia-yirgacheffe-aricha',
                'beanName': '에티오피아 예가체프 아리차 에이미 G1',
                'kg': 10,
                'pricePerKg': 52000,
              },
            ],
            'memo': '매주 월요일 오전 납품 부탁드립니다.',
            'status': 'quoted',
            'createdAt': '2026-08-10T09:30:00.000',
          },
          {
            'id': 'quote-1',
            'companyName': '카페 어라운드',
            'items': [
              {
                'beanId': 'brazil-monte-belo-yellow-bourbon',
                'beanName': '브라질 몬테 벨로 옐로우버본',
                'kg': 10,
                'pricePerKg': 37000,
              },
            ],
            'memo': '',
            'status': 'confirmed',
            'createdAt': '2026-07-28T15:10:00.000',
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
            'fulfillmentMethod': 'delivery',
            'recipient': '이단',
            'recipientPhone': '010-1234-5678',
            'shippingAddress': '서울 성동구 연무장길 47 101동 1001호',
            'status': 'received',
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
            'fulfillmentMethod': 'pickup',
            'storeId': 'macheon',
            'storeName': '폭스트롯 마천점',
            'status': 'pickedUp',
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

  testWidgets('원두 구독 바텀시트 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpScreen(
      tester,
      const BeanDetailScreen(beanId: 'ethiopia-yirgacheffe-aricha'),
    );

    await tester.tap(find.text('구독'));
    await tester.pumpAndSettle();

    await expectGolden(find.byType(MaterialApp), 'bean_subscribe_sheet');
  });

  testWidgets('구독 관리 화면 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpScreen(tester, const SubscriptionListScreen());

    await expectGolden(
      find.byType(SubscriptionListScreen),
      'subscription_list_screen',
    );
  });

  testWidgets('원두 선물하기 화면 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpScreen(
      tester,
      const BeanGiftScreen(beanId: 'ethiopia-yirgacheffe-aricha'),
    );

    await expectGolden(find.byType(BeanGiftScreen), 'bean_gift_screen');
  });

  testWidgets('선물 내역 화면 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpScreen(tester, const GiftHistoryScreen());

    await expectGolden(find.byType(GiftHistoryScreen), 'gift_history_screen');
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

  testWidgets('원두 장바구니 픽업 선택 화면 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpScreen(
      tester,
      const BeanCartScreen(),
      overrides: [couponNowProvider.overrideWithValue(DateTime(2026, 8, 3))],
    );

    await fillBeanCart(tester, find.byType(BeanCartScreen));

    final container = ProviderScope.containerOf(
      tester.element(find.byType(BeanCartScreen)),
    );
    container
        .read(beanFulfillmentMethodProvider.notifier)
        .select(BeanFulfillmentMethod.pickup);
    final stores = await LocalStoresRepository().loadStores();
    container.read(beanPickupStoreProvider.notifier).select(stores.first);
    await tester.pumpAndSettle();

    await expectGolden(
      find.byType(BeanCartScreen),
      'bean_cart_screen_pickup',
    );
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

  testWidgets('픽업 옵션 바텀시트 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpScreen(
      tester,
      const MenuDetailScreen(menuId: 'espresso-vanilla-latte'),
    );

    await tester.tap(find.text('주문하기'));
    await tester.pumpAndSettle();

    await expectGolden(find.byType(MaterialApp), 'pickup_option_sheet');
  });

  Future<void> fillPickupCart(WidgetTester tester, Finder finder) async {
    final container = ProviderScope.containerOf(tester.element(finder));
    final menuItems = await LocalMenuRepository().loadMenuItems();
    final latte = menuItems.firstWhere(
      (item) => item.id == 'espresso-vanilla-latte',
    );
    final dessert = menuItems.firstWhere(
      (item) => item.category == MenuCategory.dessert,
    );
    final notifier = container.read(pickupCartProvider.notifier);
    notifier.add(menuItem: latte, option: 'ICED', quantity: 2);
    notifier.add(menuItem: dessert);
    final stores = await LocalStoresRepository().loadStores();
    container.read(pickupStoreProvider.notifier).select(stores.first);
    await tester.pumpAndSettle();
  }

  testWidgets('픽업 장바구니 화면 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpScreen(
      tester,
      const PickupCartScreen(),
      overrides: [couponNowProvider.overrideWithValue(DateTime(2026, 8, 3))],
    );

    await fillPickupCart(tester, find.byType(PickupCartScreen));

    await expectGolden(find.byType(PickupCartScreen), 'pickup_cart_screen');
  });

  testWidgets('픽업 장바구니 빈 화면 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpScreen(tester, const PickupCartScreen());

    await expectGolden(
      find.byType(PickupCartScreen),
      'pickup_cart_screen_empty',
    );
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

  testWidgets('주문 상태 추적 화면 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpScreen(
      tester,
      const PickupOrderTrackingScreen(orderId: 'pickup-2'),
    );

    await expectGolden(
      find.byType(PickupOrderTrackingScreen),
      'pickup_order_tracking_screen',
    );
  });

  testWidgets('리뷰 작성 바텀시트 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpScreen(tester, const OrderHistoryScreen());

    await tester.tap(find.text('리뷰 쓰기').first);
    await tester.pumpAndSettle();

    await expectGolden(find.byType(MaterialApp), 'review_write_sheet');
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

  testWidgets('사업자 홈 화면 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpScreen(
      tester,
      const BusinessHomeScreen(),
      overrides: [
        accountRepositoryProvider.overrideWithValue(
          FakeAccountRepository(profile: _previewBusinessProfile),
        ),
      ],
    );

    await expectGolden(find.byType(BusinessHomeScreen), 'business_home_screen');
  });

  testWidgets('도매 견적 요청 화면 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpScreen(
      tester,
      const WholesaleQuoteScreen(initialBeanId: 'peru-el-babaco-bourbon'),
      overrides: [
        accountRepositoryProvider.overrideWithValue(
          FakeAccountRepository(profile: _previewBusinessProfile),
        ),
      ],
    );

    await expectGolden(
      find.byType(WholesaleQuoteScreen),
      'wholesale_quote_screen',
    );
  });

  testWidgets('도매 견적 내역 화면 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpScreen(tester, const WholesaleQuoteHistoryScreen());

    await expectGolden(
      find.byType(WholesaleQuoteHistoryScreen),
      'wholesale_quote_history_screen',
    );
  });

  testWidgets('사업자 계정 관리 화면 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpScreen(tester, const BusinessRegisterScreen());

    await expectGolden(
      find.byType(BusinessRegisterScreen),
      'business_register_screen',
    );
  });

  testWidgets('사업자 계정 관리 화면(저장된 정보) 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpScreen(
      tester,
      const BusinessRegisterScreen(),
      overrides: [
        accountRepositoryProvider.overrideWithValue(
          FakeAccountRepository(
            profile: AccountProfile(
              business: _previewBusinessProfile.business,
            ),
          ),
        ),
      ],
    );

    await expectGolden(
      find.byType(BusinessRegisterScreen),
      'business_register_screen_saved',
    );
  });

  testWidgets('로그아웃 확인 다이얼로그 스크린샷', (WidgetTester tester) async {
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
      find.text('로그아웃'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(find.text('로그아웃'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('로그아웃'));
    await tester.pumpAndSettle();

    await expectGolden(find.byType(MaterialApp), 'sign_out_dialog');
  });

  Future<void> pumpStaffQrIssueScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            FakeAuthRepository(user: _previewUser, admin: true),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: buildAppTheme(),
          home: const StaffQrIssueScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('직원 적립 QR 발급 화면 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpStaffQrIssueScreen(tester);

    await expectGolden(
      find.byType(StaffQrIssueScreen),
      'staff_qr_issue_screen',
    );
  });

  testWidgets('직원 적립 QR 발급 결과 스크린샷', (WidgetTester tester) async {
    await configureView(tester);
    await pumpStaffQrIssueScreen(tester);

    await tester.enterText(
      find.widgetWithText(TextFormField, '결제 금액 (원)'),
      '12000',
    );
    await tester.tap(find.widgetWithText(FilledButton, '적립 QR 발급'));
    await tester.pumpAndSettle();

    await expectGolden(
      find.byType(StaffQrIssueScreen),
      'staff_qr_issue_screen_result',
    );
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
