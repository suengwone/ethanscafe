import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cafe_app/features/points/presentation/points_screen.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<void> pumpPointsScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: PointsScreen()),
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

  testWidgets('결제 금액을 입력하면 10%가 적립된다', (WidgetTester tester) async {
    await pumpPointsScreen(tester);

    await tester.tap(find.text('결제 적립'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), '12000');
    await tester.tap(find.text('적립'));
    await tester.pumpAndSettle();

    expect(find.text('1,200P'), findsOneWidget);
    expect(find.text('+1,200P'), findsOneWidget);
    expect(find.text('결제 12,000원'), findsOneWidget);
  });

  testWidgets('적립된 포인트를 사용하면 잔액이 차감된다', (WidgetTester tester) async {
    await pumpPointsScreen(tester);

    await tester.tap(find.text('결제 적립'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), '10000');
    await tester.tap(find.text('적립'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('포인트 사용'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), '700');
    await tester.tap(find.text('사용'));
    await tester.pumpAndSettle();

    expect(find.text('300P'), findsOneWidget);
    expect(find.text('-700P'), findsOneWidget);
  });

  testWidgets('잔액보다 많은 포인트는 사용할 수 없다', (WidgetTester tester) async {
    await pumpPointsScreen(tester);

    await tester.tap(find.text('결제 적립'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), '10000');
    await tester.tap(find.text('적립'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('포인트 사용'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), '1001');
    await tester.tap(find.text('사용'));
    await tester.pumpAndSettle();

    expect(find.text('포인트 잔액이 부족합니다.'), findsOneWidget);
    expect(find.text('1,000P'), findsOneWidget);
  });
}
