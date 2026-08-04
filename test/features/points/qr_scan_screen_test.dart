import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cafe_app/features/points/presentation/qr_scan_screen.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<void> pumpScanScreen(WidgetTester tester, String scanCode) async {
    final router = GoRouter(
      initialLocation: '/points/scan',
      routes: [
        GoRoute(
          path: '/points',
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('포인트 화면'))),
          routes: [
            GoRoute(
              path: 'scan',
              builder: (context, state) => QrScanScreen(
                scannerBuilder: (context, onDetect) => Center(
                  child: TextButton(
                    onPressed: () => onDetect(scanCode),
                    child: const Text('가짜 스캔'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('유효한 QR 스캔 시 적립 완료 다이얼로그를 표시하고 닫으면 돌아간다', (tester) async {
    await pumpScanScreen(tester, 'FOXTROT-PAY:5500:폭스트롯 성수점');

    await tester.tap(find.text('가짜 스캔'));
    await tester.pumpAndSettle();

    expect(find.text('적립 완료'), findsOneWidget);
    expect(find.text('+550P'), findsOneWidget);
    expect(find.text('잔액 550P'), findsOneWidget);

    await tester.tap(find.text('확인'));
    await tester.pumpAndSettle();

    expect(find.text('포인트 화면'), findsOneWidget);
  });

  testWidgets('지원하지 않는 QR 스캔 시 에러 스낵바를 표시한다', (tester) async {
    await pumpScanScreen(tester, 'unknown-code');

    await tester.tap(find.text('가짜 스캔'));
    await tester.pump();

    expect(find.text('지원하지 않는 QR 코드입니다.'), findsOneWidget);
    expect(find.text('적립 완료'), findsNothing);

    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
  });
}
