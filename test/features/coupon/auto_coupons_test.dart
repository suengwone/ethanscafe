import 'package:flutter_test/flutter_test.dart';

import 'package:cafe_app/features/coupon/domain/auto_coupons.dart';

void main() {
  group('buildWelcomeCoupon', () {
    test('가입 사용자용 웰컴 쿠폰을 만든다', () {
      final coupon = buildWelcomeCoupon(
        uid: 'user-1',
        now: DateTime(2026, 8, 14, 10, 30),
      );

      expect(coupon.id, 'welcome-user-1');
      expect(coupon.discountAmount, 3000);
      expect(coupon.expiresAt, DateTime(2026, 9, 12, 23, 59));
      expect(coupon.isUsable(DateTime(2026, 8, 14, 10, 30)), isTrue);
    });
  });

  group('buildBirthdayCoupon', () {
    test('생일이 등록되지 않으면 발급하지 않는다', () {
      final coupon = buildBirthdayCoupon(
        uid: 'user-1',
        birthDate: null,
        now: DateTime(2026, 8, 14),
      );

      expect(coupon, isNull);
    });

    test('생일 당일에 발급한다', () {
      final coupon = buildBirthdayCoupon(
        uid: 'user-1',
        birthDate: DateTime(1994, 8, 14),
        now: DateTime(2026, 8, 14, 9),
      );

      expect(coupon, isNotNull);
      expect(coupon!.id, 'birthday-2026-user-1');
      expect(coupon.discountRate, 20);
      expect(coupon.expiresAt, DateTime(2026, 8, 20, 23, 59));
    });

    test('생일 주간(7일) 안에는 발급한다', () {
      final coupon = buildBirthdayCoupon(
        uid: 'user-1',
        birthDate: DateTime(1994, 8, 14),
        now: DateTime(2026, 8, 20, 23, 0),
      );

      expect(coupon, isNotNull);
      expect(coupon!.id, 'birthday-2026-user-1');
    });

    test('생일 전에는 발급하지 않는다', () {
      final coupon = buildBirthdayCoupon(
        uid: 'user-1',
        birthDate: DateTime(1994, 8, 14),
        now: DateTime(2026, 8, 13, 23, 59),
      );

      expect(coupon, isNull);
    });

    test('생일 주간이 지나면 발급하지 않는다', () {
      final coupon = buildBirthdayCoupon(
        uid: 'user-1',
        birthDate: DateTime(1994, 8, 14),
        now: DateTime(2026, 8, 21),
      );

      expect(coupon, isNull);
    });

    test('연말 생일은 해를 넘겨도 생일 주간이면 작년 id로 발급한다', () {
      final coupon = buildBirthdayCoupon(
        uid: 'user-1',
        birthDate: DateTime(1994, 12, 30),
        now: DateTime(2027, 1, 3),
      );

      expect(coupon, isNotNull);
      expect(coupon!.id, 'birthday-2026-user-1');
      expect(coupon.expiresAt, DateTime(2027, 1, 5, 23, 59));
    });

    test('2월 29일 생일은 평년에 2월 28일 기준으로 발급한다', () {
      final coupon = buildBirthdayCoupon(
        uid: 'user-1',
        birthDate: DateTime(1996, 2, 29),
        now: DateTime(2026, 2, 28),
      );

      expect(coupon, isNotNull);
      expect(coupon!.id, 'birthday-2026-user-1');
    });

    test('2월 29일 생일은 윤년에 2월 29일 기준으로 발급한다', () {
      final coupon = buildBirthdayCoupon(
        uid: 'user-1',
        birthDate: DateTime(1996, 2, 29),
        now: DateTime(2028, 2, 29),
      );

      expect(coupon, isNotNull);
      expect(coupon!.id, 'birthday-2028-user-1');
    });
  });
}
