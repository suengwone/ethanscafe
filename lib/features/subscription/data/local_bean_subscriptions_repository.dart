import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import '../../beans/domain/bean_models.dart';
import '../domain/bean_subscriptions_repository.dart';
import '../domain/subscription_models.dart';

class LocalBeanSubscriptionsRepository implements BeanSubscriptionsRepository {
  static const _storageKey = 'bean_subscriptions';

  @override
  Future<List<BeanSubscription>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null) {
      return const [];
    }
    final data = jsonDecode(raw) as Map<String, dynamic>;
    return ((data['subscriptions'] as List<dynamic>?) ?? const [])
        .map(
          (subscription) =>
              BeanSubscription.fromJson(subscription as Map<String, dynamic>),
        )
        .toList();
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

    final subscriptions = await load();
    await _save([subscription, ...subscriptions]);
    return subscription;
  }

  @override
  Future<BeanSubscription> updateStatus({
    required String id,
    required SubscriptionStatus status,
  }) async {
    final subscriptions = await load();
    final index = subscriptions.indexWhere(
      (subscription) => subscription.id == id,
    );
    if (index < 0) {
      throw ArgumentError.value(id, 'id', '구독을 찾을 수 없습니다.');
    }

    final current = subscriptions[index];
    final updated = current.copyWith(
      status: status,
      nextDeliveryDate:
          status == SubscriptionStatus.active && !current.isActive
              ? DateTime.now().add(Duration(days: current.cycle.days))
              : current.nextDeliveryDate,
    );
    final next = [...subscriptions]..[index] = updated;
    await _save(next);
    return updated;
  }

  Future<void> _save(List<BeanSubscription> subscriptions) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _storageKey,
      jsonEncode({
        'subscriptions': subscriptions
            .map((subscription) => subscription.toJson())
            .toList(),
      }),
    );
  }

  String _generateId() =>
      '${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(0xFFFF)}';
}
