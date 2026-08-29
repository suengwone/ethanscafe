import 'package:cloud_functions/cloud_functions.dart';

import '../../../core/firebase/firestore_converters.dart';
import '../../coupon/domain/coupon_models.dart';
import '../../payment/domain/payment_models.dart';
import '../domain/bean_checkout.dart';
import '../domain/order_models.dart';
import 'firestore_bean_orders_repository.dart';

class CloudFunctionsBeanCheckoutRepository implements BeanCheckout {
  CloudFunctionsBeanCheckoutRepository({FirebaseFunctions? functions})
    : _functions = functions ?? FirebaseFunctions.instanceFor(region: _region);

  static const _region = 'asia-northeast3';
  static const placeOrderCallableName = 'placeOrder';
  static const cancelOrderCallableName = 'cancelOrder';

  final FirebaseFunctions _functions;

  // couponDiscount는 넘기지 않는다. 서버가 쿠폰을 직접 다시 계산하므로
  // 클라이언트가 셈한 할인액은 믿지 않는다.
  @override
  Future<BeanOrder> placeOrder({
    required List<BeanOrderItem> items,
    List<Coupon> coupons = const [],
    int couponDiscount = 0,
    int usedPoints = 0,
    PaymentApproval? payment,
    BeanFulfillmentMethod fulfillmentMethod = BeanFulfillmentMethod.delivery,
    String? storeId,
    String? storeName,
    String? recipient,
    String? recipientPhone,
    String? shippingAddress,
  }) async {
    final result = await _functions
        .httpsCallable(placeOrderCallableName)
        .call<Object?>({
          'orderType': 'bean',
          'items': [
            for (final item in items)
              {
                'beanId': item.beanId,
                'beanName': item.beanName,
                'weight': item.weight.name,
                'grind': item.grind.name,
                'quantity': item.quantity,
                'unitPrice': item.unitPrice,
              },
          ],
          'usedPoints': usedPoints,
          'couponIds': [for (final coupon in coupons) coupon.id],
          if (payment != null)
            'payment': {
              'paymentKey': payment.paymentKey,
              'orderId': payment.orderId,
              'amount': payment.amount,
            },
          'fulfillmentMethod': fulfillmentMethod.name,
          'storeId': ?storeId,
          'storeName': ?storeName,
          'recipient': ?recipient,
          'recipientPhone': ?recipientPhone,
          'shippingAddress': ?shippingAddress,
        });
    return _orderFromResult(result.data);
  }

  @override
  Future<BeanOrder> cancelOrder(String orderId) async {
    final result = await _functions
        .httpsCallable(cancelOrderCallableName)
        .call<Object?>({'orderType': 'bean', 'orderId': orderId});
    return _orderFromResult(result.data);
  }

  BeanOrder _orderFromResult(Object? data) {
    final map = deepStringKeyedMap(data);
    return beanOrderFromFirestore(map['order'] as Map<String, dynamic>);
  }
}
