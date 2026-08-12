import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_models.freezed.dart';
part 'review_models.g.dart';

enum ReviewProductType {
  menu('메뉴'),
  bean('원두');

  const ReviewProductType(this.label);

  final String label;
}

enum ProductBadge { hit, best }

@freezed
abstract class ProductReview with _$ProductReview {
  const ProductReview._();

  const factory ProductReview({
    required String id,
    required String productId,
    required ReviewProductType productType,
    required String productName,
    required String orderId,
    required int rating,
    @Default('') String comment,
    required DateTime createdAt,
  }) = _ProductReview;

  factory ProductReview.fromJson(Map<String, dynamic> json) =>
      _$ProductReviewFromJson(json);
}

@freezed
abstract class ProductStats with _$ProductStats {
  const ProductStats._();

  const factory ProductStats({
    required String productId,
    @Default(0) int ratingSum,
    @Default(0) int ratingCount,
    @Default(0) int salesCount,
  }) = _ProductStats;

  factory ProductStats.fromJson(Map<String, dynamic> json) =>
      _$ProductStatsFromJson(json);

  bool get hasRating => ratingCount > 0;

  double get averageRating => hasRating ? ratingSum / ratingCount : 0;
}

const minReviewRating = 1;
const maxReviewRating = 5;

void validateReviewRating(int rating) {
  if (rating < minReviewRating || rating > maxReviewRating) {
    throw ArgumentError.value(
      rating,
      'rating',
      '별점은 $minReviewRating~$maxReviewRating점 사이여야 합니다.',
    );
  }
}

/// 상품 통계로부터 hit(최고 평점)·best(최다 판매) 배지를 계산한다.
Map<String, Set<ProductBadge>> computeStatsBadges(
  Iterable<ProductStats> stats,
) {
  final badges = <String, Set<ProductBadge>>{};

  final rated = stats.where((entry) => entry.hasRating).toList();
  if (rated.isNotEmpty) {
    final maxAverage = rated
        .map((entry) => entry.averageRating)
        .reduce((a, b) => a > b ? a : b);
    for (final entry in rated) {
      if ((entry.averageRating - maxAverage).abs() < 1e-9) {
        badges.putIfAbsent(entry.productId, () => {}).add(ProductBadge.hit);
      }
    }
  }

  final sold = stats.where((entry) => entry.salesCount > 0).toList();
  if (sold.isNotEmpty) {
    final maxSales = sold
        .map((entry) => entry.salesCount)
        .reduce((a, b) => a > b ? a : b);
    for (final entry in sold) {
      if (entry.salesCount == maxSales) {
        badges.putIfAbsent(entry.productId, () => {}).add(ProductBadge.best);
      }
    }
  }

  return badges;
}
