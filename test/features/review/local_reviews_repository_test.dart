import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cafe_app/features/review/data/local_reviews_repository.dart';
import 'package:cafe_app/features/review/domain/review_models.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('리뷰를 저장하면 목록과 별점 통계에 반영된다', () async {
    final repository = LocalReviewsRepository();

    final review = await repository.addReview(
      productId: 'espresso-cafe-latte',
      productType: ReviewProductType.menu,
      productName: '카페 라떼',
      orderId: 'order-1',
      rating: 5,
      comment: '고소하고 부드러워요',
    );

    expect(review.productId, 'espresso-cafe-latte');

    final reviews = await repository.loadMyReviews();
    expect(reviews, hasLength(1));
    expect(reviews.first.rating, 5);
    expect(reviews.first.comment, '고소하고 부드러워요');

    final stats = await repository.loadStats();
    expect(stats['espresso-cafe-latte']?.ratingSum, 5);
    expect(stats['espresso-cafe-latte']?.ratingCount, 1);
  });

  test('같은 주문의 같은 상품에 중복 리뷰를 남길 수 없다', () async {
    final repository = LocalReviewsRepository();

    await repository.addReview(
      productId: 'espresso-cafe-latte',
      productType: ReviewProductType.menu,
      productName: '카페 라떼',
      orderId: 'order-1',
      rating: 5,
    );

    expect(
      () => repository.addReview(
        productId: 'espresso-cafe-latte',
        productType: ReviewProductType.menu,
        productName: '카페 라떼',
        orderId: 'order-1',
        rating: 3,
      ),
      throwsStateError,
    );
  });

  test('다른 주문이면 같은 상품에도 리뷰를 남길 수 있다', () async {
    final repository = LocalReviewsRepository();

    await repository.addReview(
      productId: 'espresso-cafe-latte',
      productType: ReviewProductType.menu,
      productName: '카페 라떼',
      orderId: 'order-1',
      rating: 5,
    );
    await repository.addReview(
      productId: 'espresso-cafe-latte',
      productType: ReviewProductType.menu,
      productName: '카페 라떼',
      orderId: 'order-2',
      rating: 4,
    );

    final stats = await repository.loadStats();
    expect(stats['espresso-cafe-latte']?.ratingSum, 9);
    expect(stats['espresso-cafe-latte']?.ratingCount, 2);
  });

  test('범위를 벗어난 별점은 저장할 수 없다', () async {
    final repository = LocalReviewsRepository();

    expect(
      () => repository.addReview(
        productId: 'espresso-cafe-latte',
        productType: ReviewProductType.menu,
        productName: '카페 라떼',
        orderId: 'order-1',
        rating: 0,
      ),
      throwsArgumentError,
    );
  });

  test('상품별 리뷰를 최신순으로 조회한다', () async {
    final repository = LocalReviewsRepository();

    await repository.addReview(
      productId: 'espresso-cafe-latte',
      productType: ReviewProductType.menu,
      productName: '카페 라떼',
      orderId: 'order-1',
      rating: 5,
      comment: '첫 번째 리뷰',
    );
    await repository.addReview(
      productId: 'espresso-americano',
      productType: ReviewProductType.menu,
      productName: '아메리카노',
      orderId: 'order-1',
      rating: 4,
    );
    await repository.addReview(
      productId: 'espresso-cafe-latte',
      productType: ReviewProductType.menu,
      productName: '카페 라떼',
      orderId: 'order-2',
      rating: 3,
      comment: '두 번째 리뷰',
    );

    final reviews =
        await repository.loadProductReviews('espresso-cafe-latte');
    expect(reviews, hasLength(2));
    expect(reviews.first.comment, '두 번째 리뷰');
    expect(reviews.last.comment, '첫 번째 리뷰');
    expect(
      reviews.every((review) => review.productId == 'espresso-cafe-latte'),
      isTrue,
    );
  });

  test('리뷰가 없는 상품은 빈 목록을 반환한다', () async {
    final repository = LocalReviewsRepository();

    expect(await repository.loadProductReviews('unknown'), isEmpty);
  });

  test('판매량을 누적 기록한다', () async {
    final repository = LocalReviewsRepository();

    await repository.recordSales({'espresso-americano': 2, 'tea-chamomile': 1});
    await repository.recordSales({'espresso-americano': 3});

    final stats = await repository.loadStats();
    expect(stats['espresso-americano']?.salesCount, 5);
    expect(stats['tea-chamomile']?.salesCount, 1);
  });

  test('판매량과 별점 통계가 함께 유지된다', () async {
    final repository = LocalReviewsRepository();

    await repository.recordSales({'espresso-cafe-latte': 2});
    await repository.addReview(
      productId: 'espresso-cafe-latte',
      productType: ReviewProductType.menu,
      productName: '카페 라떼',
      orderId: 'order-1',
      rating: 4,
    );

    final stats = await repository.loadStats();
    expect(stats['espresso-cafe-latte']?.salesCount, 2);
    expect(stats['espresso-cafe-latte']?.ratingSum, 4);
    expect(stats['espresso-cafe-latte']?.ratingCount, 1);
  });
}
