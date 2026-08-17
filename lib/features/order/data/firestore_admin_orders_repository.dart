import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

import '../../pickup/domain/pickup_order_models.dart';
import '../domain/admin_order_models.dart';
import '../domain/admin_orders_repository.dart';
import '../domain/order_models.dart';
import '../domain/refund_failure_models.dart';

/// 진행 중인 주문 색인(`active_orders`)을 읽고, 쓰기는 서버 콜러블에 맡긴다.
/// 색인은 주문 문서 트리거가 유지하며 클라이언트는 쓰지 않는다.
class FirestoreAdminOrdersRepository implements AdminOrdersRepository {
  FirestoreAdminOrdersRepository({
    FirebaseFirestore? firestore,
    FirebaseFunctions? functions,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _functions =
            functions ?? FirebaseFunctions.instanceFor(region: _region);

  final FirebaseFirestore _firestore;
  final FirebaseFunctions _functions;

  static const _region = 'asia-northeast3';
  static const collectionPath = 'active_orders';
  static const updateCallableName = 'updateOrderStatus';
  static const cancelCallableName = 'cancelOrder';
  static const retryRefundCallableName = 'retryRefund';
  static const refundFailuresPath = 'refund_failures';

  @override
  Future<List<ActivePickupOrder>> loadActivePickupOrders() async {
    final docs = await _loadByType('pickup');
    return docs.map((data) {
      return ActivePickupOrder(
        uid: data['uid'] as String? ?? '',
        orderId: data['orderId'] as String? ?? '',
        summary: data['summary'] as String? ?? '주문',
        status: PickupOrderStatus.values.asNameMap()[data['status']] ??
            PickupOrderStatus.received,
        pickupNumber: (data['pickupNumber'] as num?)?.toInt() ?? 0,
        storeName: data['storeName'] as String? ?? '',
        createdAt: _createdAt(data),
      );
    }).toList();
  }

  @override
  Future<List<ActiveBeanOrder>> loadActiveBeanOrders() async {
    final docs = await _loadByType('bean');
    return docs.map((data) {
      return ActiveBeanOrder(
        uid: data['uid'] as String? ?? '',
        orderId: data['orderId'] as String? ?? '',
        summary: data['summary'] as String? ?? '주문',
        status: BeanOrderStatus.values.asNameMap()[data['status']] ??
            BeanOrderStatus.received,
        fulfillmentMethod:
            BeanFulfillmentMethod.values.asNameMap()[data['fulfillmentMethod']] ??
                BeanFulfillmentMethod.delivery,
        recipient: data['recipient'] as String?,
        storeName: data['storeName'] as String?,
        createdAt: _createdAt(data),
      );
    }).toList();
  }

  Future<List<Map<String, dynamic>>> _loadByType(String orderType) async {
    final snapshot = await _firestore
        .collection(collectionPath)
        .where('orderType', isEqualTo: orderType)
        .orderBy('createdAt')
        .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  static DateTime _createdAt(Map<String, dynamic> data) =>
      _timestamp(data['createdAt']);

  static DateTime _timestamp(Object? value) =>
      value is Timestamp ? value.toDate() : DateTime.now();

  @override
  Future<void> advancePickupStatus({
    required String uid,
    required String orderId,
    required PickupOrderStatus status,
  }) {
    return _update(
      orderType: 'pickup',
      uid: uid,
      orderId: orderId,
      status: status.name,
    );
  }

  @override
  Future<void> advanceBeanStatus({
    required String uid,
    required String orderId,
    required BeanOrderStatus status,
  }) {
    return _update(
      orderType: 'bean',
      uid: uid,
      orderId: orderId,
      status: status.name,
    );
  }

  @override
  Future<void> cancelOrder({
    required String orderType,
    required String uid,
    required String orderId,
  }) async {
    await _functions.httpsCallable(cancelCallableName).call({
      'orderType': orderType,
      'uid': uid,
      'orderId': orderId,
    });
  }

  @override
  Future<List<RefundFailure>> loadRefundFailures() async {
    final snapshot = await _firestore
        .collection(refundFailuresPath)
        .orderBy('failedAt')
        .get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return RefundFailure(
        orderType: data['orderType'] as String? ?? 'pickup',
        uid: data['uid'] as String? ?? '',
        orderId: data['orderId'] as String? ?? '',
        summary: data['summary'] as String? ?? '주문',
        amount: (data['amount'] as num?)?.toInt() ?? 0,
        failedAt: _timestamp(data['failedAt']),
      );
    }).toList();
  }

  @override
  Future<void> retryRefund(RefundFailure failure) async {
    await _functions.httpsCallable(retryRefundCallableName).call({
      'orderType': failure.orderType,
      'uid': failure.uid,
      'orderId': failure.orderId,
    });
  }

  Future<void> _update({
    required String orderType,
    required String uid,
    required String orderId,
    required String status,
  }) async {
    await _functions.httpsCallable(updateCallableName).call({
      'orderType': orderType,
      'uid': uid,
      'orderId': orderId,
      'status': status,
    });
  }
}
