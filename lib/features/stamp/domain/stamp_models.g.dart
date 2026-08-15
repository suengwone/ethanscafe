// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stamp_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StampData _$StampDataFromJson(Map<String, dynamic> json) => _StampData(
  count: (json['count'] as num?)?.toInt() ?? 0,
  totalEarned: (json['totalEarned'] as num?)?.toInt() ?? 0,
  history:
      (json['history'] as List<dynamic>?)
          ?.map((e) => StampHistoryEntry.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <StampHistoryEntry>[],
);

Map<String, dynamic> _$StampDataToJson(_StampData instance) =>
    <String, dynamic>{
      'count': instance.count,
      'totalEarned': instance.totalEarned,
      'history': instance.history,
    };

_StampHistoryEntry _$StampHistoryEntryFromJson(Map<String, dynamic> json) =>
    _StampHistoryEntry(
      id: json['id'] as String,
      cups: (json['cups'] as num).toInt(),
      rewards: (json['rewards'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$StampHistoryEntryToJson(_StampHistoryEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cups': instance.cups,
      'rewards': instance.rewards,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_StampEarnResult _$StampEarnResultFromJson(Map<String, dynamic> json) =>
    _StampEarnResult(
      membershipId: json['membershipId'] as String,
      cups: (json['cups'] as num).toInt(),
      count: (json['count'] as num).toInt(),
      totalEarned: (json['totalEarned'] as num).toInt(),
      rewardsIssued: (json['rewardsIssued'] as num).toInt(),
    );

Map<String, dynamic> _$StampEarnResultToJson(_StampEarnResult instance) =>
    <String, dynamic>{
      'membershipId': instance.membershipId,
      'cups': instance.cups,
      'count': instance.count,
      'totalEarned': instance.totalEarned,
      'rewardsIssued': instance.rewardsIssued,
    };
