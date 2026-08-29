import 'order_models.dart';

/// 원두 주문을 읽는다. 보안 규칙이 `orders/{uid}`의 클라이언트 쓰기를 막으므로
/// Firestore 구현이 할 수 있는 일은 이것뿐이다.
abstract class BeanOrdersRepository {
  Future<List<BeanOrder>> load();
}

/// 서버 없이 도는 자리에서만 쓰는 쓰기 가능한 저장소. 운영에서는 주문이
/// 콜러블을 지나므로 이 인터페이스를 구현하는 것은 로컬 저장소뿐이다.
abstract class WritableBeanOrdersRepository implements BeanOrdersRepository {
  Future<BeanOrder> placeOrder({
    required List<BeanOrderItem> items,
    int usedPoints,
    int earnedPoints,
    String? couponId,
    String? couponTitle,
    int couponDiscount,
    String? paymentKey,
    String? paymentMethod,
    BeanFulfillmentMethod fulfillmentMethod,
    String? storeId,
    String? storeName,
    String? recipient,
    String? recipientPhone,
    String? shippingAddress,
  });

  Future<BeanOrder> cancelOrder(String orderId);
}
