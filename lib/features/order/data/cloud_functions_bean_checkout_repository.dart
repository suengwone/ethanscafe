import 'package:cloud_functions/cloud_functions.dart';

import '../../../core/firebase/firestore_converters.dart';
import '../../payment/domain/payment_models.dart';
import '../domain/order_models.dart';
import 'firestore_bean_orders_repository.dart';

class CloudFunctionsBeanCheckoutRepository {
  CloudFunctionsBeanCheckoutRepository({FirebaseFunctions? functions})
      : _functions =
            functions ?? FirebaseFunctions.instanceFor(region: _region);

  static const _region = 'asia-northeast3';
  static const placeOrderCallableName = 'placeOrder';
  static const cancelOrderCallableName = 'cancelOrder';

  final FirebaseFunctions _functions;

  Future<BeanOrder> placeOrder({
    required List<BeanOrderItem> items,
    int usedPoints = 0,
    List<String> couponIds = const [],
    PaymentApproval? payment,
    BeanFulfillmentMethod fulfillmentMethod = BeanFulfillmentMethod.delivery,
    String? storeId,
    String? storeName,
    String? recipient,
    String? recipientPhone,
    String? shippingAddress,
  }) async {
    final result = await _functions.httpsCallable(placeOrderCallableName).call({
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
      'couponIds': couponIds,
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

  Future<BeanOrder> cancelOrder(String orderId) async {
    final result =
        await _functions.httpsCallable(cancelOrderCallableName).call({
      'orderType': 'bean',
      'orderId': orderId,
    });
    return _orderFromResult(result.data);
  }

  BeanOrder _orderFromResult(Object? data) {
    final map = deepStringKeyedMap(data);
    return beanOrderFromFirestore(map['order'] as Map<String, dynamic>);
  }
}
