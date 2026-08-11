import 'package:flutter_test/flutter_test.dart';

import 'package:cafe_app/features/coupon/domain/coupon_models.dart';

void main() {
  final now = DateTime(2026, 8, 3);

  Coupon coupon({
    String id = 'test-coupon',
    bool isUsed = false,
    int discountAmount = 0,
    int discountRate = 0,
    int minOrderAmount = 0,
    bool isStackable = false,
  }) {
    return Coupon(
      id: id,
      title: '테스트 쿠폰 $id',
      description: '테스트 설명',
      expiresAt: DateTime(2026, 12, 31),
      isUsed: isUsed,
      discountAmount: discountAmount,
      discountRate: discountRate,
      minOrderAmount: minOrderAmount,
      isStackable: isStackable,
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

  group('validateCoupons', () {
    test('빈 목록은 할인 0원이다', () {
      expect(
        validateCoupons(coupons: const [], orderAmount: 30000, now: now),
        0,
      );
    });

    test('일반 쿠폰은 1장만 적용할 수 있다', () {
      expect(
        () => validateCoupons(
          coupons: [
            coupon(id: 'a', discountAmount: 3000),
            coupon(id: 'b', discountRate: 10),
          ],
          orderAmount: 30000,
          now: now,
        ),
        throwsStateError,
      );
    });

    test('중복 사용 쿠폰은 일반 쿠폰과 함께 적용된다', () {
      final discount = validateCoupons(
        coupons: [
          coupon(id: 'a', discountAmount: 3000),
          coupon(id: 'b', discountAmount: 1000, isStackable: true),
          coupon(id: 'c', discountAmount: 500, isStackable: true),
        ],
        orderAmount: 30000,
        now: now,
      );

      expect(discount, 4500);
    });

    test('같은 쿠폰은 한 번만 적용할 수 있다', () {
      final target = coupon(id: 'a', discountAmount: 1000, isStackable: true);

      expect(
        () => validateCoupons(
          coupons: [target, target],
          orderAmount: 30000,
          now: now,
        ),
        throwsStateError,
      );
    });

    test('적용 불가 쿠폰이 있으면 거부된다', () {
      expect(
        () => validateCoupons(
          coupons: [coupon(id: 'a', discountAmount: 3000, isUsed: true)],
          orderAmount: 30000,
          now: now,
        ),
        throwsStateError,
      );
    });
  });

  group('totalCouponDiscount', () {
    test('할인 합산은 주문 금액을 초과하지 않는다', () {
      final discount = totalCouponDiscount(
        [
          coupon(id: 'a', discountAmount: 3000),
          coupon(id: 'b', discountAmount: 2000, isStackable: true),
        ],
        4000,
      );

      expect(discount, 4000);
    });
  });

  group('couponIdsLabel / couponTitlesLabel', () {
    test('빈 목록은 null을 반환한다', () {
      expect(couponIdsLabel(const []), isNull);
      expect(couponTitlesLabel(const []), isNull);
    });

    test('여러 장은 구분자로 이어 붙인다', () {
      final coupons = [coupon(id: 'a'), coupon(id: 'b', isStackable: true)];

      expect(couponIdsLabel(coupons), 'a,b');
      expect(couponTitlesLabel(coupons), '테스트 쿠폰 a + 테스트 쿠폰 b');
    });
  });
}
