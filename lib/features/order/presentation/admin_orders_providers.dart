import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/firestore_admin_orders_repository.dart';
import '../domain/admin_order_models.dart';
import '../domain/admin_orders_repository.dart';

final adminOrdersRepositoryProvider = Provider<AdminOrdersRepository?>((ref) {
  try {
    if (Firebase.apps.isNotEmpty) {
      return FirestoreAdminOrdersRepository();
    }
  } catch (_) {}
  return null;
});

final activePickupOrdersProvider =
    FutureProvider.autoDispose<List<AdminPickupOrder>>((ref) async {
  final repository = ref.watch(adminOrdersRepositoryProvider);
  if (repository == null) {
    return const [];
  }
  return repository.loadActivePickupOrders();
});

final activeBeanOrdersProvider =
    FutureProvider.autoDispose<List<AdminBeanOrder>>((ref) async {
  final repository = ref.watch(adminOrdersRepositoryProvider);
  if (repository == null) {
    return const [];
  }
  return repository.loadActiveBeanOrders();
});

/// 상태를 한 단계 넘기고 목록을 새로 읽는다.
class AdminOrdersController {
  const AdminOrdersController(this._ref);

  final Ref _ref;

  Future<void> advancePickup(AdminPickupOrder entry) async {
    final next = nextPickupStatus(entry.order.status);
    if (next == null) {
      throw StateError('더 진행할 단계가 없습니다.');
    }
    final repository = _ref.read(adminOrdersRepositoryProvider);
    if (repository == null) {
      throw StateError('관리자 기능을 사용할 수 없습니다.');
    }
    await repository.advancePickupStatus(
      uid: entry.uid,
      orderId: entry.order.id,
      status: next,
    );
    _ref.invalidate(activePickupOrdersProvider);
  }

  Future<void> advanceBean(AdminBeanOrder entry) async {
    final next =
        nextBeanStatus(entry.order.status, entry.order.fulfillmentMethod);
    if (next == null) {
      throw StateError('더 진행할 단계가 없습니다.');
    }
    final repository = _ref.read(adminOrdersRepositoryProvider);
    if (repository == null) {
      throw StateError('관리자 기능을 사용할 수 없습니다.');
    }
    await repository.advanceBeanStatus(
      uid: entry.uid,
      orderId: entry.order.id,
      status: next,
    );
    _ref.invalidate(activeBeanOrdersProvider);
  }
}

final adminOrdersControllerProvider = Provider<AdminOrdersController>((ref) {
  return AdminOrdersController(ref);
});
