import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cafe_app/core/theme/app_theme.dart';
import 'package:cafe_app/core/utils/text_utils.dart';
import 'package:cafe_app/features/profile/presentation/payment_methods_screen.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<void> pumpScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: buildAppTheme(),
          home: const PaymentMethodsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> tapDeleteMenu(WidgetTester tester) async {
    await tester.tap(find.byIcon(LucideIcons.ellipsisVertical).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('삭제').last);
    await tester.pumpAndSettle();
  }

  testWidgets('삭제를 고르면 확인 다이얼로그를 먼저 보여준다', (tester) async {
    await pumpScreen(tester);
    final before = find.byType(Card).evaluate().length;

    await tapDeleteMenu(tester);

    expect(find.text('결제 수단 삭제'.keepWord), findsOneWidget);
    expect(find.byType(Card).evaluate().length, before);
  });

  testWidgets('확인 다이얼로그에서 취소하면 카드가 남는다', (tester) async {
    await pumpScreen(tester);
    final before = find.byType(Card).evaluate().length;

    await tapDeleteMenu(tester);
    await tester.tap(find.text('취소'));
    await tester.pumpAndSettle();

    expect(find.text('결제 수단 삭제'.keepWord), findsNothing);
    expect(find.byType(Card).evaluate().length, before);
  });

  testWidgets('확인 다이얼로그에서 삭제하면 카드가 지워지고 안내가 보인다', (tester) async {
    await pumpScreen(tester);
    final before = find.byType(Card).evaluate().length;

    await tapDeleteMenu(tester);
    await tester.tap(find.widgetWithText(FilledButton, '삭제'));
    await tester.pumpAndSettle();

    expect(find.byType(Card).evaluate().length, lessThan(before));
    expect(find.text('결제 수단을 삭제했어요.'), findsOneWidget);
  });
}
