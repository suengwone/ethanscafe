import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local_coupons_repository.dart';
import '../domain/coupon_models.dart';
import '../domain/coupons_repository.dart';

final couponsRepositoryProvider = Provider<CouponsRepository>((ref) {
  return LocalCouponsRepository();
});

final couponsProvider = FutureProvider<List<Coupon>>((ref) {
  return ref.watch(couponsRepositoryProvider).loadCoupons();
});

final couponNowProvider = Provider<DateTime>((ref) => DateTime.now());

final usableCouponCountProvider = FutureProvider<int>((ref) async {
  final coupons = await ref.watch(couponsProvider.future);
  final now = ref.watch(couponNowProvider);
  return coupons.where((coupon) => coupon.isUsable(now)).length;
});
