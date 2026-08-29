import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cafe_app/core/theme/app_theme.dart';
import 'package:cafe_app/core/utils/text_utils.dart';
import 'package:cafe_app/features/order/presentation/order_history_screen.dart';
import 'package:cafe_app/features/review/data/local_reviews_repository.dart';
import 'package:cafe_app/features/review/presentation/review_sheet.dart';

import '../../support/localized_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({
      'pickup_orders': jsonEncode({
        'orders': [
          {
            'id': 'pickup-1',
            'storeId': 'macheon',
            'storeName': '폭스트롯 마천점',
            'pickupNumber': 3,
            'items': [
              {
                'menuId': 'espresso-vanilla-latte',
                'menuName': '바닐라 라떼',
                'option': 'ICED',
                'quantity': 1,
                'unitPrice': 6000,
              },
            ],
            'totalAmount': 6000,
            'status': 'pickedUp',
            'createdAt': '2026-08-05T11:20:00.000',
          },
          {
            'id': 'pickup-2',
            'storeId': 'macheon',
            'storeName': '폭스트롯 마천점',
            'pickupNumber': 4,
            'items': [
              {
                'menuId': 'espresso-americano',
                'menuName': '아메리카노',
                'quantity': 1,
                'unitPrice': 5000,
              },
            ],
            'totalAmount': 5000,
            'status': 'preparing',
            'createdAt': '2026-08-06T11:20:00.000',
          },
        ],
      }),
      'bean_orders': jsonEncode({
        'orders': [
          {
            'id': 'bean-1',
            'items': [
              {
                'beanId': 'ethiopia-yirgacheffe-aricha',
                'beanName': '에티오피아 예가체프 아리차',
                'weight': 'g200',
                'grind': 'handDrip',
                'quantity': 1,
                'unitPrice': 18000,
              },
            ],
            'totalAmount': 18000,
            'fulfillmentMethod': 'delivery',
            'status': 'delivered',
            'createdAt': '2026-08-03T16:40:00.000',
          },
        ],
      }),
    });
  });

  Future<void> pumpOrderHistory(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          locale: testLocale,
          localizationsDelegates: testLocalizationsDelegates,
          supportedLocales: testSupportedLocales,
          theme: buildAppTheme(),
          home: const OrderHistoryScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('픽업 완료 주문에는 리뷰 쓰기 버튼이 보이고 진행 중 주문에는 없다', (tester) async {
    await pumpOrderHistory(tester);

    expect(find.text('리뷰 쓰기'), findsNWidgets(2));
    expect(find.text('바닐라 라떼'.keepWord), findsWidgets);
    expect(find.text('아메리카노'.keepWord), findsWidgets);
  });

  testWidgets('리뷰를 등록하면 별점이 표시되고 통계에 반영된다', (tester) async {
    await pumpOrderHistory(tester);

    await tester.tap(find.text('리뷰 쓰기').first);
    await tester.pumpAndSettle();

    expect(find.byType(ReviewSheet), findsOneWidget);

    await tester.enterText(find.byType(TextField), '향이 정말 좋아요');
    await tester.tap(find.text('후기 등록'));
    await tester.pumpAndSettle();

    expect(find.byType(ReviewSheet), findsNothing);
    expect(find.text('소중한 후기가 등록되었습니다.'), findsOneWidget);
    expect(find.text('리뷰 쓰기'), findsOneWidget);
    expect(find.text('“향이 정말 좋아요”'.keepWord), findsOneWidget);

    final stats = await LocalReviewsRepository().loadStats();
    expect(stats.values.single.ratingSum, 5);
    expect(stats.values.single.ratingCount, 1);
  });
}
