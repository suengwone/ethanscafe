import 'package:cloud_functions/cloud_functions.dart';

import '../../../core/firebase/firestore_converters.dart';
import '../../payment/domain/payment_models.dart';
import '../domain/pickup_order_models.dart';
import 'firestore_pickup_orders_repository.dart';

class CloudFunctionsPickupCheckoutRepository {
  CloudFunctionsPickupCheckoutRepository({FirebaseFunctions? functions})
      : _functions =
            functions ?? FirebaseFunctions.instanceFor(region: _region);

  static const _region = 'asia-northeast3';
  static const placeOrderCallableName = 'placeOrder';
  static const cancelOrderCallableName = 'cancelOrder';

  final FirebaseFunctions _functions;

  Future<PickupOrder> placeOrder({
    required List<PickupOrderItem> items,
    required String storeId,
    required String storeName,
    int usedPoints = 0,
    List<String> couponIds = const [],
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
      'couponIds': couponIds,
      if (payment != null)
        'payment': {
          'paymentKey': payment.paymentKey,
          'orderId': payment.orderId,
          'amount': payment.amount,
        },
    });
    return _orderFromResult(result.data);
  }

  Future<PickupOrder> cancelOrder(String orderId) async {
    final result =
        await _functions.httpsCallable(cancelOrderCallableName).call({
      'orderType': 'pickup',
      'orderId': orderId,
    });
    return _orderFromResult(result.data);
  }

  PickupOrder _orderFromResult(Object? data) {
    final map = deepStringKeyedMap(data);
    return pickupOrderFromFirestore(map['order'] as Map<String, dynamic>);
  }
}
