import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cafe_app/core/theme/app_theme.dart';
import 'package:cafe_app/core/utils/text_utils.dart';
import 'package:cafe_app/features/coupon/data/local_coupons_repository.dart';
import 'package:cafe_app/features/coupon/presentation/coupon_list_screen.dart';
import 'package:cafe_app/features/coupon/presentation/coupons_providers.dart';

void main() {
  Future<void> pumpCouponScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          couponsRepositoryProvider.overrideWithValue(LocalCouponsRepository()),
          couponNowProvider.overrideWithValue(DateTime(2026, 8, 3)),
        ],
        child: MaterialApp(
          theme: buildAppTheme(),
          home: const CouponListScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('사용 가능 쿠폰을 탭하면 사용 바텀시트가 열린다', (tester) async {
    await pumpCouponScreen(tester);

    await tester.tap(find.text('웰컴 아메리카노 1잔'.keepWord).first);
    await tester.pumpAndSettle();

    expect(find.text('사용하기'), findsOneWidget);
    expect(find.byType(QrImageView), findsOneWidget);
    expect(find.text('매장 직원에게 QR 코드를 보여주세요.\n직원 스캔·확인 후 사용하기 버튼을 눌러주세요.'),
        findsOneWidget);
  });

  testWidgets('직원 확인 다이얼로그에서 사용을 누르면 쿠폰이 사용 처리된다', (tester) async {
    await pumpCouponScreen(tester);
    expect(find.text('사용 가능 4장'), findsOneWidget);

    await tester.tap(find.text('웰컴 아메리카노 1잔'.keepWord).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('사용하기'));
    await tester.pumpAndSettle();

    expect(find.text('쿠폰 사용'), findsOneWidget);

    await tester.tap(find.text('사용'));
    await tester.pumpAndSettle();

    expect(find.text('쿠폰이 사용 처리되었습니다.'), findsOneWidget);
    expect(find.text('사용 가능 3장'), findsOneWidget);
  });

  testWidgets('다이얼로그에서 취소하면 쿠폰이 사용되지 않는다', (tester) async {
    await pumpCouponScreen(tester);

    await tester.tap(find.text('웰컴 아메리카노 1잔'.keepWord).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('사용하기'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('취소'));
    await tester.pumpAndSettle();

    expect(find.text('사용 가능 4장'), findsOneWidget);
  });

  testWidgets('사용 완료 쿠폰은 탭해도 시트가 열리지 않는다', (tester) async {
    await pumpCouponScreen(tester);

    await tester.scrollUntilVisible(
      find.text('카페 라떼 1잔 무료'.keepWord),
      200,
      scrollable: find.byType(Scrollable),
    );
    await tester.tap(find.text('카페 라떼 1잔 무료'.keepWord));
    await tester.pumpAndSettle();

    expect(find.text('사용하기'), findsNothing);
  });
}
