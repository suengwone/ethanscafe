import 'coupon_models.dart';

abstract class CouponsRepository {
  Future<List<Coupon>> loadCoupons();

  Future<bool> issueCoupon(Coupon coupon);

  Future<void> markUsed(String couponId);

  Future<void> markUnused(String couponId);
}
