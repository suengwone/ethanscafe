import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/pickup_order_models.dart';
import '../domain/pickup_orders_repository.dart';

class LocalPickupOrdersRepository implements PickupOrdersRepository {
  static const _storageKey = 'pickup_orders';

  @override
  Future<List<PickupOrder>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null) {
      return const [];
    }
    final data = jsonDecode(raw) as Map<String, dynamic>;
    return ((data['orders'] as List<dynamic>?) ?? const [])
        .map((order) => PickupOrder.fromJson(order as Map<String, dynamic>))
        .toList();
  }

  @override
  Stream<List<PickupOrder>> watchOrders() => Stream.fromFuture(load());

  @override
  Future<PickupOrder> placeOrder({
    required List<PickupOrderItem> items,
    required String storeId,
    required String storeName,
    int usedPoints = 0,
    int earnedPoints = 0,
    String? couponId,
    String? couponTitle,
    int couponDiscount = 0,
    String? paymentKey,
    String? paymentMethod,
  }) async {
    if (items.isEmpty) {
      throw ArgumentError.value(items, 'items', '주문 상품이 비어 있습니다.');
    }

    final prefs = await SharedPreferences.getInstance();
    final orders = await load();
    final now = DateTime.now();
    final order = PickupOrder(
      id: _generateId(),
      storeId: storeId,
      storeName: storeName,
      pickupNumber: nextPickupNumber(orders, now),
      items: items,
      totalAmount: items.fold(0, (sum, item) => sum + item.totalPrice),
      usedPoints: usedPoints,
      earnedPoints: earnedPoints,
      couponId: couponId,
      couponTitle: couponTitle,
      couponDiscount: couponDiscount,
      paymentKey: paymentKey,
      paymentMethod: paymentMethod,
      createdAt: now,
    );

    await prefs.setString(
      _storageKey,
      jsonEncode({
        'orders': [order, ...orders].map((order) => order.toJson()).toList(),
      }),
    );
    return order;
  }

  @override
  Future<PickupOrder> cancelOrder(String orderId) async {
    final prefs = await SharedPreferences.getInstance();
    final orders = await load();
    final index = orders.indexWhere((order) => order.id == orderId);
    if (index == -1) {
      throw ArgumentError.value(orderId, 'orderId', '주문을 찾을 수 없습니다.');
    }
    final order = orders[index];
    if (order.isCancelled) {
      throw StateError('이미 취소된 주문입니다.');
    }
    if (!order.isCancellable) {
      throw StateError('제조가 시작된 주문은 취소할 수 없습니다.');
    }

    final cancelled = order.copyWith(status: PickupOrderStatus.cancelled);
    final updated = [...orders]..[index] = cancelled;
    await prefs.setString(
      _storageKey,
      jsonEncode({
        'orders': updated.map((order) => order.toJson()).toList(),
      }),
    );
    return cancelled;
  }

  String _generateId() =>
      '${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(0xFFFF)}';
}
