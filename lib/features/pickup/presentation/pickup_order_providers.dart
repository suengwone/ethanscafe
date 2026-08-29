import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/app_review_providers.dart';
import '../../auth/presentation/auth_providers.dart';
import '../../coupon/domain/coupon_models.dart';
import '../../coupon/presentation/coupons_providers.dart';
import '../../payment/domain/payment_models.dart';
import '../../points/presentation/points_providers.dart';
import '../../review/presentation/review_providers.dart';
import '../../store/domain/store_models.dart';
import '../data/cloud_functions_pickup_checkout_repository.dart';
import '../data/local_pickup_checkout.dart';
import '../data/firestore_pickup_orders_repository.dart';
import '../data/local_pickup_orders_repository.dart';
import '../domain/pickup_cart_models.dart';
import '../domain/pickup_checkout.dart';
import '../domain/pickup_order_models.dart';
import '../domain/pickup_orders_repository.dart';

final pickupOrdersRepositoryProvider = Provider<PickupOrdersRepository>((ref) {
  try {
    if (Firebase.apps.isNotEmpty) {
      final user = ref.watch(authStateProvider).value;
      if (user != null) {
        return FirestorePickupOrdersRepository(uid: user.uid);
      }
    }
  } catch (_) {}
  return LocalPickupOrdersRepository();
});

final pickupCheckoutProvider = Provider<PickupCheckout>((ref) {
  try {
    if (Firebase.apps.isNotEmpty &&
        ref.watch(authStateProvider).value != null) {
      return CloudFunctionsPickupCheckoutRepository();
    }
  } catch (_) {}
  // 로컬 저장소는 SharedPreferences만 붙들고 있어 인스턴스를 새로 만들어도
  // pickupOrdersRepositoryProvider가 읽는 것과 같은 주문을 본다.
  return LocalPickupCheckout(
    orders: LocalPickupOrdersRepository(),
    coupons: ref.watch(couponsRepositoryProvider),
    points: ref.watch(pointsRepositoryProvider),
    reviews: ref.watch(reviewsRepositoryProvider),
    isMember: ref.watch(authStateProvider).value != null,
  );
});

final pickupOrderTrackingProvider = StreamProvider.autoDispose
    .family<PickupOrder?, String>((ref, orderId) {
      return ref.watch(pickupOrdersRepositoryProvider).watchOrders().map((
        orders,
      ) {
        for (final order in orders) {
          if (order.id == orderId) {
            return order;
          }
        }
        return null;
      });
    });

final pickupOrdersControllerProvider =
    AsyncNotifierProvider<PickupOrdersController, List<PickupOrder>>(
      PickupOrdersController.new,
    );

class PickupOrdersController extends AsyncNotifier<List<PickupOrder>> {

  @override
  Future<List<PickupOrder>> build() {
    return ref.watch(pickupOrdersRepositoryProvider).load();
  }

  Future<PickupOrder> placeOrder({
    required List<PickupCartItem> cartItems,
    required CafeStore store,
    int usedPoints = 0,
    List<Coupon> coupons = const [],
    PaymentApproval? payment,
  }) async {
    if (cartItems.isEmpty) {
      throw StateError('The cart is empty.');
    }

    final items = cartItems
        .map(
          (item) => PickupOrderItem(
            menuId: item.menuItem.id,
            menuName: item.menuItem.name,
            option: item.option,
            quantity: item.quantity,
            unitPrice: item.unitPrice,
          ),
        )
        .toList();
    final totalAmount = items.fold(0, (sum, item) => sum + item.totalPrice);

    final couponDiscount = validateCoupons(
      coupons: coupons,
      orderAmount: totalAmount,
      now: ref.read(couponNowProvider),
    );

    if (usedPoints < 0 || usedPoints > totalAmount - couponDiscount) {
      throw ArgumentError.value(
        usedPoints,
        'usedPoints',
        'The points used fall outside the order total.',
      );
    }

    final paidAmount = totalAmount - couponDiscount - usedPoints;
    if (payment != null && payment.amount != paidAmount) {
      throw StateError('The approved amount does not match the order total.');
    }

    final order = await ref.read(pickupCheckoutProvider).placeOrder(
          items: items,
          storeId: store.id,
          storeName: store.name,
          coupons: coupons,
          couponDiscount: couponDiscount,
          usedPoints: usedPoints,
          payment: payment,
        );

    if (coupons.isNotEmpty) {
      ref.invalidate(couponsControllerProvider);
    }
    ref.invalidate(pointsControllerProvider);
    ref.invalidate(productStatsProvider);
    state = AsyncValue.data([order, ...state.value ?? const []]);
    await ref.read(appReviewServiceProvider).onOrderPlaced();
    return order;
  }

  Future<PickupOrder> cancelOrder(String orderId) async {
    final cancelled =
        await ref.read(pickupCheckoutProvider).cancelOrder(orderId);
    ref.invalidate(couponsControllerProvider);
    ref.invalidate(pointsControllerProvider);
    state = AsyncValue.data([
      for (final order in state.value ?? const <PickupOrder>[])
        if (order.id == orderId) cancelled else order,
    ]);
    return cancelled;
  }
}
