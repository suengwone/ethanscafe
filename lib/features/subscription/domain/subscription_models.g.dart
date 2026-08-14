// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BeanSubscription _$BeanSubscriptionFromJson(Map<String, dynamic> json) =>
    _BeanSubscription(
      id: json['id'] as String,
      beanId: json['beanId'] as String,
      beanName: json['beanName'] as String,
      weight: $enumDecode(_$BeanWeightEnumMap, json['weight']),
      grind: $enumDecode(_$GrindOptionEnumMap, json['grind']),
      quantity: (json['quantity'] as num).toInt(),
      cycle: $enumDecode(_$SubscriptionCycleEnumMap, json['cycle']),
      unitPrice: (json['unitPrice'] as num).toInt(),
      status:
          $enumDecodeNullable(_$SubscriptionStatusEnumMap, json['status']) ??
          SubscriptionStatus.active,
      nextDeliveryDate: DateTime.parse(json['nextDeliveryDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$BeanSubscriptionToJson(_BeanSubscription instance) =>
    <String, dynamic>{
      'id': instance.id,
      'beanId': instance.beanId,
      'beanName': instance.beanName,
      'weight': _$BeanWeightEnumMap[instance.weight]!,
      'grind': _$GrindOptionEnumMap[instance.grind]!,
      'quantity': instance.quantity,
      'cycle': _$SubscriptionCycleEnumMap[instance.cycle]!,
      'unitPrice': instance.unitPrice,
      'status': _$SubscriptionStatusEnumMap[instance.status]!,
      'nextDeliveryDate': instance.nextDeliveryDate.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$BeanWeightEnumMap = {BeanWeight.g200: 'g200', BeanWeight.g500: 'g500'};

const _$GrindOptionEnumMap = {
  GrindOption.wholeBean: 'wholeBean',
  GrindOption.espresso: 'espresso',
  GrindOption.mokaPot: 'mokaPot',
  GrindOption.handDrip: 'handDrip',
  GrindOption.frenchPress: 'frenchPress',
};

const _$SubscriptionCycleEnumMap = {
  SubscriptionCycle.weekly: 'weekly',
  SubscriptionCycle.biweekly: 'biweekly',
  SubscriptionCycle.monthly: 'monthly',
};

const _$SubscriptionStatusEnumMap = {
  SubscriptionStatus.active: 'active',
  SubscriptionStatus.paused: 'paused',
  SubscriptionStatus.cancelled: 'cancelled',
};
