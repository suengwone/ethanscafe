import 'package:flutter_test/flutter_test.dart';

import 'package:cafe_app/features/coupon/domain/coupon_models.dart';

void main() {
  final now = DateTime(2026, 8, 3);

  Coupon coupon({
    bool isUsed = false,
    int discountAmount = 0,
    int discountRate = 0,
    int minOrderAmount = 0,
  }) {
    return Coupon(
      id: 'test-coupon',
      title: '테스트 쿠폰',
      description: '테스트 설명',
      expiresAt: DateTime(2026, 12, 31),
      isUsed: isUsed,
      discountAmount: discountAmount,
      discountRate: discountRate,
      minOrderAmount: minOrderAmount,
    );
  }

  group('isOrderDiscount', () {
    test('할인 정보가 없으면 주문 적용 쿠폰이 아니다', () {
      expect(coupon().isOrderDiscount, isFalse);
    });

    test('정액 또는 정률 할인이 있으면 주문 적용 쿠폰이다', () {
      expect(coupon(discountAmount: 3000).isOrderDiscount, isTrue);
      expect(coupon(discountRate: 10).isOrderDiscount, isTrue);
    });
  });

  group('canApplyTo', () {
    test('최소 주문 금액 미만이면 적용할 수 없다', () {
      final target = coupon(discountAmount: 3000, minOrderAmount: 20000);

      expect(target.canApplyTo(orderAmount: 19999, now: now), isFalse);
      expect(target.canApplyTo(orderAmount: 20000, now: now), isTrue);
    });

    test('사용됐거나 만료된 쿠폰은 적용할 수 없다', () {
      expect(
        coupon(discountAmount: 3000, isUsed: true)
            .canApplyTo(orderAmount: 30000, now: now),
        isFalse,
      );
      expect(
        coupon(discountAmount: 3000)
            .canApplyTo(orderAmount: 30000, now: DateTime(2027, 1, 1)),
        isFalse,
      );
    });

    test('매장 전용 쿠폰은 주문에 적용할 수 없다', () {
      expect(coupon().canApplyTo(orderAmount: 30000, now: now), isFalse);
    });
  });

  group('discountFor', () {
    test('정액 할인은 주문 금액을 초과하지 않는다', () {
      expect(coupon(discountAmount: 3000).discountFor(30000), 3000);
      expect(coupon(discountAmount: 3000).discountFor(2000), 2000);
    });

    test('정률 할인은 원 단위 내림으로 계산한다', () {
      expect(coupon(discountRate: 10).discountFor(15990), 1599);
      expect(coupon(discountRate: 10).discountFor(15995), 1599);
    });

    test('최소 주문 금액 미만이거나 할인 정보가 없으면 0원이다', () {
      expect(
        coupon(discountAmount: 3000, minOrderAmount: 20000).discountFor(10000),
        0,
      );
      expect(coupon().discountFor(30000), 0);
    });
  });
}
