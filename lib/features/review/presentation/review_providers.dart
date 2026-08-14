import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/presentation/auth_providers.dart';
import '../data/firestore_reviews_repository.dart';
import '../data/local_reviews_repository.dart';
import '../domain/review_models.dart';
import '../domain/reviews_repository.dart';

final reviewsRepositoryProvider = Provider<ReviewsRepository>((ref) {
  try {
    if (Firebase.apps.isNotEmpty) {
      final user = ref.watch(authStateProvider).value;
      if (user != null) {
        return FirestoreReviewsRepository(uid: user.uid);
      }
    }
  } catch (_) {}
  return LocalReviewsRepository();
});

final myReviewsControllerProvider =
    AsyncNotifierProvider<MyReviewsController, List<ProductReview>>(
      MyReviewsController.new,
    );

class MyReviewsController extends AsyncNotifier<List<ProductReview>> {
  @override
  Future<List<ProductReview>> build() {
    return ref.watch(reviewsRepositoryProvider).loadMyReviews();
  }

  Future<ProductReview> addReview({
    required String productId,
    required ReviewProductType productType,
    required String productName,
    required String orderId,
    required int rating,
    String comment = '',
  }) async {
    final review = await ref.read(reviewsRepositoryProvider).addReview(
          productId: productId,
          productType: productType,
          productName: productName,
          orderId: orderId,
          rating: rating,
          comment: comment,
        );
    state = AsyncValue.data([review, ...state.value ?? const []]);
    ref.invalidate(productStatsProvider);
    ref.invalidate(productReviewsProvider(productId));
    return review;
  }

  ProductReview? findReview({
    required String orderId,
    required String productId,
  }) {
    for (final review in state.value ?? const <ProductReview>[]) {
      if (review.orderId == orderId && review.productId == productId) {
        return review;
      }
    }
    return null;
  }
}

final productStatsProvider =
    FutureProvider<Map<String, ProductStats>>((ref) {
  return ref.watch(reviewsRepositoryProvider).loadStats();
});

final productReviewsProvider =
    FutureProvider.family<List<ProductReview>, String>((ref, productId) {
  return ref.watch(reviewsRepositoryProvider).loadProductReviews(productId);
});

final productBadgesProvider =
    FutureProvider<Map<String, Set<ProductBadge>>>((ref) async {
  final stats = await ref.watch(productStatsProvider.future);
  return computeStatsBadges(stats.values);
});
