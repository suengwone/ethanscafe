import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import '../../beans/domain/bean_models.dart';
import '../domain/bean_gifts_repository.dart';
import '../domain/gift_models.dart';

class LocalBeanGiftsRepository implements BeanGiftsRepository {
  static const _storageKey = 'bean_gifts';

  @override
  Future<List<BeanGift>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null) {
      return const [];
    }
    final data = jsonDecode(raw) as Map<String, dynamic>;
    return ((data['gifts'] as List<dynamic>?) ?? const [])
        .map((gift) => BeanGift.fromJson(gift as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<BeanGift> sendGift({
    required String beanId,
    required String beanName,
    required BeanWeight weight,
    required GrindOption grind,
    required int quantity,
    required int unitPrice,
    required String recipientName,
    required String recipientPhone,
    String message = '',
  }) async {
    if (recipientName.trim().isEmpty) {
      throw ArgumentError.value(
        recipientName,
        'recipientName',
        '받는 분 이름이 비어 있습니다.',
      );
    }
    if (recipientPhone.trim().isEmpty) {
      throw ArgumentError.value(
        recipientPhone,
        'recipientPhone',
        '받는 분 연락처가 비어 있습니다.',
      );
    }

    final prefs = await SharedPreferences.getInstance();
    final gifts = await load();
    final gift = BeanGift(
      id: _generateId(),
      beanId: beanId,
      beanName: beanName,
      weight: weight,
      grind: grind,
      quantity: quantity,
      unitPrice: unitPrice,
      recipientName: recipientName.trim(),
      recipientPhone: recipientPhone.trim(),
      message: message.trim(),
      createdAt: DateTime.now(),
    );

    await prefs.setString(
      _storageKey,
      jsonEncode({
        'gifts': [gift, ...gifts].map((gift) => gift.toJson()).toList(),
      }),
    );
    return gift;
  }

  String _generateId() =>
      '${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(0xFFFF)}';
}
