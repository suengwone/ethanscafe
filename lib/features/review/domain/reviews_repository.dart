import 'review_models.dart';

abstract class ReviewsRepository {
  Future<List<ProductReview>> loadMyReviews();

  Future<List<ProductReview>> loadProductReviews(String productId);

  Future<ProductReview> addReview({
    required String productId,
    required ReviewProductType productType,
    required String productName,
    required String orderId,
    required int rating,
    String comment = '',
  });

  Future<Map<String, ProductStats>> loadStats();

  Future<void> recordSales(Map<String, int> quantitiesByProductId);
}
