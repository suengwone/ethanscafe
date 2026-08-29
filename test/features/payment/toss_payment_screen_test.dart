import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cafe_app/core/theme/app_theme.dart';
import 'package:cafe_app/core/utils/text_utils.dart';
import 'package:cafe_app/features/payment/data/local_payments_repository.dart';
import 'package:cafe_app/features/payment/domain/payment_models.dart';
import 'package:cafe_app/features/payment/presentation/toss_payment_screen.dart';

import '../../support/localized_app.dart';

void main() {
  const request = PaymentRequest(
    orderId: 'bean-123456',
    orderName: '에티오피아 예가체프 외 1건',
    amount: 59000,
  );

  Future<void> pumpScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: testLocale,
        localizationsDelegates: testLocalizationsDelegates,
        supportedLocales: testSupportedLocales,
        theme: buildAppTheme(),
        home: TossPaymentScreen(
          request: request,
          repository: LocalPaymentsRepository(),
          webViewBuilder: (context) => const ColoredBox(color: foxtrotBlack),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('결제 화면에 주문명과 금액이 표시된다', (tester) async {
    await pumpScreen(tester);

    expect(find.text('결제하기'), findsOneWidget);
    expect(find.text('에티오피아 예가체프 외 1건'.keepWord), findsOneWidget);
    expect(find.text('59,000원'), findsOneWidget);
    expect(find.text('토스페이먼츠 안전결제'), findsOneWidget);
  });
}
