import 'package:flutter_test/flutter_test.dart';

import 'package:cafe_app/features/review/domain/review_models.dart';

void main() {
  group('ProductStats', () {
    test('평균 별점을 계산한다', () {
      const stats = ProductStats(
        productId: 'latte',
        ratingSum: 9,
        ratingCount: 2,
      );

      expect(stats.averageRating, 4.5);
      expect(stats.hasRating, isTrue);
    });

    test('리뷰가 없으면 평균은 0이다', () {
      const stats = ProductStats(productId: 'latte');

      expect(stats.averageRating, 0);
      expect(stats.hasRating, isFalse);
    });

    test('json round trip 시 데이터가 보존된다', () {
      const stats = ProductStats(
        productId: 'latte',
        ratingSum: 9,
        ratingCount: 2,
        salesCount: 12,
      );

      expect(ProductStats.fromJson(stats.toJson()), stats);
    });
  });

  group('validateReviewRating', () {
    test('1~5점은 허용한다', () {
      expect(() => validateReviewRating(1), returnsNormally);
      expect(() => validateReviewRating(5), returnsNormally);
    });

    test('범위를 벗어나면 예외를 던진다', () {
      expect(() => validateReviewRating(0), throwsArgumentError);
      expect(() => validateReviewRating(6), throwsArgumentError);
    });
  });

  group('computeStatsBadges', () {
    test('평균 별점이 가장 높은 상품에 hit 배지를 부여한다', () {
      final badges = computeStatsBadges(const [
        ProductStats(productId: 'latte', ratingSum: 10, ratingCount: 2),
        ProductStats(productId: 'americano', ratingSum: 8, ratingCount: 2),
      ]);

      expect(badges['latte'], contains(ProductBadge.hit));
      expect(badges['americano'], isNull);
    });

    test('최고 평균이 동률이면 모두 hit 배지를 받는다', () {
      final badges = computeStatsBadges(const [
        ProductStats(productId: 'latte', ratingSum: 10, ratingCount: 2),
        ProductStats(productId: 'mocha', ratingSum: 5, ratingCount: 1),
        ProductStats(productId: 'americano', ratingSum: 4, ratingCount: 1),
      ]);

      expect(badges['latte'], contains(ProductBadge.hit));
      expect(badges['mocha'], contains(ProductBadge.hit));
      expect(badges['americano'], isNull);
    });

    test('판매량이 가장 많은 상품에 best 배지를 부여한다', () {
      final badges = computeStatsBadges(const [
        ProductStats(productId: 'latte', salesCount: 3),
        ProductStats(productId: 'americano', salesCount: 10),
      ]);

      expect(badges['americano'], contains(ProductBadge.best));
      expect(badges['latte'], isNull);
    });

    test('한 상품이 hit과 best를 동시에 받을 수 있다', () {
      final badges = computeStatsBadges(const [
        ProductStats(
          productId: 'latte',
          ratingSum: 5,
          ratingCount: 1,
          salesCount: 10,
        ),
        ProductStats(productId: 'americano', salesCount: 3),
      ]);

      expect(badges['latte'], {ProductBadge.hit, ProductBadge.best});
    });

    test('리뷰·판매 데이터가 없으면 배지를 부여하지 않는다', () {
      expect(computeStatsBadges(const []), isEmpty);
      expect(
        computeStatsBadges(const [ProductStats(productId: 'latte')]),
        isEmpty,
      );
    });
  });
}
