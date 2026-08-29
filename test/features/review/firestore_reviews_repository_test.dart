import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cafe_app/features/review/data/firestore_reviews_repository.dart';
import 'package:cafe_app/features/review/domain/review_models.dart';

void main() {
  final review = ProductReview(
    id: 'review-1',
    productId: 'espresso-cafe-latte',
    productType: ReviewProductType.menu,
    productName: '카페 라떼',
    orderId: 'order-1',
    rating: 5,
    comment: '고소하고 부드러워요',
    createdAt: DateTime(2026, 8, 10, 12, 30),
  );

  group('productReviewToFirestore', () {
    test('리뷰를 Firestore 맵으로 직렬화한다', () {
      final map = productReviewToFirestore(review);

      expect(map['id'], 'review-1');
      expect(map['productId'], 'espresso-cafe-latte');
      expect(map['productType'], 'menu');
      expect(map['orderId'], 'order-1');
      expect(map['rating'], 5);
      expect(map['comment'], '고소하고 부드러워요');
      expect(map['createdAt'], isA<Timestamp>());
    });

    test('round trip 시 데이터가 보존된다', () {
      final restored = productReviewFromFirestore(
        productReviewToFirestore(review),
      );

      expect(restored, review);
    });
  });

  group('productReviewsFromFirestore', () {
    test('reviews 배열을 리뷰 목록으로 변환한다', () {
      final reviews = productReviewsFromFirestore(
        productReviewsToFirestore([review]),
      );

      expect(reviews, [review]);
    });

    test('데이터가 없으면 빈 목록을 반환한다', () {
      expect(productReviewsFromFirestore({}), isEmpty);
    });
  });

  group('productStatsFromFirestore', () {
    test('통계 필드를 변환한다', () {
      final stats = productStatsFromFirestore('espresso-cafe-latte', {
        'ratingSum': 9,
        'ratingCount': 2,
        'salesCount': 12,
      });

      expect(stats.productId, 'espresso-cafe-latte');
      expect(stats.ratingSum, 9);
      expect(stats.ratingCount, 2);
      expect(stats.salesCount, 12);
    });

    test('누락된 필드는 0으로 처리한다', () {
      final stats = productStatsFromFirestore('espresso-cafe-latte', {});

      expect(stats.ratingSum, 0);
      expect(stats.ratingCount, 0);
      expect(stats.salesCount, 0);
    });
  });
}
