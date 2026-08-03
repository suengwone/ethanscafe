import 'coupon_models.dart';

abstract class CouponsRepository {
  Future<List<Coupon>> loadCoupons();
}
