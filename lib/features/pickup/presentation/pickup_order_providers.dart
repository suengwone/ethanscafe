import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/presentation/auth_providers.dart';
import '../../coupon/domain/coupon_models.dart';
import '../../coupon/presentation/coupons_providers.dart';
import '../../payment/domain/payment_models.dart';
import '../../points/presentation/points_providers.dart';
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
    Coupon? coupon,
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

    var couponDiscount = 0;
    if (coupon != null) {
      final now = ref.read(couponNowProvider);
      if (!coupon.canApplyTo(orderAmount: totalAmount, now: now)) {
        throw StateError('적용할 수 없는 쿠폰입니다.');
      }
      couponDiscount = coupon.discountFor(totalAmount);
    }

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

    if (coupon != null) {
      await ref.read(couponsRepositoryProvider).markUsed(coupon.id);
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

    final order = await ref.read(pickupOrdersRepositoryProvider).placeOrder(
          items: items,
          storeId: store.id,
          storeName: store.name,
          usedPoints: usedPoints,
          earnedPoints: earnedPoints,
          couponId: coupon?.id,
          couponTitle: coupon?.title,
          couponDiscount: couponDiscount,
          paymentKey: payment?.paymentKey,
          paymentMethod: payment?.method,
        );
    state = AsyncValue.data([order, ...state.value ?? const []]);
    return order;
  }
}
