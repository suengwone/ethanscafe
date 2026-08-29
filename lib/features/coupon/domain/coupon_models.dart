import 'package:freezed_annotation/freezed_annotation.dart';

part 'coupon_models.freezed.dart';

@freezed
abstract class Coupon with _$Coupon {
  const Coupon._();

  const factory Coupon({
    required String id,
    required String title,
    required String description,
    required DateTime expiresAt,
    @Default(false) bool isUsed,
    @Default(0) int discountAmount,
    @Default(0) int discountRate,
    @Default(0) int minOrderAmount,
    @Default(false) bool isStackable,
  }) = _Coupon;

  bool isExpired(DateTime now) => expiresAt.isBefore(now);

  bool isUsable(DateTime now) => !isUsed && !isExpired(now);

  bool get isOrderDiscount => discountAmount > 0 || discountRate > 0;

  bool canApplyTo({required int orderAmount, required DateTime now}) =>
      isUsable(now) && isOrderDiscount && orderAmount >= minOrderAmount;

  int discountFor(int orderAmount) {
    if (!isOrderDiscount || orderAmount < minOrderAmount) {
      return 0;
    }
    final discount =
        discountAmount > 0 ? discountAmount : orderAmount * discountRate ~/ 100;
    return discount.clamp(0, orderAmount);
  }
}

int totalCouponDiscount(List<Coupon> coupons, int orderAmount) {
  final discount =
      coupons.fold(0, (sum, coupon) => sum + coupon.discountFor(orderAmount));
  return discount.clamp(0, orderAmount);
}

int validateCoupons({
  required List<Coupon> coupons,
  required int orderAmount,
  required DateTime now,
}) {
  if (coupons.isEmpty) {
    return 0;
  }
  final ids = coupons.map((coupon) => coupon.id).toSet();
  if (ids.length != coupons.length) {
    throw StateError('A coupon can only be applied once.');
  }
  final regularCount = coupons.where((coupon) => !coupon.isStackable).length;
  if (regularCount > 1) {
    throw StateError('Only one non-stacking coupon can be applied.');
  }
  for (final coupon in coupons) {
    if (!coupon.canApplyTo(orderAmount: orderAmount, now: now)) {
      throw StateError('That coupon does not apply here.');
    }
  }
  return totalCouponDiscount(coupons, orderAmount);
}

String? couponIdsLabel(List<Coupon> coupons) =>
    coupons.isEmpty ? null : coupons.map((coupon) => coupon.id).join(',');

String? couponTitlesLabel(List<Coupon> coupons) =>
    coupons.isEmpty ? null : coupons.map((coupon) => coupon.title).join(' + ');
