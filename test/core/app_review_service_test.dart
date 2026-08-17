import 'package:cafe_app/core/services/app_review_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('shouldRequestReview', () {
    test('주문 횟수가 기준에 못 미치면 요청하지 않는다', () {
      expect(
        shouldRequestReview(
          completedOrders: reviewPromptOrderCount - 1,
          alreadyRequested: false,
        ),
        isFalse,
      );
    });

    test('기준을 채우면 요청한다', () {
      expect(
        shouldRequestReview(
          completedOrders: reviewPromptOrderCount,
          alreadyRequested: false,
        ),
        isTrue,
      );
      expect(
        shouldRequestReview(
          completedOrders: reviewPromptOrderCount + 5,
          alreadyRequested: false,
        ),
        isTrue,
      );
    });

    test('이미 요청했으면 다시 묻지 않는다', () {
      expect(
        shouldRequestReview(
          completedOrders: reviewPromptOrderCount + 10,
          alreadyRequested: true,
        ),
        isFalse,
      );
    });
  });
}
