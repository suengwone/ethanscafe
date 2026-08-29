import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/payment_method.dart';

class FirestorePaymentMethodsRepository implements PaymentMethodsRepository {
  FirestorePaymentMethodsRepository({
    required this.uid,
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final String uid;
  final FirebaseFirestore _firestore;

  static const collectionPath = 'paymentMethods';

  DocumentReference<Map<String, dynamic>> get _doc =>
      _firestore.collection(collectionPath).doc(uid);

  @override
  Future<List<PaymentMethod>> load() async {
    final snapshot = await _doc.get();
    final data = snapshot.data();
    if (data != null) {
      return paymentMethodsFromFirestore(data);
    }

    const seeded = <PaymentMethod>[];
    await _doc.set(paymentMethodsToFirestore(seeded));
    return seeded;
  }

  @override
  Future<List<PaymentMethod>> addCard({
    required String brand,
    required String last4,
  }) {
    return _mutate((cards) {
      final card = PaymentMethod(
        id: _generateId(),
        brand: brand,
        last4: last4,
        isDefault: cards.isEmpty,
      );
      return [...cards, card];
    });
  }

  @override
  Future<List<PaymentMethod>> removeCard(String id) {
    return _mutate((cards) {
      final removedDefault = cards.any(
        (card) => card.id == id && card.isDefault,
      );
      var updated = cards.where((card) => card.id != id).toList();
      if (removedDefault && updated.isNotEmpty) {
        updated = [updated.first.copyWith(isDefault: true), ...updated.skip(1)];
      }
      return updated;
    });
  }

  @override
  Future<List<PaymentMethod>> setDefaultCard(String id) {
    return _mutate((cards) {
      return cards
          .map((card) => card.copyWith(isDefault: card.id == id))
          .toList();
    });
  }

  Future<List<PaymentMethod>> _mutate(
    List<PaymentMethod> Function(List<PaymentMethod>) updater,
  ) {
    return _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(_doc);
      final data = snapshot.data();
      final cards = data != null
          ? paymentMethodsFromFirestore(data)
          : const <PaymentMethod>[];
      final updated = updater(cards);
      transaction.set(_doc, paymentMethodsToFirestore(updated));
      return updated;
    });
  }

  String _generateId() =>
      '${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(0xFFFF)}';
}

List<PaymentMethod> paymentMethodsFromFirestore(Map<String, dynamic> data) {
  return ((data['cards'] as List<dynamic>?) ?? const [])
      .map((card) => PaymentMethod.fromJson(card as Map<String, dynamic>))
      .toList();
}

Map<String, dynamic> paymentMethodsToFirestore(List<PaymentMethod> cards) {
  return {'cards': cards.map((card) => card.toJson()).toList()};
}
