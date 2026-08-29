import 'package:cloud_functions/cloud_functions.dart';

import '../../../core/firebase/firestore_converters.dart';
import '../../coupon/domain/coupon_models.dart';
import '../../payment/domain/payment_models.dart';
import '../domain/pickup_checkout.dart';
import '../domain/pickup_order_models.dart';
import 'firestore_pickup_orders_repository.dart';

class CloudFunctionsPickupCheckoutRepository implements PickupCheckout {
  CloudFunctionsPickupCheckoutRepository({FirebaseFunctions? functions})
    : _functions = functions ?? FirebaseFunctions.instanceFor(region: _region);

  static const _region = 'asia-northeast3';
  static const placeOrderCallableName = 'placeOrder';
  static const cancelOrderCallableName = 'cancelOrder';

  final FirebaseFunctions _functions;

  // couponDiscount는 넘기지 않는다. 서버가 쿠폰을 직접 다시 계산하므로
  // 클라이언트가 셈한 할인액은 믿지 않는다.
  @override
  Future<PickupOrder> placeOrder({
    required List<PickupOrderItem> items,
    required String storeId,
    required String storeName,
    List<Coupon> coupons = const [],
    int couponDiscount = 0,
    int usedPoints = 0,
    PaymentApproval? payment,
  }) async {
    final result = await _functions.httpsCallable(placeOrderCallableName).call({
      'orderType': 'pickup',
      'items': [
        for (final item in items)
          {
            'menuId': item.menuId,
            'menuName': item.menuName,
            if (item.option != null) 'option': item.option,
            'quantity': item.quantity,
            'unitPrice': item.unitPrice,
          },
      ],
      'storeId': storeId,
      'storeName': storeName,
      'usedPoints': usedPoints,
      'couponIds': [for (final coupon in coupons) coupon.id],
      if (payment != null)
        'payment': {
          'paymentKey': payment.paymentKey,
          'orderId': payment.orderId,
          'amount': payment.amount,
        },
    });
    return _orderFromResult(result.data);
  }

  @override
  Future<PickupOrder> cancelOrder(String orderId) async {
    final result = await _functions.httpsCallable(cancelOrderCallableName).call(
      {'orderType': 'pickup', 'orderId': orderId},
    );
    return _orderFromResult(result.data);
  }

  PickupOrder _orderFromResult(Object? data) {
    final map = deepStringKeyedMap(data);
    return pickupOrderFromFirestore(map['order'] as Map<String, dynamic>);
  }
}
