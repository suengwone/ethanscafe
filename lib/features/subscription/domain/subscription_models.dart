import 'package:freezed_annotation/freezed_annotation.dart';

import '../../beans/domain/bean_models.dart';

part 'subscription_models.freezed.dart';
part 'subscription_models.g.dart';

enum SubscriptionCycle {
  weekly('매주', 7),
  biweekly('격주', 14),
  monthly('매월', 30);

  const SubscriptionCycle(this.label, this.days);

  final String label;
  final int days;
}

enum SubscriptionStatus {
  active('구독 중'),
  paused('일시정지'),
  cancelled('해지됨');

  const SubscriptionStatus(this.label);

  final String label;
}

@freezed
abstract class BeanSubscription with _$BeanSubscription {
  const BeanSubscription._();

  const factory BeanSubscription({
    required String id,
    required String beanId,
    required String beanName,
    required BeanWeight weight,
    required GrindOption grind,
    required int quantity,
    required SubscriptionCycle cycle,
    required int unitPrice,
    @Default(SubscriptionStatus.active) SubscriptionStatus status,
    required DateTime nextDeliveryDate,
    required DateTime createdAt,
  }) = _BeanSubscription;

  factory BeanSubscription.fromJson(Map<String, dynamic> json) =>
      _$BeanSubscriptionFromJson(json);

  int get pricePerDelivery => unitPrice * quantity;

  String get optionLabel => '${weight.label} · ${grind.label}';

  String get cycleLabel => '${cycle.label} $quantity개';

  bool get isActive => status == SubscriptionStatus.active;

  bool get isPaused => status == SubscriptionStatus.paused;

  bool get isCancelled => status == SubscriptionStatus.cancelled;
}
