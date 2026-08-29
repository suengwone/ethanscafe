import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/payment_method.dart';

class LocalPaymentMethodsRepository implements PaymentMethodsRepository {
  static const _storageKey = 'payment_methods';

  @override
  Future<List<PaymentMethod>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw != null) {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map((e) => PaymentMethod.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    final seeded = _seedCards();
    await _save(prefs, seeded);
    return seeded;
  }

  @override
  Future<List<PaymentMethod>> addCard({
    required String brand,
    required String last4,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final cards = await load();
    final card = PaymentMethod(
      id: _generateId(),
      brand: brand,
      last4: last4,
      isDefault: cards.isEmpty,
    );
    final updated = [...cards, card];
    await _save(prefs, updated);
    return updated;
  }

  @override
  Future<List<PaymentMethod>> removeCard(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final cards = await load();
    final removedDefault = cards.any((card) => card.id == id && card.isDefault);
    var updated = cards.where((card) => card.id != id).toList();
    if (removedDefault && updated.isNotEmpty) {
      updated = [updated.first.copyWith(isDefault: true), ...updated.skip(1)];
    }
    await _save(prefs, updated);
    return updated;
  }

  @override
  Future<List<PaymentMethod>> setDefaultCard(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final cards = await load();
    final updated = cards
        .map((card) => card.copyWith(isDefault: card.id == id))
        .toList();
    await _save(prefs, updated);
    return updated;
  }

  Future<void> _save(SharedPreferences prefs, List<PaymentMethod> cards) async {
    await prefs.setString(
      _storageKey,
      jsonEncode(cards.map((card) => card.toJson()).toList()),
    );
  }

  String _generateId() =>
      '${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(0xFFFF)}';

  List<PaymentMethod> _seedCards() => const [
    PaymentMethod(
      id: 'seed-shinhan-1234',
      brand: '신한카드',
      last4: '1234',
      isDefault: true,
    ),
    PaymentMethod(id: 'seed-hyundai-5678', brand: '현대카드', last4: '5678'),
  ];
}
