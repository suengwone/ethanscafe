import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/review_models.dart';
import '../domain/reviews_repository.dart';

class LocalReviewsRepository implements ReviewsRepository {
  static const reviewsStorageKey = 'product_reviews';
  static const statsStorageKey = 'product_stats';

  @override
  Future<List<ProductReview>> loadMyReviews() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(reviewsStorageKey);
    if (raw == null) {
      return const [];
    }
    final data = jsonDecode(raw) as Map<String, dynamic>;
    return ((data['reviews'] as List<dynamic>?) ?? const [])
        .map((review) => ProductReview.fromJson(review as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<ProductReview>> loadProductReviews(String productId) async {
    final reviews = await loadMyReviews();
    return reviews.where((review) => review.productId == productId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<ProductReview> addReview({
    required String productId,
    required ReviewProductType productType,
    required String productName,
    required String orderId,
    required int rating,
    String comment = '',
  }) async {
    validateReviewRating(rating);

    final prefs = await SharedPreferences.getInstance();
    final reviews = await loadMyReviews();
    final alreadyReviewed = reviews.any(
      (review) => review.orderId == orderId && review.productId == productId,
    );
    if (alreadyReviewed) {
      throw StateError('이미 리뷰를 작성한 상품입니다.');
    }

    final review = ProductReview(
      id: _generateId(),
      productId: productId,
      productType: productType,
      productName: productName,
      orderId: orderId,
      rating: rating,
      comment: comment,
      createdAt: DateTime.now(),
    );

    await prefs.setString(
      reviewsStorageKey,
      jsonEncode({
        'reviews': [review, ...reviews].map((r) => r.toJson()).toList(),
      }),
    );

    final stats = await loadStats();
    final current = stats[productId] ?? ProductStats(productId: productId);
    stats[productId] = current.copyWith(
      ratingSum: current.ratingSum + rating,
      ratingCount: current.ratingCount + 1,
    );
    await _saveStats(prefs, stats);
    return review;
  }

  @override
  Future<Map<String, ProductStats>> loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(statsStorageKey);
    if (raw == null) {
      return {};
    }
    final data = jsonDecode(raw) as Map<String, dynamic>;
    return data.map(
      (productId, stats) => MapEntry(
        productId,
        ProductStats.fromJson(stats as Map<String, dynamic>),
      ),
    );
  }

  @override
  Future<void> recordSales(Map<String, int> quantitiesByProductId) async {
    if (quantitiesByProductId.isEmpty) {
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    final stats = await loadStats();
    for (final entry in quantitiesByProductId.entries) {
      final current = stats[entry.key] ?? ProductStats(productId: entry.key);
      stats[entry.key] = current.copyWith(
        salesCount: current.salesCount + entry.value,
      );
    }
    await _saveStats(prefs, stats);
  }

  Future<void> _saveStats(
    SharedPreferences prefs,
    Map<String, ProductStats> stats,
  ) {
    return prefs.setString(
      statsStorageKey,
      jsonEncode(
        stats.map((productId, stat) => MapEntry(productId, stat.toJson())),
      ),
    );
  }

  String _generateId() =>
      '${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(0xFFFF)}';
}
