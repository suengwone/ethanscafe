import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cafe_app/features/auth/domain/auth_models.dart';
import 'package:cafe_app/features/auth/presentation/auth_providers.dart';
import 'package:cafe_app/features/points/presentation/staff_qr_issue_screen.dart';

import '../auth/fake_auth_repository.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<void> pumpScreen(WidgetTester tester, {bool admin = true}) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            FakeAuthRepository(
              user: const AppUser(uid: 'staff-uid'),
              admin: admin,
            ),
          ),
        ],
        child: const MaterialApp(home: StaffQrIssueScreen()),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('직원이 아니면 발급 폼이 보이지 않는다', (WidgetTester tester) async {
    await pumpScreen(tester, admin: false);

    expect(find.text('직원 전용 기능입니다.'), findsOneWidget);
    expect(find.byType(TextFormField), findsNothing);
  });

  testWidgets('결제 금액을 입력하면 적립 QR이 발급된다', (WidgetTester tester) async {
    await pumpScreen(tester);

    await tester.enterText(find.widgetWithText(TextFormField, '결제 금액 (원)'), '12000');
    await tester.tap(find.widgetWithText(FilledButton, '적립 QR 발급'));
    await tester.pumpAndSettle();

    expect(find.byType(QrImageView), findsOneWidget);
    expect(find.textContaining('결제 12,000원'), findsOneWidget);
    expect(find.textContaining('적립 예정 1,200P'), findsOneWidget);
    expect(find.text('새 QR 발급'), findsOneWidget);
  });

  testWidgets('새 QR 발급을 누르면 폼으로 돌아간다', (WidgetTester tester) async {
    await pumpScreen(tester);

    await tester.enterText(find.widgetWithText(TextFormField, '결제 금액 (원)'), '5500');
    await tester.tap(find.widgetWithText(FilledButton, '적립 QR 발급'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('새 QR 발급'));
    await tester.pumpAndSettle();

    expect(find.byType(QrImageView), findsNothing);
    expect(find.text('적립 QR 발급'), findsWidgets);
  });

  testWidgets('금액이 비어 있으면 검증 오류를 보여준다', (WidgetTester tester) async {
    await pumpScreen(tester);

    await tester.tap(find.widgetWithText(FilledButton, '적립 QR 발급'));
    await tester.pumpAndSettle();

    expect(find.text('1 이상의 숫자를 입력해주세요.'), findsOneWidget);
    expect(find.byType(QrImageView), findsNothing);
  });
}
