// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wholesale_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WholesaleQuoteItem _$WholesaleQuoteItemFromJson(Map<String, dynamic> json) =>
    _WholesaleQuoteItem(
      beanId: json['beanId'] as String,
      beanName: json['beanName'] as String,
      kg: (json['kg'] as num).toInt(),
      pricePerKg: (json['pricePerKg'] as num).toInt(),
    );

Map<String, dynamic> _$WholesaleQuoteItemToJson(_WholesaleQuoteItem instance) =>
    <String, dynamic>{
      'beanId': instance.beanId,
      'beanName': instance.beanName,
      'kg': instance.kg,
      'pricePerKg': instance.pricePerKg,
    };

_WholesaleQuote _$WholesaleQuoteFromJson(Map<String, dynamic> json) =>
    _WholesaleQuote(
      id: json['id'] as String,
      companyName: json['companyName'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => WholesaleQuoteItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      memo: json['memo'] as String? ?? '',
      status:
          $enumDecodeNullable(_$WholesaleQuoteStatusEnumMap, json['status']) ??
          WholesaleQuoteStatus.requested,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$WholesaleQuoteToJson(_WholesaleQuote instance) =>
    <String, dynamic>{
      'id': instance.id,
      'companyName': instance.companyName,
      'items': instance.items,
      'memo': instance.memo,
      'status': _$WholesaleQuoteStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$WholesaleQuoteStatusEnumMap = {
  WholesaleQuoteStatus.requested: 'requested',
  WholesaleQuoteStatus.quoted: 'quoted',
  WholesaleQuoteStatus.confirmed: 'confirmed',
};
