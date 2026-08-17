import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

import '../../pickup/data/firestore_pickup_orders_repository.dart';
import '../../pickup/domain/pickup_order_models.dart';
import '../domain/admin_order_models.dart';
import '../domain/admin_orders_repository.dart';
import '../domain/order_models.dart';
import 'firestore_bean_orders_repository.dart';

/// 관리자 권한(admin 커스텀 클레임)으로 전체 주문을 읽고,
/// 상태 변경은 `updateOrderStatus` 콜러블에 맡긴다.
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
  static const updateCallableName = 'updateOrderStatus';

  @override
  Future<List<AdminPickupOrder>> loadActivePickupOrders() async {
    final snapshot = await _firestore
        .collection(FirestorePickupOrdersRepository.collectionPath)
        .get();

    final entries = <AdminPickupOrder>[];
    for (final doc in snapshot.docs) {
      for (final order in pickupOrdersFromFirestore(doc.data())) {
        if (!isPickupOrderClosed(order)) {
          entries.add(AdminPickupOrder(uid: doc.id, order: order));
        }
      }
    }
    entries.sort((a, b) => a.order.createdAt.compareTo(b.order.createdAt));
    return entries;
  }

  @override
  Future<List<AdminBeanOrder>> loadActiveBeanOrders() async {
    final snapshot = await _firestore
        .collection(FirestoreBeanOrdersRepository.collectionPath)
        .get();

    final entries = <AdminBeanOrder>[];
    for (final doc in snapshot.docs) {
      for (final order in beanOrdersFromFirestore(doc.data())) {
        if (!isBeanOrderClosed(order)) {
          entries.add(AdminBeanOrder(uid: doc.id, order: order));
        }
      }
    }
    entries.sort((a, b) => a.order.createdAt.compareTo(b.order.createdAt));
    return entries;
  }

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
