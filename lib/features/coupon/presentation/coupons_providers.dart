import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/firestore_coupons_repository.dart';
import '../data/local_coupons_repository.dart';
import '../domain/coupon_models.dart';
import '../domain/coupons_repository.dart';

final couponsRepositoryProvider = Provider<CouponsRepository>((ref) {
  try {
    if (Firebase.apps.isNotEmpty) {
      return FirestoreCouponsRepository();
    }
  } catch (_) {}
  return LocalCouponsRepository();
});

final couponsControllerProvider =
    AsyncNotifierProvider<CouponsController, List<Coupon>>(
      CouponsController.new,
    );

class CouponsController extends AsyncNotifier<List<Coupon>> {
  @override
  Future<List<Coupon>> build() {
    return ref.watch(couponsRepositoryProvider).loadCoupons();
  }

  Future<void> useCoupon(String couponId) async {
    await ref.read(couponsRepositoryProvider).markUsed(couponId);
    final coupons = state.value ?? const <Coupon>[];
    state = AsyncValue.data([
      for (final coupon in coupons)
        if (coupon.id == couponId) coupon.copyWith(isUsed: true) else coupon,
    ]);
  }
}

final couponNowProvider = Provider<DateTime>((ref) => DateTime.now());

final usableCouponCountProvider = FutureProvider<int>((ref) async {
  final coupons = await ref.watch(couponsControllerProvider.future);
  final now = ref.watch(couponNowProvider);
  return coupons.where((coupon) => coupon.isUsable(now)).length;
});
