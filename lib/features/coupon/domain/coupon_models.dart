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
  }) = _Coupon;

  bool isExpired(DateTime now) => expiresAt.isBefore(now);

  bool isUsable(DateTime now) => !isUsed && !isExpired(now);
}
