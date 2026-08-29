import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cafe_app/core/theme/app_theme.dart';
import 'package:cafe_app/core/utils/text_utils.dart';
import 'package:cafe_app/features/menu/presentation/menu_detail_screen.dart';
import 'package:cafe_app/features/review/presentation/product_review_section.dart';

import '../../support/localized_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpMenuDetail(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          locale: testLocale,
          localizationsDelegates: testLocalizationsDelegates,
          supportedLocales: testSupportedLocales,
          theme: buildAppTheme(),
          home: const MenuDetailScreen(menuId: 'espresso-americano'),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('메뉴 상세에 상품 리뷰와 평균 별점이 표시된다', (tester) async {
    SharedPreferences.setMockInitialValues({
      'product_reviews': jsonEncode({
        'reviews': [
          {
            'id': 'review-1',
            'productId': 'espresso-americano',
            'productType': 'menu',
            'productName': '아메리카노',
            'orderId': 'order-1',
            'rating': 5,
            'comment': '고소하고 깔끔해요',
            'createdAt': '2026-08-01T10:00:00.000',
          },
          {
            'id': 'review-2',
            'productId': 'espresso-cafe-latte',
            'productType': 'menu',
            'productName': '카페 라떼',
            'orderId': 'order-1',
            'rating': 3,
            'comment': '다른 메뉴 리뷰',
            'createdAt': '2026-08-02T10:00:00.000',
          },
        ],
      }),
      'product_stats': jsonEncode({
        'espresso-americano': {
          'productId': 'espresso-americano',
          'ratingSum': 9,
          'ratingCount': 2,
          'salesCount': 4,
        },
      }),
    });

    await pumpMenuDetail(tester);

    expect(find.byType(ProductReviewSection), findsOneWidget);
    expect(find.text('리뷰'), findsOneWidget);
    expect(find.text('4.5'), findsOneWidget);
    expect(find.text('(2)'), findsOneWidget);
    expect(find.text('고소하고 깔끔해요'.keepWord), findsOneWidget);
    expect(find.text('다른 메뉴 리뷰'.keepWord), findsNothing);
  });

  testWidgets('리뷰가 없으면 안내 문구를 보여준다', (tester) async {
    SharedPreferences.setMockInitialValues({});

    await pumpMenuDetail(tester);

    expect(
      find.text('아직 리뷰가 없어요. 주문 내역에서 첫 리뷰를 남겨보세요.'.keepWord),
      findsOneWidget,
    );
  });
}
