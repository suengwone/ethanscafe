import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/delivery_address.dart';

class FirestoreDeliveryAddressesRepository
    implements DeliveryAddressesRepository {
  FirestoreDeliveryAddressesRepository({
    required this.uid,
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final String uid;
  final FirebaseFirestore _firestore;

  static const collectionPath = 'deliveryAddresses';

  DocumentReference<Map<String, dynamic>> get _doc =>
      _firestore.collection(collectionPath).doc(uid);

  @override
  Future<List<DeliveryAddress>> load() async {
    final snapshot = await _doc.get();
    final data = snapshot.data();
    if (data != null) {
      return deliveryAddressesFromFirestore(data);
    }

    const seeded = <DeliveryAddress>[];
    await _doc.set(deliveryAddressesToFirestore(seeded));
    return seeded;
  }

  @override
  Future<List<DeliveryAddress>> addAddress({
    required String label,
    required String recipient,
    required String phone,
    required String address1,
    String address2 = '',
  }) {
    return _mutate((addresses) {
      final address = DeliveryAddress(
        id: _generateId(),
        label: label,
        recipient: recipient,
        phone: phone,
        address1: address1,
        address2: address2,
        isDefault: addresses.isEmpty,
      );
      return [...addresses, address];
    });
  }

  @override
  Future<List<DeliveryAddress>> removeAddress(String id) {
    return _mutate((addresses) {
      final removedDefault =
          addresses.any((address) => address.id == id && address.isDefault);
      var updated = addresses.where((address) => address.id != id).toList();
      if (removedDefault && updated.isNotEmpty) {
        updated = [
          updated.first.copyWith(isDefault: true),
          ...updated.skip(1),
        ];
      }
      return updated;
    });
  }

  @override
  Future<List<DeliveryAddress>> setDefaultAddress(String id) {
    return _mutate((addresses) {
      return addresses
          .map((address) => address.copyWith(isDefault: address.id == id))
          .toList();
    });
  }

  Future<List<DeliveryAddress>> _mutate(
    List<DeliveryAddress> Function(List<DeliveryAddress>) updater,
  ) {
    return _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(_doc);
      final data = snapshot.data();
      final addresses = data != null
          ? deliveryAddressesFromFirestore(data)
          : const <DeliveryAddress>[];
      final updated = updater(addresses);
      transaction.set(_doc, deliveryAddressesToFirestore(updated));
      return updated;
    });
  }

  String _generateId() =>
      '${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(0xFFFF)}';
}

List<DeliveryAddress> deliveryAddressesFromFirestore(
    Map<String, dynamic> data) {
  return ((data['addresses'] as List<dynamic>?) ?? const [])
      .map((address) => DeliveryAddress.fromJson(address as Map<String, dynamic>))
      .toList();
}

Map<String, dynamic> deliveryAddressesToFirestore(
    List<DeliveryAddress> addresses) {
  return {'addresses': addresses.map((address) => address.toJson()).toList()};
}
