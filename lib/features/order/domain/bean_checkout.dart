import '../../coupon/domain/coupon_models.dart';
import '../../payment/domain/payment_models.dart';
import 'order_models.dart';

/// 원두 주문을 성립시키고 되돌리는 한 가지 방법.
///
/// 회원 주문은 콜러블이 포인트·쿠폰·판매량을 한 트랜잭션에서 처리한다. 서버가
/// 없는 자리(테스트, Firebase가 뜨지 않은 실행)에서는 로컬 구현이 같은 일을
/// 순서대로 흉내 낸다. 주문 컨트롤러는 둘을 구분하지 않는다.
abstract class BeanCheckout {
  Future<BeanOrder> placeOrder({
    required List<BeanOrderItem> items,
    List<Coupon> coupons,
    int couponDiscount,
    int usedPoints,
    PaymentApproval? payment,
    BeanFulfillmentMethod fulfillmentMethod,
    String? storeId,
    String? storeName,
    String? recipient,
    String? recipientPhone,
    String? shippingAddress,
  });

  Future<BeanOrder> cancelOrder(String orderId);
}
