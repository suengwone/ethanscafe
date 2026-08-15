// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'points_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PointsData _$PointsDataFromJson(Map<String, dynamic> json) => _PointsData(
  membershipId: json['membershipId'] as String,
  balance: (json['balance'] as num?)?.toInt() ?? 0,
  history:
      (json['history'] as List<dynamic>?)
          ?.map((e) => PointHistoryEntry.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <PointHistoryEntry>[],
);

Map<String, dynamic> _$PointsDataToJson(_PointsData instance) =>
    <String, dynamic>{
      'membershipId': instance.membershipId,
      'balance': instance.balance,
      'history': instance.history,
    };

_PointHistoryEntry _$PointHistoryEntryFromJson(Map<String, dynamic> json) =>
    _PointHistoryEntry(
      id: json['id'] as String,
      type: $enumDecode(_$PointHistoryTypeEnumMap, json['type']),
      description: json['description'] as String,
      amount: (json['amount'] as num).toInt(),
      paymentAmount: (json['paymentAmount'] as num?)?.toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$PointHistoryEntryToJson(_PointHistoryEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$PointHistoryTypeEnumMap[instance.type]!,
      'description': instance.description,
      'amount': instance.amount,
      'paymentAmount': instance.paymentAmount,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$PointHistoryTypeEnumMap = {
  PointHistoryType.earn: 'earn',
  PointHistoryType.use: 'use',
};

_PointsEarnResult _$PointsEarnResultFromJson(Map<String, dynamic> json) =>
    _PointsEarnResult(
      membershipId: json['membershipId'] as String,
      paymentAmount: (json['paymentAmount'] as num).toInt(),
      earned: (json['earned'] as num).toInt(),
      balance: (json['balance'] as num).toInt(),
    );

Map<String, dynamic> _$PointsEarnResultToJson(_PointsEarnResult instance) =>
    <String, dynamic>{
      'membershipId': instance.membershipId,
      'paymentAmount': instance.paymentAmount,
      'earned': instance.earned,
      'balance': instance.balance,
    };
