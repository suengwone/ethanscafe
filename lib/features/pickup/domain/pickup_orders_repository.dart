import 'pickup_order_models.dart';

abstract class PickupOrdersRepository {
  Future<List<PickupOrder>> load();

  Stream<List<PickupOrder>> watchOrders();

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
