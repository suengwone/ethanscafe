import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/firebase/firestore_converters.dart';
import '../domain/review_models.dart';
import '../domain/reviews_repository.dart';

class FirestoreReviewsRepository implements ReviewsRepository {
  FirestoreReviewsRepository({
    required this.uid,
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final String uid;
  final FirebaseFirestore _firestore;

  static const reviewsCollectionPath = 'reviews';
  static const statsCollectionPath = 'product_stats';

  DocumentReference<Map<String, dynamic>> get _reviewsDoc =>
      _firestore.collection(reviewsCollectionPath).doc(uid);

  @override
  Future<List<ProductReview>> loadMyReviews() async {
    final snapshot = await _reviewsDoc.get();
    final data = snapshot.data();
    if (data == null) {
      return const [];
    }
    return productReviewsFromFirestore(data);
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

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(_reviewsDoc);
      final data = snapshot.data();
      final reviews = data != null
          ? productReviewsFromFirestore(data)
          : const <ProductReview>[];
      final alreadyReviewed = reviews.any(
        (existing) =>
            existing.orderId == orderId && existing.productId == productId,
      );
      if (alreadyReviewed) {
        throw StateError('이미 리뷰를 작성한 상품입니다.');
      }
      transaction.set(
        _reviewsDoc,
        productReviewsToFirestore([review, ...reviews]),
      );
    });

    await _firestore.collection(statsCollectionPath).doc(productId).set(
      {
        'ratingSum': FieldValue.increment(rating),
        'ratingCount': FieldValue.increment(1),
      },
      SetOptions(merge: true),
    );
    return review;
  }

  @override
  Future<Map<String, ProductStats>> loadStats() async {
    final snapshot = await _firestore.collection(statsCollectionPath).get();
    return {
      for (final doc in snapshot.docs)
        doc.id: productStatsFromFirestore(doc.id, doc.data()),
    };
  }

  @override
  Future<void> recordSales(Map<String, int> quantitiesByProductId) async {
    if (quantitiesByProductId.isEmpty) {
      return;
    }
    final batch = _firestore.batch();
    for (final entry in quantitiesByProductId.entries) {
      batch.set(
        _firestore.collection(statsCollectionPath).doc(entry.key),
        {'salesCount': FieldValue.increment(entry.value)},
        SetOptions(merge: true),
      );
    }
    await batch.commit();
  }

  String _generateId() =>
      '${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(0xFFFF)}';
}

List<ProductReview> productReviewsFromFirestore(Map<String, dynamic> data) {
  return ((data['reviews'] as List<dynamic>?) ?? const [])
      .map(
        (review) => productReviewFromFirestore(review as Map<String, dynamic>),
      )
      .toList();
}

ProductReview productReviewFromFirestore(Map<String, dynamic> data) {
  return ProductReview(
    id: data['id'] as String? ?? '',
    productId: data['productId'] as String? ?? '',
    productType: ReviewProductType.values.asNameMap()[data['productType']] ??
        ReviewProductType.menu,
    productName: data['productName'] as String? ?? '',
    orderId: data['orderId'] as String? ?? '',
    rating: (data['rating'] as num? ?? 0).toInt(),
    comment: data['comment'] as String? ?? '',
    createdAt: firestoreDateTime(data['createdAt']),
  );
}

Map<String, dynamic> productReviewsToFirestore(List<ProductReview> reviews) {
  return {'reviews': reviews.map(productReviewToFirestore).toList()};
}

Map<String, dynamic> productReviewToFirestore(ProductReview review) {
  return {
    'id': review.id,
    'productId': review.productId,
    'productType': review.productType.name,
    'productName': review.productName,
    'orderId': review.orderId,
    'rating': review.rating,
    'comment': review.comment,
    'createdAt': Timestamp.fromDate(review.createdAt),
  };
}

ProductStats productStatsFromFirestore(String id, Map<String, dynamic> data) {
  return ProductStats(
    productId: id,
    ratingSum: (data['ratingSum'] as num? ?? 0).toInt(),
    ratingCount: (data['ratingCount'] as num? ?? 0).toInt(),
    salesCount: (data['salesCount'] as num? ?? 0).toInt(),
  );
}
