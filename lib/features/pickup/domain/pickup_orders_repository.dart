import 'pickup_order_models.dart';

/// 픽업 주문을 읽는다. 보안 규칙이 `pickup_orders/{uid}`의 클라이언트 쓰기를
/// 막으므로 Firestore 구현이 할 수 있는 일은 이것뿐이다.
abstract class PickupOrdersRepository {
  Future<List<PickupOrder>> load();

  Stream<List<PickupOrder>> watchOrders();
}

/// 서버 없이 도는 자리에서만 쓰는 쓰기 가능한 저장소.
abstract class WritablePickupOrdersRepository
    implements PickupOrdersRepository {
  Future<PickupOrder> placeOrder({
    required List<PickupOrderItem> items,
    required String storeId,
    required String storeName,
    int usedPoints,
    int earnedPoints,
    String? couponId,
    String? couponTitle,
    int couponDiscount,
    String? paymentKey,
    String? paymentMethod,
  });

  Future<PickupOrder> cancelOrder(String orderId);
}
