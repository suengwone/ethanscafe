import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cafe_app/features/auth/domain/auth_models.dart';
import 'package:cafe_app/features/auth/presentation/auth_providers.dart';
import 'package:cafe_app/features/auth/presentation/login_screen.dart';
import 'package:cafe_app/features/beans/presentation/bean_detail_screen.dart';
import 'package:cafe_app/features/menu/presentation/menu_screen.dart';
import 'package:cafe_app/features/points/presentation/points_screen.dart';
import 'package:cafe_app/features/profile/presentation/profile_screen.dart';
import 'package:cafe_app/router/app_router.dart';

import '../features/auth/fake_auth_repository.dart';

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

  Future<GoRouter> pumpApp(
    WidgetTester tester, {
    AppUser? user,
  }) async {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(FakeAuthRepository(user: user)),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: Consumer(
          builder: (context, ref, _) {
            final router = ref.watch(routerProvider);
            return MaterialApp.router(routerConfig: router);
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
    expect(find.text('에티오피아 예가체프 아리차 에이미 G1'), findsOneWidget);
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
