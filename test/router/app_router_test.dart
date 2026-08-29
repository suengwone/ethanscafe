import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cafe_app/core/utils/text_utils.dart';
import 'package:cafe_app/features/auth/domain/auth_models.dart';
import 'package:cafe_app/features/auth/presentation/auth_providers.dart';
import 'package:cafe_app/features/auth/presentation/login_screen.dart';
import 'package:cafe_app/features/beans/presentation/bean_cart_screen.dart';
import 'package:cafe_app/features/beans/presentation/bean_detail_screen.dart';
import 'package:cafe_app/features/gift/presentation/bean_gift_screen.dart';
import 'package:cafe_app/features/coupon/presentation/coupon_list_screen.dart';
import 'package:cafe_app/features/menu/presentation/favorite_menu_screen.dart';
import 'package:cafe_app/features/menu/presentation/menu_detail_screen.dart';
import 'package:cafe_app/features/menu/presentation/menu_screen.dart';
import 'package:cafe_app/features/notice/presentation/notice_list_screen.dart';
import 'package:cafe_app/features/pickup/presentation/pickup_cart_screen.dart';
import 'package:cafe_app/features/order/presentation/order_history_screen.dart';
import 'package:cafe_app/features/store/presentation/store_detail_screen.dart';
import 'package:cafe_app/features/store/presentation/store_list_screen.dart';
import 'package:cafe_app/features/points/presentation/points_screen.dart';
import 'package:cafe_app/features/profile/presentation/appearance_settings_screen.dart';
import 'package:cafe_app/features/profile/presentation/delivery_address_screen.dart';
import 'package:cafe_app/features/profile/presentation/payment_methods_screen.dart';
import 'package:cafe_app/features/profile/presentation/profile_screen.dart';
import 'package:cafe_app/features/profile/presentation/support_screen.dart';
import 'package:cafe_app/features/referral/presentation/referral_screen.dart';
import 'package:cafe_app/router/app_router.dart';

import '../features/auth/fake_auth_repository.dart';

import '../support/localized_app.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({
      'points_data': jsonEncode({
        'membershipId': 'MEMBER-12345678',
        'balance': 0,
        'history': [],
      }),
    });
  });

  Future<GoRouter> pumpApp(WidgetTester tester, {AppUser? user}) async {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          FakeAuthRepository(user: user),
        ),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: Consumer(
          builder: (context, ref, _) {
            final router = ref.watch(routerProvider);
            return MaterialApp.router(
              locale: testLocale,
              localizationsDelegates: testLocalizationsDelegates,
              supportedLocales: testSupportedLocales,
              routerConfig: router,
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    return container.read(routerProvider);
  }

  testWidgets('비로그인 시 포인트 화면은 로그인으로 리다이렉트된다', (tester) async {
    final router = await pumpApp(tester);

    router.go('/points');
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(PointsScreen), findsNothing);
  });

  testWidgets('비로그인 시 프로필 화면은 로그인으로 리다이렉트된다', (tester) async {
    final router = await pumpApp(tester);

    router.go('/profile');
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(ProfileScreen), findsNothing);
  });

  testWidgets('비로그인 시 픽업 장바구니는 로그인으로 리다이렉트된다', (tester) async {
    final router = await pumpApp(tester);

    router.go('/menu/cart');
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(PickupCartScreen), findsNothing);
  });

  testWidgets('비로그인 시 원두 장바구니는 로그인으로 리다이렉트된다', (tester) async {
    final router = await pumpApp(tester);

    router.go('/menu/beans-cart');
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(BeanCartScreen), findsNothing);
  });

  testWidgets('비로그인 시 원두 선물하기는 로그인으로 리다이렉트된다', (tester) async {
    final router = await pumpApp(tester);

    router.go('/menu/beans/ethiopia-yirgacheffe-aricha/gift');
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(BeanGiftScreen), findsNothing);
  });

  testWidgets('로그인 시 원두 선물하기 화면에 접근할 수 있다', (tester) async {
    final router = await pumpApp(
      tester,
      user: const AppUser(
        uid: 'test-uid',
        displayName: '테스트 사용자',
        email: 'test@example.com',
        providerId: 'google',
      ),
    );

    router.go('/menu/beans/ethiopia-yirgacheffe-aricha/gift');
    await tester.pumpAndSettle();

    expect(find.byType(BeanGiftScreen), findsOneWidget);
    expect(find.byType(LoginScreen), findsNothing);
  });

  testWidgets('비로그인 시 메뉴(원두 포함) 화면은 볼 수 있다', (tester) async {
    final router = await pumpApp(tester);

    router.go('/menu');
    await tester.pumpAndSettle();

    expect(find.byType(MenuScreen), findsOneWidget);
    expect(find.byType(LoginScreen), findsNothing);
  });

  testWidgets('비로그인 시 원두 상세 화면은 볼 수 있다', (tester) async {
    final router = await pumpApp(tester);

    router.go('/menu/beans/ethiopia-yirgacheffe-aricha');
    await tester.pumpAndSettle();

    expect(find.byType(BeanDetailScreen), findsOneWidget);
    expect(find.byType(LoginScreen), findsNothing);
    expect(find.text('에티오피아 예가체프 아리차 에이미 G1'.keepWord), findsOneWidget);
  });

  testWidgets('비로그인 시 메뉴 상세 화면은 볼 수 있다', (tester) async {
    final router = await pumpApp(tester);

    router.go('/menu/item/espresso-americano');
    await tester.pumpAndSettle();

    expect(find.byType(MenuDetailScreen), findsOneWidget);
    expect(find.byType(LoginScreen), findsNothing);
    expect(find.text('아메리카노'.keepWord), findsOneWidget);
  });

  testWidgets('비로그인 시 알림 목록 화면은 볼 수 있다', (tester) async {
    final router = await pumpApp(tester);

    router.go('/notices');
    await tester.pumpAndSettle();

    expect(find.byType(NoticeListScreen), findsOneWidget);
    expect(find.byType(LoginScreen), findsNothing);
  });

  testWidgets('비로그인 시 매장 찾기 화면은 볼 수 있다', (tester) async {
    final router = await pumpApp(tester);

    router.go('/stores');
    await tester.pumpAndSettle();

    expect(find.byType(StoreListScreen), findsOneWidget);
    expect(find.byType(LoginScreen), findsNothing);
  });

  testWidgets('비로그인 시 매장 상세 화면은 볼 수 있다', (tester) async {
    final router = await pumpApp(tester);

    router.go('/stores/macheon');
    await tester.pumpAndSettle();

    expect(find.byType(StoreDetailScreen), findsOneWidget);
    expect(find.byType(LoginScreen), findsNothing);
  });

  testWidgets('비로그인 시 즐겨찾기 메뉴는 로그인으로 리다이렉트된다', (tester) async {
    final router = await pumpApp(tester);

    router.go('/profile/favorites');
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(FavoriteMenuScreen), findsNothing);
  });

  testWidgets('로그인 시 즐겨찾기 메뉴 화면에 접근할 수 있다', (tester) async {
    final router = await pumpApp(
      tester,
      user: const AppUser(
        uid: 'test-uid',
        displayName: '테스트 사용자',
        email: 'test@example.com',
        providerId: 'google',
      ),
    );

    router.go('/profile/favorites');
    await tester.pumpAndSettle();

    expect(find.byType(FavoriteMenuScreen), findsOneWidget);
    expect(find.byType(LoginScreen), findsNothing);
  });

  testWidgets('비로그인 시 쿠폰함은 로그인으로 리다이렉트된다', (tester) async {
    final router = await pumpApp(tester);

    router.go('/profile/coupons');
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(CouponListScreen), findsNothing);
  });

  testWidgets('로그인 시 쿠폰함 화면에 접근할 수 있다', (tester) async {
    final router = await pumpApp(
      tester,
      user: const AppUser(
        uid: 'test-uid',
        displayName: '테스트 사용자',
        email: 'test@example.com',
        providerId: 'google',
      ),
    );

    router.go('/profile/coupons');
    await tester.pumpAndSettle();

    expect(find.byType(CouponListScreen), findsOneWidget);
    expect(find.byType(LoginScreen), findsNothing);
  });

  testWidgets('비로그인 시 주문 내역은 로그인으로 리다이렉트된다', (tester) async {
    final router = await pumpApp(tester);

    router.go('/profile/orders');
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(OrderHistoryScreen), findsNothing);
  });

  testWidgets('로그인 시 주문 내역 화면에 접근할 수 있다', (tester) async {
    final router = await pumpApp(
      tester,
      user: const AppUser(
        uid: 'test-uid',
        displayName: '테스트 사용자',
        email: 'test@example.com',
        providerId: 'google',
      ),
    );

    router.go('/profile/orders');
    await tester.pumpAndSettle();

    expect(find.byType(OrderHistoryScreen), findsOneWidget);
    expect(find.byType(LoginScreen), findsNothing);
  });

  testWidgets('비로그인 시 친구 초대는 로그인으로 리다이렉트된다', (tester) async {
    final router = await pumpApp(tester);

    router.go('/profile/referral');
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(ReferralScreen), findsNothing);
  });

  testWidgets('로그인 시 친구 초대 화면에 접근할 수 있다', (tester) async {
    final router = await pumpApp(
      tester,
      user: const AppUser(
        uid: 'test-uid',
        displayName: '테스트 사용자',
        email: 'test@example.com',
        providerId: 'google',
      ),
    );

    router.go('/profile/referral');
    await tester.pumpAndSettle();

    expect(find.byType(ReferralScreen), findsOneWidget);
    expect(find.byType(LoginScreen), findsNothing);
  });

  testWidgets('로그인 시 화면 테마 설정에 접근할 수 있다', (tester) async {
    final router = await pumpApp(
      tester,
      user: const AppUser(
        uid: 'test-uid',
        displayName: '테스트 사용자',
        email: 'test@example.com',
        providerId: 'google',
      ),
    );

    router.go('/profile/appearance');
    await tester.pumpAndSettle();

    expect(find.byType(AppearanceSettingsScreen), findsOneWidget);
    expect(find.byType(LoginScreen), findsNothing);
  });

  testWidgets('비로그인 시 결제 수단 관리는 로그인으로 리다이렉트된다', (tester) async {
    final router = await pumpApp(tester);

    router.go('/profile/payment-methods');
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(PaymentMethodsScreen), findsNothing);
  });

  testWidgets('로그인 시 결제 수단 관리 화면에 접근할 수 있다', (tester) async {
    final router = await pumpApp(
      tester,
      user: const AppUser(
        uid: 'test-uid',
        displayName: '테스트 사용자',
        email: 'test@example.com',
        providerId: 'google',
      ),
    );

    router.go('/profile/payment-methods');
    await tester.pumpAndSettle();

    expect(find.byType(PaymentMethodsScreen), findsOneWidget);
    expect(find.byType(LoginScreen), findsNothing);
  });

  testWidgets('로그인 시 배송지 관리 화면에 접근할 수 있다', (tester) async {
    final router = await pumpApp(
      tester,
      user: const AppUser(
        uid: 'test-uid',
        displayName: '테스트 사용자',
        email: 'test@example.com',
        providerId: 'google',
      ),
    );

    router.go('/profile/addresses');
    await tester.pumpAndSettle();

    expect(find.byType(DeliveryAddressScreen), findsOneWidget);
    expect(find.byType(LoginScreen), findsNothing);
  });

  testWidgets('로그인 시 고객센터 화면에 접근할 수 있다', (tester) async {
    final router = await pumpApp(
      tester,
      user: const AppUser(
        uid: 'test-uid',
        displayName: '테스트 사용자',
        email: 'test@example.com',
        providerId: 'google',
      ),
    );

    router.go('/profile/support');
    await tester.pumpAndSettle();

    expect(find.byType(SupportScreen), findsOneWidget);
    expect(find.byType(LoginScreen), findsNothing);
  });

  testWidgets('로그인 시 포인트 화면에 접근할 수 있다', (tester) async {
    final router = await pumpApp(
      tester,
      user: const AppUser(
        uid: 'test-uid',
        displayName: '테스트 사용자',
        email: 'test@example.com',
        providerId: 'google',
      ),
    );

    router.go('/points');
    await tester.pumpAndSettle();

    expect(find.byType(PointsScreen), findsOneWidget);
    expect(find.byType(LoginScreen), findsNothing);
  });
}
