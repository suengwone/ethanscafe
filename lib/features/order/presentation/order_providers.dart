import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/app_review_providers.dart';
import '../../auth/presentation/auth_providers.dart';
import '../../beans/domain/bean_cart_models.dart';
import '../../coupon/domain/coupon_models.dart';
import '../../coupon/presentation/coupons_providers.dart';
import '../../payment/domain/payment_models.dart';
import '../../points/presentation/points_providers.dart';
import '../../profile/domain/delivery_address.dart';
import '../../review/presentation/review_providers.dart';
import '../../store/domain/store_models.dart';
import '../data/cloud_functions_bean_checkout_repository.dart';
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

final beanCloudCheckoutProvider =
    Provider<CloudFunctionsBeanCheckoutRepository?>((ref) {
  try {
    if (Firebase.apps.isNotEmpty &&
        ref.watch(authStateProvider).value != null) {
      return CloudFunctionsBeanCheckoutRepository();
    }
  } catch (_) {}
  return null;
});

final beanOrdersControllerProvider =
    AsyncNotifierProvider<BeanOrdersController, List<BeanOrder>>(
      BeanOrdersController.new,
    );

class BeanOrdersController extends AsyncNotifier<List<BeanOrder>> {

  @override
  Future<List<BeanOrder>> build() {
    return ref.watch(beanOrdersRepositoryProvider).load();
  }

  Future<BeanOrder> placeOrder({
    required List<BeanCartItem> cartItems,
    int usedPoints = 0,
    List<Coupon> coupons = const [],
    PaymentApproval? payment,
    BeanFulfillmentMethod fulfillmentMethod = BeanFulfillmentMethod.delivery,
    DeliveryAddress? deliveryAddress,
    CafeStore? pickupStore,
  }) async {
    if (cartItems.isEmpty) {
      throw StateError('장바구니가 비어 있습니다.');
    }
    if (fulfillmentMethod == BeanFulfillmentMethod.pickup &&
        pickupStore == null) {
      throw StateError('픽업 매장이 선택되지 않았습니다.');
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

    final cloudCheckout = ref.read(beanCloudCheckoutProvider);
    if (cloudCheckout != null) {
      final order = await cloudCheckout.placeOrder(
        items: items,
        usedPoints: usedPoints,
        couponIds: [for (final coupon in coupons) coupon.id],
        payment: payment,
        fulfillmentMethod: fulfillmentMethod,
        storeId: fulfillmentMethod == BeanFulfillmentMethod.pickup
            ? pickupStore?.id
            : null,
        storeName: fulfillmentMethod == BeanFulfillmentMethod.pickup
            ? pickupStore?.name
            : null,
        recipient: fulfillmentMethod == BeanFulfillmentMethod.delivery
            ? deliveryAddress?.recipient
            : null,
        recipientPhone: fulfillmentMethod == BeanFulfillmentMethod.delivery
            ? deliveryAddress?.phone
            : null,
        shippingAddress: fulfillmentMethod == BeanFulfillmentMethod.delivery
            ? _fullAddress(deliveryAddress)
            : null,
      );
      if (coupons.isNotEmpty) {
        ref.invalidate(couponsControllerProvider);
      }
      ref.invalidate(pointsControllerProvider);
      state = AsyncValue.data([order, ...state.value ?? const []]);
      await _afterOrderPlaced(items, recordSales: false);
      return order;
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
        description: beanOrderPointsUseDescription,
      );
    }

    final isMember = ref.read(authStateProvider).value != null;
    var earnedPoints = 0;
    if (paidAmount > 0 && isMember) {
      final pointsData = await pointsRepository.recordPayment(
        paymentAmount: paidAmount,
        description: beanOrderPaymentDescription,
      );
      final entry =
          pointsData.history.isEmpty ? null : pointsData.history.first;
      earnedPoints = entry != null && entry.isEarn ? entry.amount : 0;
    }
    ref.invalidate(pointsControllerProvider);

    final order = await ref.read(beanOrdersRepositoryProvider).placeOrder(
          items: items,
          usedPoints: usedPoints,
          earnedPoints: earnedPoints,
          couponId: couponIdsLabel(coupons),
          couponTitle: couponTitlesLabel(coupons),
          couponDiscount: couponDiscount,
          paymentKey: payment?.paymentKey,
          paymentMethod: payment?.method,
          fulfillmentMethod: fulfillmentMethod,
          storeId: fulfillmentMethod == BeanFulfillmentMethod.pickup
              ? pickupStore?.id
              : null,
          storeName: fulfillmentMethod == BeanFulfillmentMethod.pickup
              ? pickupStore?.name
              : null,
          recipient: fulfillmentMethod == BeanFulfillmentMethod.delivery
              ? deliveryAddress?.recipient
              : null,
          recipientPhone: fulfillmentMethod == BeanFulfillmentMethod.delivery
              ? deliveryAddress?.phone
              : null,
          shippingAddress: fulfillmentMethod == BeanFulfillmentMethod.delivery
              ? _fullAddress(deliveryAddress)
              : null,
        );
    state = AsyncValue.data([order, ...state.value ?? const []]);
    await _afterOrderPlaced(items, recordSales: true);
    return order;
  }

  Future<void> _afterOrderPlaced(
    List<BeanOrderItem> items, {
    required bool recordSales,
  }) async {
    // 서버 주문은 판매량을 주문 트랜잭션에서 집계하므로 클라이언트는 건너뛴다.
    if (recordSales) {
      await _recordSales(items);
    } else {
      ref.invalidate(productStatsProvider);
    }
    await ref.read(appReviewServiceProvider).onOrderPlaced();
  }

  Future<void> _recordSales(List<BeanOrderItem> items) async {
    final salesByBean = <String, int>{};
    for (final item in items) {
      salesByBean[item.beanId] = (salesByBean[item.beanId] ?? 0) + item.quantity;
    }
    await ref.read(reviewsRepositoryProvider).recordSales(salesByBean);
    ref.invalidate(productStatsProvider);
  }

  Future<BeanOrder> cancelOrder(String orderId) async {
    final cloudCheckout = ref.read(beanCloudCheckoutProvider);
    if (cloudCheckout != null) {
      final cancelled = await cloudCheckout.cancelOrder(orderId);
      ref.invalidate(couponsControllerProvider);
      ref.invalidate(pointsControllerProvider);
      state = AsyncValue.data([
        for (final order in state.value ?? const <BeanOrder>[])
          if (order.id == orderId) cancelled else order,
      ]);
      return cancelled;
    }

    final cancelled =
        await ref.read(beanOrdersRepositoryProvider).cancelOrder(orderId);

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
        description: beanOrderCancelDescription,
      );
      ref.invalidate(pointsControllerProvider);
    }

    state = AsyncValue.data([
      for (final order in state.value ?? const <BeanOrder>[])
        if (order.id == orderId) cancelled else order,
    ]);
    return cancelled;
  }

  String? _fullAddress(DeliveryAddress? address) {
    if (address == null) {
      return null;
    }
    return address.address2.isEmpty
        ? address.address1
        : '${address.address1} ${address.address2}';
  }
}
