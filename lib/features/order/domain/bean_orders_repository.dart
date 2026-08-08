import 'order_models.dart';

abstract class BeanOrdersRepository {
  Future<List<BeanOrder>> load();

  Future<BeanOrder> placeOrder({
    required List<BeanOrderItem> items,
    int usedPoints,
    int earnedPoints,
    String? couponId,
    String? couponTitle,
    int couponDiscount,
    String? paymentKey,
    String? paymentMethod,
  });
}
