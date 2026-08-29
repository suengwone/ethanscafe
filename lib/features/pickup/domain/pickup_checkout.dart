import '../../coupon/domain/coupon_models.dart';
import '../../payment/domain/payment_models.dart';
import 'pickup_order_models.dart';

/// 픽업 주문을 성립시키고 되돌리는 한 가지 방법. [BeanCheckout]과 짝이다.
abstract class PickupCheckout {
  Future<PickupOrder> placeOrder({
    required List<PickupOrderItem> items,
    required String storeId,
    required String storeName,
    List<Coupon> coupons,
    int couponDiscount,
    int usedPoints,
    PaymentApproval? payment,
  });

  Future<PickupOrder> cancelOrder(String orderId);
}
