import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/delivery_address.dart';

class LocalDeliveryAddressesRepository implements DeliveryAddressesRepository {
  static const _storageKey = 'delivery_addresses';

  @override
  Future<List<DeliveryAddress>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw != null) {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map((e) => DeliveryAddress.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    final seeded = _seedAddresses();
    await _save(prefs, seeded);
    return seeded;
  }

  @override
  Future<List<DeliveryAddress>> addAddress({
    required String label,
    required String recipient,
    required String phone,
    required String address1,
    String address2 = '',
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final addresses = await load();
    final address = DeliveryAddress(
      id: _generateId(),
      label: label,
      recipient: recipient,
      phone: phone,
      address1: address1,
      address2: address2,
      isDefault: addresses.isEmpty,
    );
    final updated = [...addresses, address];
    await _save(prefs, updated);
    return updated;
  }

  @override
  Future<List<DeliveryAddress>> removeAddress(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final addresses = await load();
    final removedDefault = addresses.any(
      (address) => address.id == id && address.isDefault,
    );
    var updated = addresses.where((address) => address.id != id).toList();
    if (removedDefault && updated.isNotEmpty) {
      updated = [updated.first.copyWith(isDefault: true), ...updated.skip(1)];
    }
    await _save(prefs, updated);
    return updated;
  }

  @override
  Future<List<DeliveryAddress>> setDefaultAddress(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final addresses = await load();
    final updated = addresses
        .map((address) => address.copyWith(isDefault: address.id == id))
        .toList();
    await _save(prefs, updated);
    return updated;
  }

  Future<void> _save(
    SharedPreferences prefs,
    List<DeliveryAddress> addresses,
  ) async {
    await prefs.setString(
      _storageKey,
      jsonEncode(addresses.map((address) => address.toJson()).toList()),
    );
  }

  String _generateId() =>
      '${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(0xFFFF)}';

  List<DeliveryAddress> _seedAddresses() => const [
    DeliveryAddress(
      id: 'seed-home',
      label: '집',
      recipient: '이단',
      phone: '010-1234-5678',
      address1: '서울 성동구 연무장길 47',
      address2: '101동 1001호',
      isDefault: true,
    ),
  ];
}
