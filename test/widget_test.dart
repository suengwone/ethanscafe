import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cafe_app/features/auth/domain/auth_models.dart';
import 'package:cafe_app/features/auth/presentation/auth_providers.dart';
import 'package:cafe_app/features/points/presentation/points_screen.dart';

import 'features/auth/fake_auth_repository.dart';

import 'support/localized_app.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  void seedBalance(int balance) {
    SharedPreferences.setMockInitialValues({
      'points_data': jsonEncode({
        'membershipId': 'MEMBER-12345678',
        'balance': balance,
        'history': [
          {
            'id': 'h1',
            'type': 'earn',
            'description': '폭스트롯',
            'amount': balance,
            'paymentAmount': balance * 10,
            'createdAt': '2026-08-01T10:30:00.000',
          },
        ],
      }),
    });
  }

  Future<void> pumpPointsScreen(
    WidgetTester tester, {
    bool admin = false,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            FakeAuthRepository(
              user: const AppUser(uid: 'test-uid'),
              admin: admin,
            ),
          ),
        ],
        child: const MaterialApp(
          locale: testLocale,
          localizationsDelegates: testLocalizationsDelegates,
          supportedLocales: testSupportedLocales,
          home: PointsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('포인트 화면이 기본 상태를 표시한다', (WidgetTester tester) async {
    await pumpPointsScreen(tester);

    expect(find.text('나의 포인트'), findsOneWidget);
    expect(find.text('0P'), findsOneWidget);
    expect(find.text('적립/사용 내역이 없습니다.'), findsOneWidget);
    expect(
      tester
          .widget<OutlinedButton>(find.widgetWithText(OutlinedButton, '포인트 사용'))
          .onPressed,
      isNull,
    );
  });

  testWidgets('사용자가 직접 적립할 수 있는 버튼이 없다', (WidgetTester tester) async {
    await pumpPointsScreen(tester);

    expect(find.text('결제 적립'), findsNothing);
    expect(find.text('직원 모드'), findsNothing);
    expect(find.text('적립 QR 발급'), findsNothing);
  });

  testWidgets('직원 계정에는 회원 QR 스캔 적립 진입점이 보인다', (WidgetTester tester) async {
    await pumpPointsScreen(tester, admin: true);

    expect(find.text('직원 모드'), findsOneWidget);
    expect(find.text('회원 QR 스캔 포인트 적립'), findsOneWidget);
  });

  testWidgets('적립된 포인트를 사용하면 잔액이 차감된다', (WidgetTester tester) async {
    seedBalance(1000);
    await pumpPointsScreen(tester);

    await tester.tap(find.text('포인트 사용'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), '700');
    await tester.tap(find.text('사용'));
    await tester.pumpAndSettle();

    expect(find.text('300P'), findsOneWidget);
    expect(find.text('-700P'), findsOneWidget);
    expect(find.text('700P를 사용했어요. 남은 포인트 300P'), findsOneWidget);
  });

  testWidgets('잔액보다 많은 포인트는 사용할 수 없다', (WidgetTester tester) async {
    seedBalance(1000);
    await pumpPointsScreen(tester);

    await tester.tap(find.text('포인트 사용'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), '1001');
    await tester.tap(find.text('사용'));
    await tester.pumpAndSettle();

    expect(find.text('포인트 잔액이 부족합니다.'), findsOneWidget);
    expect(find.text('1,000P'), findsOneWidget);
  });
}
