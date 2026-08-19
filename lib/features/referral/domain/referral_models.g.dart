// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'referral_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReferralSummary _$ReferralSummaryFromJson(Map<String, dynamic> json) =>
    _ReferralSummary(
      code: json['code'] as String,
      invitedCount: (json['invitedCount'] as num?)?.toInt() ?? 0,
      earnedPoints: (json['earnedPoints'] as num?)?.toInt() ?? 0,
      redeemedCode: json['redeemedCode'] as String?,
      reward: (json['reward'] as num?)?.toInt() ?? referralRewardPoints,
      inviteLimit:
          (json['inviteLimit'] as num?)?.toInt() ?? referralInviteLimit,
    );

Map<String, dynamic> _$ReferralSummaryToJson(_ReferralSummary instance) =>
    <String, dynamic>{
      'code': instance.code,
      'invitedCount': instance.invitedCount,
      'earnedPoints': instance.earnedPoints,
      'redeemedCode': instance.redeemedCode,
      'reward': instance.reward,
      'inviteLimit': instance.inviteLimit,
    };

_ReferralRedeemResult _$ReferralRedeemResultFromJson(
  Map<String, dynamic> json,
) => _ReferralRedeemResult(
  code: json['code'] as String,
  reward: (json['reward'] as num).toInt(),
  balance: (json['balance'] as num).toInt(),
  summary: ReferralSummary.fromJson(json['summary'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ReferralRedeemResultToJson(
  _ReferralRedeemResult instance,
) => <String, dynamic>{
  'code': instance.code,
  'reward': instance.reward,
  'balance': instance.balance,
  'summary': instance.summary,
};
