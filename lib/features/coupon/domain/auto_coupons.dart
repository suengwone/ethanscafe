import 'coupon_models.dart';

const welcomeCouponValidDays = 30;
const birthdayCouponValidDays = 7;

String welcomeCouponId(String uid) => 'welcome-$uid';

String birthdayCouponId(String uid, int year) => 'birthday-$year-$uid';

Coupon buildWelcomeCoupon({required String uid, required DateTime now}) {
  final expiresAt = DateTime(
    now.year,
    now.month,
    now.day + welcomeCouponValidDays - 1,
    23,
    59,
  );
  return Coupon(
    id: welcomeCouponId(uid),
    title: '웰컴 3,000원 할인',
    description: '가입을 환영합니다! 첫 주문에 쓸 수 있는 3,000원 할인 쿠폰',
    expiresAt: expiresAt,
    discountAmount: 3000,
  );
}

DateTime birthdayInYear(DateTime birthDate, int year) {
  if (birthDate.month == 2 && birthDate.day == 29) {
    final isLeapYear = DateTime(year, 2, 29).month == 2;
    if (!isLeapYear) {
      return DateTime(year, 2, 28);
    }
  }
  return DateTime(year, birthDate.month, birthDate.day);
}

Coupon? buildBirthdayCoupon({
  required String uid,
  required DateTime? birthDate,
  required DateTime now,
}) {
  if (birthDate == null) {
    return null;
  }
  for (final year in [now.year, now.year - 1]) {
    final start = birthdayInYear(birthDate, year);
    final expiresAt = DateTime(
      start.year,
      start.month,
      start.day + birthdayCouponValidDays - 1,
      23,
      59,
    );
    if (!now.isBefore(start) && !now.isAfter(expiresAt)) {
      return Coupon(
        id: birthdayCouponId(uid, start.year),
        title: '생일 축하 20% 할인',
        description: '생일 축하드려요! 생일 주간에 쓸 수 있는 20% 할인 쿠폰',
        expiresAt: expiresAt,
        discountRate: 20,
      );
    }
  }
  return null;
}
