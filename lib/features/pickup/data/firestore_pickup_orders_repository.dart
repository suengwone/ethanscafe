import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/firebase/firestore_converters.dart';
import '../../order/domain/refund_status.dart';
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
  Stream<List<PickupOrder>> watchOrders() {
    return _doc.snapshots().map((snapshot) {
      final data = snapshot.data();
      if (data == null) {
        return const [];
      }
      return pickupOrdersFromFirestore(data);
    });
  }
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
    refundStatus: RefundStatus.parse(data['refundStatus']),
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
