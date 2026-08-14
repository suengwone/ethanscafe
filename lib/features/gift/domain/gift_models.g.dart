// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gift_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BeanGift _$BeanGiftFromJson(Map<String, dynamic> json) => _BeanGift(
  id: json['id'] as String,
  beanId: json['beanId'] as String,
  beanName: json['beanName'] as String,
  weight: $enumDecode(_$BeanWeightEnumMap, json['weight']),
  grind: $enumDecode(_$GrindOptionEnumMap, json['grind']),
  quantity: (json['quantity'] as num).toInt(),
  unitPrice: (json['unitPrice'] as num).toInt(),
  recipientName: json['recipientName'] as String,
  recipientPhone: json['recipientPhone'] as String,
  message: json['message'] as String? ?? '',
  status:
      $enumDecodeNullable(_$BeanGiftStatusEnumMap, json['status']) ??
      BeanGiftStatus.sent,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$BeanGiftToJson(_BeanGift instance) => <String, dynamic>{
  'id': instance.id,
  'beanId': instance.beanId,
  'beanName': instance.beanName,
  'weight': _$BeanWeightEnumMap[instance.weight]!,
  'grind': _$GrindOptionEnumMap[instance.grind]!,
  'quantity': instance.quantity,
  'unitPrice': instance.unitPrice,
  'recipientName': instance.recipientName,
  'recipientPhone': instance.recipientPhone,
  'message': instance.message,
  'status': _$BeanGiftStatusEnumMap[instance.status]!,
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

const _$BeanGiftStatusEnumMap = {
  BeanGiftStatus.sent: 'sent',
  BeanGiftStatus.redeemed: 'redeemed',
};
