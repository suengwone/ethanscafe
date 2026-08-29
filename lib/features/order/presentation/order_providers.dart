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
import '../data/local_bean_checkout.dart';
import '../data/firestore_bean_orders_repository.dart';
import '../data/local_bean_orders_repository.dart';
import '../domain/bean_checkout.dart';
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

final beanCheckoutProvider = Provider<BeanCheckout>((ref) {
  try {
    if (Firebase.apps.isNotEmpty &&
        ref.watch(authStateProvider).value != null) {
      return CloudFunctionsBeanCheckoutRepository();
    }
  } catch (_) {}
  // 로컬 저장소는 SharedPreferences만 붙들고 있어 인스턴스를 새로 만들어도
  // beanOrdersRepositoryProvider가 읽는 것과 같은 주문을 본다.
  return LocalBeanCheckout(
    orders: LocalBeanOrdersRepository(),
    coupons: ref.watch(couponsRepositoryProvider),
    points: ref.watch(pointsRepositoryProvider),
    reviews: ref.watch(reviewsRepositoryProvider),
    isMember: ref.watch(authStateProvider).value != null,
  );
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
      throw StateError('The cart is empty.');
    }
    if (fulfillmentMethod == BeanFulfillmentMethod.pickup &&
        pickupStore == null) {
      throw StateError('No pickup store was chosen.');
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
        'The points used fall outside the order total.',
      );
    }

    final paidAmount = totalAmount - couponDiscount - usedPoints;
    if (payment != null && payment.amount != paidAmount) {
      throw StateError('The approved amount does not match the order total.');
    }

    final order = await ref.read(beanCheckoutProvider).placeOrder(
          items: items,
          coupons: coupons,
          couponDiscount: couponDiscount,
          usedPoints: usedPoints,
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
    ref.invalidate(productStatsProvider);
    state = AsyncValue.data([order, ...state.value ?? const []]);
    await ref.read(appReviewServiceProvider).onOrderPlaced();
    return order;
  }

  Future<BeanOrder> cancelOrder(String orderId) async {
    final cancelled = await ref.read(beanCheckoutProvider).cancelOrder(orderId);
    ref.invalidate(couponsControllerProvider);
    ref.invalidate(pointsControllerProvider);
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
