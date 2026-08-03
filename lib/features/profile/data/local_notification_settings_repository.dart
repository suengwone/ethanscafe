import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/notification_settings.dart';

class LocalNotificationSettingsRepository
    implements NotificationSettingsRepository {
  static const _storageKey = 'notification_settings';

  @override
  Future<NotificationSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null) {
      return const NotificationSettings();
    }
    return NotificationSettings.fromJson(
      jsonDecode(raw) as Map<String, dynamic>,
    );
  }

  @override
  Future<void> save(NotificationSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(settings.toJson()));
  }
}
