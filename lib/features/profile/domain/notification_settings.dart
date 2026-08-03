import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_settings.freezed.dart';
part 'notification_settings.g.dart';

@freezed
abstract class NotificationSettings with _$NotificationSettings {
  const factory NotificationSettings({
    @Default(true) bool pushEnabled,
    @Default(true) bool eventEnabled,
    @Default(true) bool pointsEnabled,
    @Default(false) bool marketingEnabled,
  }) = _NotificationSettings;

  factory NotificationSettings.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsFromJson(json);
}

abstract class NotificationSettingsRepository {
  Future<NotificationSettings> load();

  Future<void> save(NotificationSettings settings);
}
