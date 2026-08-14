import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/firebase/firestore_converters.dart';
import '../../beans/domain/bean_models.dart';
import '../domain/bean_orders_repository.dart';
import '../domain/order_models.dart';

class FirestoreBeanOrdersRepository implements BeanOrdersRepository {
  FirestoreBeanOrdersRepository({
    required this.uid,
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final String uid;
  final FirebaseFirestore _firestore;

  static const collectionPath = 'orders';

  DocumentReference<Map<String, dynamic>> get _doc =>
      _firestore.collection(collectionPath).doc(uid);

  @override
  Future<List<BeanOrder>> load() async {
    final snapshot = await _doc.get();
    final data = snapshot.data();
    if (data == null) {
      return const [];
    }
    return beanOrdersFromFirestore(data);
  }

  @override
  Future<BeanOrder> placeOrder({
    required List<BeanOrderItem> items,
    int usedPoints = 0,
    int earnedPoints = 0,
    String? couponId,
    String? couponTitle,
    int couponDiscount = 0,
    String? paymentKey,
    String? paymentMethod,
    BeanFulfillmentMethod fulfillmentMethod = BeanFulfillmentMethod.delivery,
    String? storeId,
    String? storeName,
    String? recipient,
    String? recipientPhone,
    String? shippingAddress,
  }) async {
    if (items.isEmpty) {
      throw ArgumentError.value(items, 'items', '주문 상품이 비어 있습니다.');
    }

    final order = BeanOrder(
      id: _generateId(),
      items: items,
      totalAmount: items.fold(0, (total, item) => total + item.totalPrice),
      usedPoints: usedPoints,
      earnedPoints: earnedPoints,
      couponId: couponId,
      couponTitle: couponTitle,
      couponDiscount: couponDiscount,
      paymentKey: paymentKey,
      paymentMethod: paymentMethod,
      fulfillmentMethod: fulfillmentMethod,
      storeId: storeId,
      storeName: storeName,
      recipient: recipient,
      recipientPhone: recipientPhone,
      shippingAddress: shippingAddress,
      createdAt: DateTime.now(),
    );

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(_doc);
      final data = snapshot.data();
      final orders =
          data != null ? beanOrdersFromFirestore(data) : const <BeanOrder>[];
      transaction.set(_doc, beanOrdersToFirestore([order, ...orders]));
    });
    return order;
  }

  @override
  Future<BeanOrder> cancelOrder(String orderId) async {
    late BeanOrder cancelled;
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(_doc);
      final data = snapshot.data();
      final orders =
          data != null ? beanOrdersFromFirestore(data) : const <BeanOrder>[];
      final index = orders.indexWhere((order) => order.id == orderId);
      if (index == -1) {
        throw ArgumentError.value(orderId, 'orderId', '주문을 찾을 수 없습니다.');
      }
      final order = orders[index];
      if (order.isCancelled) {
        throw StateError('이미 취소된 주문입니다.');
      }
      if (!order.isCancellable) {
        throw StateError('로스팅이 시작된 주문은 취소할 수 없습니다.');
      }
      cancelled = order.copyWith(status: BeanOrderStatus.cancelled);
      final updated = [...orders]..[index] = cancelled;
      transaction.set(_doc, beanOrdersToFirestore(updated));
    });
    return cancelled;
  }

  String _generateId() =>
      '${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(0xFFFF)}';
}

List<BeanOrder> beanOrdersFromFirestore(Map<String, dynamic> data) {
  return ((data['orders'] as List<dynamic>?) ?? const [])
      .map((order) => beanOrderFromFirestore(order as Map<String, dynamic>))
      .toList();
}

BeanOrder beanOrderFromFirestore(Map<String, dynamic> data) {
  return BeanOrder(
    id: data['id'] as String? ?? '',
    items: ((data['items'] as List<dynamic>?) ?? const [])
        .map((item) => beanOrderItemFromFirestore(item as Map<String, dynamic>))
        .toList(),
    totalAmount: (data['totalAmount'] as num? ?? 0).toInt(),
    usedPoints: (data['usedPoints'] as num? ?? 0).toInt(),
    earnedPoints: (data['earnedPoints'] as num? ?? 0).toInt(),
    couponId: data['couponId'] as String?,
    couponTitle: data['couponTitle'] as String?,
    couponDiscount: (data['couponDiscount'] as num? ?? 0).toInt(),
    paymentKey: data['paymentKey'] as String?,
    paymentMethod: data['paymentMethod'] as String?,
    fulfillmentMethod:
        BeanFulfillmentMethod.values.asNameMap()[data['fulfillmentMethod']] ??
            BeanFulfillmentMethod.delivery,
    storeId: data['storeId'] as String?,
    storeName: data['storeName'] as String?,
    recipient: data['recipient'] as String?,
    recipientPhone: data['recipientPhone'] as String?,
    shippingAddress: data['shippingAddress'] as String?,
    status: BeanOrderStatus.values.asNameMap()[data['status']] ??
        BeanOrderStatus.received,
    createdAt: firestoreDateTime(data['createdAt']),
  );
}

BeanOrderItem beanOrderItemFromFirestore(Map<String, dynamic> data) {
  return BeanOrderItem(
    beanId: data['beanId'] as String? ?? '',
    beanName: data['beanName'] as String? ?? '',
    weight: BeanWeight.values.asNameMap()[data['weight']] ?? BeanWeight.g200,
    grind:
        GrindOption.values.asNameMap()[data['grind']] ?? GrindOption.wholeBean,
    quantity: (data['quantity'] as num? ?? 1).toInt(),
    unitPrice: (data['unitPrice'] as num? ?? 0).toInt(),
  );
}

Map<String, dynamic> beanOrdersToFirestore(List<BeanOrder> orders) {
  return {'orders': orders.map(beanOrderToFirestore).toList()};
}

Map<String, dynamic> beanOrderToFirestore(BeanOrder order) {
  return {
    'id': order.id,
    'items': order.items.map(beanOrderItemToFirestore).toList(),
    'totalAmount': order.totalAmount,
    'usedPoints': order.usedPoints,
    'earnedPoints': order.earnedPoints,
    if (order.couponId != null) 'couponId': order.couponId,
    if (order.couponTitle != null) 'couponTitle': order.couponTitle,
    'couponDiscount': order.couponDiscount,
    if (order.paymentKey != null) 'paymentKey': order.paymentKey,
    if (order.paymentMethod != null) 'paymentMethod': order.paymentMethod,
    'fulfillmentMethod': order.fulfillmentMethod.name,
    if (order.storeId != null) 'storeId': order.storeId,
    if (order.storeName != null) 'storeName': order.storeName,
    if (order.recipient != null) 'recipient': order.recipient,
    if (order.recipientPhone != null) 'recipientPhone': order.recipientPhone,
    if (order.shippingAddress != null)
      'shippingAddress': order.shippingAddress,
    'status': order.status.name,
    'createdAt': Timestamp.fromDate(order.createdAt),
  };
}

Map<String, dynamic> beanOrderItemToFirestore(BeanOrderItem item) {
  return {
    'beanId': item.beanId,
    'beanName': item.beanName,
    'weight': item.weight.name,
    'grind': item.grind.name,
    'quantity': item.quantity,
    'unitPrice': item.unitPrice,
  };
}
