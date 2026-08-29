import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cafe_app/core/theme/app_theme.dart';
import 'package:cafe_app/features/auth/domain/auth_models.dart';
import 'package:cafe_app/features/auth/presentation/auth_providers.dart';
import 'package:cafe_app/features/beans/presentation/bean_cart_screen.dart';
import 'package:cafe_app/features/beans/presentation/bean_detail_screen.dart';

import '../auth/fake_auth_repository.dart';

import '../../support/localized_app.dart';

const _member = AppUser(
  uid: 'test-uid',
  displayName: '테스트 사용자',
  email: 'test@example.com',
  providerId: 'google',
);

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<void> pumpBeanDetail(WidgetTester tester, {AppUser? user}) async {
    final router = GoRouter(
      initialLocation: '/menu/beans/ethiopia-yirgacheffe-aricha',
      routes: [
        GoRoute(
          path: '/menu/beans/:beanId',
          builder: (context, state) =>
              BeanDetailScreen(beanId: state.pathParameters['beanId']!),
        ),
        GoRoute(
          path: '/menu/beans-cart',
          builder: (context, state) => const BeanCartScreen(),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            FakeAuthRepository(user: user),
          ),
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

  testWidgets('바로 주문하면 장바구니에 담고 원두 장바구니로 이동한다', (tester) async {
    await pumpBeanDetail(tester, user: _member);

    await tester.tap(find.text('주문하기'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('14,000원 주문'));
    await tester.pumpAndSettle();

    expect(find.byType(BeanCartScreen), findsOneWidget);
    expect(find.text('원두 장바구니'), findsOneWidget);
    expect(find.text('원두 보러 가기'), findsNothing);
  });

  testWidgets('장바구니 담기를 선택하면 상세 화면에 남고 스낵바가 보인다', (tester) async {
    await pumpBeanDetail(tester, user: _member);

    await tester.tap(find.text('주문하기'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('장바구니 담기'));
    await tester.pumpAndSettle();

    expect(find.byType(BeanDetailScreen), findsOneWidget);
    expect(find.byType(BeanCartScreen), findsNothing);
    expect(find.textContaining('장바구니에 담았습니다'), findsOneWidget);
  });

  testWidgets('비회원이 주문하면 옵션 시트 대신 로그인 안내가 보인다', (tester) async {
    await pumpBeanDetail(tester);

    await tester.tap(find.text('주문하기'));
    await tester.pumpAndSettle();

    expect(find.text('원두 주문은 로그인 후 이용할 수 있어요.'), findsOneWidget);
    expect(find.text('14,000원 주문'), findsNothing);
  });
}
