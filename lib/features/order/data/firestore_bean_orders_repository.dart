import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/firebase/firestore_converters.dart';
import '../../beans/domain/bean_models.dart';
import '../domain/bean_orders_repository.dart';
import '../domain/order_models.dart';
import '../domain/refund_status.dart';

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
    refundStatus: RefundStatus.parse(data['refundStatus']),
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
