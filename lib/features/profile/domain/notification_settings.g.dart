// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationSettings _$NotificationSettingsFromJson(
  Map<String, dynamic> json,
) => _NotificationSettings(
  pushEnabled: json['pushEnabled'] as bool? ?? true,
  eventEnabled: json['eventEnabled'] as bool? ?? true,
  pointsEnabled: json['pointsEnabled'] as bool? ?? true,
  marketingEnabled: json['marketingEnabled'] as bool? ?? false,
);

Map<String, dynamic> _$NotificationSettingsToJson(
  _NotificationSettings instance,
) => <String, dynamic>{
  'pushEnabled': instance.pushEnabled,
  'eventEnabled': instance.eventEnabled,
  'pointsEnabled': instance.pointsEnabled,
  'marketingEnabled': instance.marketingEnabled,
};
