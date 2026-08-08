import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/presentation/auth_providers.dart';
import '../../beans/domain/bean_cart_models.dart';
import '../../coupon/domain/coupon_models.dart';
import '../../coupon/presentation/coupons_providers.dart';
import '../../payment/domain/payment_models.dart';
import '../../points/presentation/points_providers.dart';
import '../data/firestore_bean_orders_repository.dart';
import '../data/local_bean_orders_repository.dart';
import '../domain/bean_orders_repository.dart';
import '../domain/order_models.dart';

final beanOrdersRepositoryProvider = Provider<BeanOrdersRepository>((ref) {
  try {
    if (Firebase.apps.isNotEmpty) {
      final user = ref.watch(authStateProvider).value;
      if (user != null) {
        return FirestoreBeanOrdersRepository(uid: user.uid);
      }
    }
  } catch (_) {}
  return LocalBeanOrdersRepository();
});

final beanOrdersControllerProvider =
    AsyncNotifierProvider<BeanOrdersController, List<BeanOrder>>(
      BeanOrdersController.new,
    );

class BeanOrdersController extends AsyncNotifier<List<BeanOrder>> {
  static const _earnRate = 0.1;

  @override
  Future<List<BeanOrder>> build() {
    return ref.watch(beanOrdersRepositoryProvider).load();
  }

  Future<BeanOrder> placeOrder({
    required List<BeanCartItem> cartItems,
    int usedPoints = 0,
    Coupon? coupon,
    PaymentApproval? payment,
  }) async {
    if (cartItems.isEmpty) {
      throw StateError('장바구니가 비어 있습니다.');
    }

    final items = cartItems
        .map(
          (item) => BeanOrderItem(
            beanId: item.bean.id,
            beanName: item.bean.name,
            weight: item.weight,
            grind: item.grind,
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
        description: beanOrderPointsUseDescription,
      );
    }

    var earnedPoints = 0;
    if (paidAmount > 0) {
      await pointsRepository.recordPayment(
        paymentAmount: paidAmount,
        description: beanOrderPaymentDescription,
      );
      earnedPoints = (paidAmount * _earnRate).floor();
    }
    ref.invalidate(pointsControllerProvider);

    final order = await ref.read(beanOrdersRepositoryProvider).placeOrder(
          items: items,
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
