import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/firebase/firestore_converters.dart';
import '../domain/pickup_order_models.dart';
import '../domain/pickup_orders_repository.dart';

class FirestorePickupOrdersRepository implements PickupOrdersRepository {
  FirestorePickupOrdersRepository({
    required this.uid,
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final String uid;
  final FirebaseFirestore _firestore;

  static const collectionPath = 'pickup_orders';

  DocumentReference<Map<String, dynamic>> get _doc =>
      _firestore.collection(collectionPath).doc(uid);

  @override
  Future<List<PickupOrder>> load() async {
    final snapshot = await _doc.get();
    final data = snapshot.data();
    if (data == null) {
      return const [];
    }
    return pickupOrdersFromFirestore(data);
  }

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

    late PickupOrder order;
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(_doc);
      final data = snapshot.data();
      final orders = data != null
          ? pickupOrdersFromFirestore(data)
          : const <PickupOrder>[];
      final now = DateTime.now();
      order = PickupOrder(
        id: _generateId(),
        storeId: storeId,
        storeName: storeName,
        pickupNumber: nextPickupNumber(orders, now),
        items: items,
        totalAmount: items.fold(0, (total, item) => total + item.totalPrice),
        usedPoints: usedPoints,
        earnedPoints: earnedPoints,
        couponId: couponId,
        couponTitle: couponTitle,
        couponDiscount: couponDiscount,
        paymentKey: paymentKey,
        paymentMethod: paymentMethod,
        createdAt: now,
      );
      transaction.set(_doc, pickupOrdersToFirestore([order, ...orders]));
    });
    return order;
  }

  String _generateId() =>
      '${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(0xFFFF)}';
}

List<PickupOrder> pickupOrdersFromFirestore(Map<String, dynamic> data) {
  return ((data['orders'] as List<dynamic>?) ?? const [])
      .map((order) => pickupOrderFromFirestore(order as Map<String, dynamic>))
      .toList();
}

PickupOrder pickupOrderFromFirestore(Map<String, dynamic> data) {
  return PickupOrder(
    id: data['id'] as String? ?? '',
    storeId: data['storeId'] as String? ?? '',
    storeName: data['storeName'] as String? ?? '',
    pickupNumber: (data['pickupNumber'] as num? ?? 0).toInt(),
    items: ((data['items'] as List<dynamic>?) ?? const [])
        .map(
          (item) => pickupOrderItemFromFirestore(item as Map<String, dynamic>),
        )
        .toList(),
    totalAmount: (data['totalAmount'] as num? ?? 0).toInt(),
    usedPoints: (data['usedPoints'] as num? ?? 0).toInt(),
    earnedPoints: (data['earnedPoints'] as num? ?? 0).toInt(),
    couponId: data['couponId'] as String?,
    couponTitle: data['couponTitle'] as String?,
    couponDiscount: (data['couponDiscount'] as num? ?? 0).toInt(),
    paymentKey: data['paymentKey'] as String?,
    paymentMethod: data['paymentMethod'] as String?,
    status: PickupOrderStatus.values.asNameMap()[data['status']] ??
        PickupOrderStatus.received,
    createdAt: firestoreDateTime(data['createdAt']),
  );
}

PickupOrderItem pickupOrderItemFromFirestore(Map<String, dynamic> data) {
  return PickupOrderItem(
    menuId: data['menuId'] as String? ?? '',
    menuName: data['menuName'] as String? ?? '',
    option: data['option'] as String?,
    quantity: (data['quantity'] as num? ?? 1).toInt(),
    unitPrice: (data['unitPrice'] as num? ?? 0).toInt(),
  );
}

Map<String, dynamic> pickupOrdersToFirestore(List<PickupOrder> orders) {
  return {'orders': orders.map(pickupOrderToFirestore).toList()};
}

Map<String, dynamic> pickupOrderToFirestore(PickupOrder order) {
  return {
    'id': order.id,
    'storeId': order.storeId,
    'storeName': order.storeName,
    'pickupNumber': order.pickupNumber,
    'items': order.items.map(pickupOrderItemToFirestore).toList(),
    'totalAmount': order.totalAmount,
    'usedPoints': order.usedPoints,
    'earnedPoints': order.earnedPoints,
    if (order.couponId != null) 'couponId': order.couponId,
    if (order.couponTitle != null) 'couponTitle': order.couponTitle,
    'couponDiscount': order.couponDiscount,
    if (order.paymentKey != null) 'paymentKey': order.paymentKey,
    if (order.paymentMethod != null) 'paymentMethod': order.paymentMethod,
    'status': order.status.name,
    'createdAt': Timestamp.fromDate(order.createdAt),
  };
}

Map<String, dynamic> pickupOrderItemToFirestore(PickupOrderItem item) {
  return {
    'menuId': item.menuId,
    'menuName': item.menuName,
    if (item.option != null) 'option': item.option,
    'quantity': item.quantity,
    'unitPrice': item.unitPrice,
  };
}
