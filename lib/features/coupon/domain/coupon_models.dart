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
