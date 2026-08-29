import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/firebase/firestore_converters.dart';
import '../../beans/domain/bean_models.dart';
import '../domain/bean_subscriptions_repository.dart';
import '../domain/subscription_models.dart';

class FirestoreBeanSubscriptionsRepository
    implements BeanSubscriptionsRepository {
  FirestoreBeanSubscriptionsRepository({
    required this.uid,
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final String uid;
  final FirebaseFirestore _firestore;

  static const collectionPath = 'subscriptions';

  DocumentReference<Map<String, dynamic>> get _doc =>
      _firestore.collection(collectionPath).doc(uid);

  @override
  Future<List<BeanSubscription>> load() async {
    final snapshot = await _doc.get();
    final data = snapshot.data();
    if (data == null) {
      return const [];
    }
    return beanSubscriptionsFromFirestore(data);
  }

  @override
  Future<BeanSubscription> subscribe({
    required String beanId,
    required String beanName,
    required BeanWeight weight,
    required GrindOption grind,
    required int quantity,
    required SubscriptionCycle cycle,
    required int unitPrice,
  }) async {
    if (quantity < 1) {
      throw ArgumentError.value(quantity, 'quantity', '수량은 1개 이상이어야 합니다.');
    }

    final now = DateTime.now();
    final subscription = BeanSubscription(
      id: _generateId(),
      beanId: beanId,
      beanName: beanName,
      weight: weight,
      grind: grind,
      quantity: quantity,
      cycle: cycle,
      unitPrice: unitPrice,
      nextDeliveryDate: now.add(Duration(days: cycle.days)),
      createdAt: now,
    );

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(_doc);
      final data = snapshot.data();
      final subscriptions = data != null
          ? beanSubscriptionsFromFirestore(data)
          : const <BeanSubscription>[];
      transaction.set(
        _doc,
        beanSubscriptionsToFirestore([subscription, ...subscriptions]),
      );
    });
    return subscription;
  }

  @override
  Future<BeanSubscription> updateStatus({
    required String id,
    required SubscriptionStatus status,
  }) async {
    late BeanSubscription updated;
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(_doc);
      final data = snapshot.data();
      final subscriptions = data != null
          ? beanSubscriptionsFromFirestore(data)
          : const <BeanSubscription>[];
      final index = subscriptions.indexWhere(
        (subscription) => subscription.id == id,
      );
      if (index < 0) {
        throw ArgumentError.value(id, 'id', '구독을 찾을 수 없습니다.');
      }
      final current = subscriptions[index];
      updated = current.copyWith(
        status: status,
        nextDeliveryDate:
            status == SubscriptionStatus.active && !current.isActive
            ? DateTime.now().add(Duration(days: current.cycle.days))
            : current.nextDeliveryDate,
      );
      final next = [...subscriptions]..[index] = updated;
      transaction.set(_doc, beanSubscriptionsToFirestore(next));
    });
    return updated;
  }

  String _generateId() =>
      '${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(0xFFFF)}';
}

List<BeanSubscription> beanSubscriptionsFromFirestore(
  Map<String, dynamic> data,
) {
  return ((data['subscriptions'] as List<dynamic>?) ?? const [])
      .map(
        (subscription) =>
            beanSubscriptionFromFirestore(subscription as Map<String, dynamic>),
      )
      .toList();
}

BeanSubscription beanSubscriptionFromFirestore(Map<String, dynamic> data) {
  return BeanSubscription(
    id: data['id'] as String? ?? '',
    beanId: data['beanId'] as String? ?? '',
    beanName: data['beanName'] as String? ?? '',
    weight: BeanWeight.values.asNameMap()[data['weight']] ?? BeanWeight.g200,
    grind:
        GrindOption.values.asNameMap()[data['grind']] ?? GrindOption.wholeBean,
    quantity: (data['quantity'] as num? ?? 1).toInt(),
    cycle:
        SubscriptionCycle.values.asNameMap()[data['cycle']] ??
        SubscriptionCycle.monthly,
    unitPrice: (data['unitPrice'] as num? ?? 0).toInt(),
    status:
        SubscriptionStatus.values.asNameMap()[data['status']] ??
        SubscriptionStatus.active,
    nextDeliveryDate: firestoreDateTime(data['nextDeliveryDate']),
    createdAt: firestoreDateTime(data['createdAt']),
  );
}

Map<String, dynamic> beanSubscriptionsToFirestore(
  List<BeanSubscription> subscriptions,
) {
  return {
    'subscriptions': subscriptions.map(beanSubscriptionToFirestore).toList(),
  };
}

Map<String, dynamic> beanSubscriptionToFirestore(
  BeanSubscription subscription,
) {
  return {
    'id': subscription.id,
    'beanId': subscription.beanId,
    'beanName': subscription.beanName,
    'weight': subscription.weight.name,
    'grind': subscription.grind.name,
    'quantity': subscription.quantity,
    'cycle': subscription.cycle.name,
    'unitPrice': subscription.unitPrice,
    'status': subscription.status.name,
    'nextDeliveryDate': Timestamp.fromDate(subscription.nextDeliveryDate),
    'createdAt': Timestamp.fromDate(subscription.createdAt),
  };
}
