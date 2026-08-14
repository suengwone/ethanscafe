import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/presentation/auth_providers.dart';
import '../../coupon/domain/coupon_models.dart';
import '../../coupon/presentation/coupons_providers.dart';
import '../../payment/domain/payment_models.dart';
import '../../points/presentation/points_providers.dart';
import '../../review/presentation/review_providers.dart';
import '../../store/domain/store_models.dart';
import '../data/firestore_pickup_orders_repository.dart';
import '../data/local_pickup_orders_repository.dart';
import '../domain/pickup_cart_models.dart';
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
  static const _earnRate = 0.1;

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
      throw StateError('장바구니가 비어 있습니다.');
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
        '사용 포인트가 결제 금액을 벗어났습니다.',
      );
    }

    final paidAmount = totalAmount - couponDiscount - usedPoints;
    if (payment != null && payment.amount != paidAmount) {
      throw StateError('결제 승인 금액이 주문 금액과 일치하지 않습니다.');
    }

    if (coupons.isNotEmpty) {
      final couponsRepository = ref.read(couponsRepositoryProvider);
      for (final coupon in coupons) {
        await couponsRepository.markUsed(coupon.id);
      }
      ref.invalidate(couponsControllerProvider);
    }

    final pointsRepository = ref.read(pointsRepositoryProvider);
    if (usedPoints > 0) {
      await pointsRepository.usePoints(
        amount: usedPoints,
        description: pickupOrderPointsUseDescription,
      );
    }

    var earnedPoints = 0;
    if (paidAmount > 0) {
      await pointsRepository.recordPayment(
        paymentAmount: paidAmount,
        description: pickupOrderPaymentDescription,
      );
      earnedPoints = (paidAmount * _earnRate).floor();
    }
    ref.invalidate(pointsControllerProvider);

    final order = await ref
        .read(pickupOrdersRepositoryProvider)
        .placeOrder(
          items: items,
          storeId: store.id,
          storeName: store.name,
          usedPoints: usedPoints,
          earnedPoints: earnedPoints,
          couponId: couponIdsLabel(coupons),
          couponTitle: couponTitlesLabel(coupons),
          couponDiscount: couponDiscount,
          paymentKey: payment?.paymentKey,
          paymentMethod: payment?.method,
        );
    state = AsyncValue.data([order, ...state.value ?? const []]);

    final salesByMenu = <String, int>{};
    for (final item in items) {
      salesByMenu[item.menuId] =
          (salesByMenu[item.menuId] ?? 0) + item.quantity;
    }
    await ref.read(reviewsRepositoryProvider).recordSales(salesByMenu);
    ref.invalidate(productStatsProvider);

    return order;
  }

  Future<PickupOrder> cancelOrder(String orderId) async {
    final cancelled = await ref
        .read(pickupOrdersRepositoryProvider)
        .cancelOrder(orderId);

    final couponId = cancelled.couponId;
    if (couponId != null && couponId.isNotEmpty) {
      final couponsRepository = ref.read(couponsRepositoryProvider);
      for (final id in couponId.split(',')) {
        await couponsRepository.markUnused(id);
      }
      ref.invalidate(couponsControllerProvider);
    }

    if (cancelled.usedPoints > 0 || cancelled.earnedPoints > 0) {
      await ref.read(pointsRepositoryProvider).refundOrderPoints(
        usedPoints: cancelled.usedPoints,
        earnedPoints: cancelled.earnedPoints,
        description: pickupOrderCancelDescription,
      );
      ref.invalidate(pointsControllerProvider);
    }

    state = AsyncValue.data([
      for (final order in state.value ?? const <PickupOrder>[])
        if (order.id == orderId) cancelled else order,
    ]);
    return cancelled;
  }
}
