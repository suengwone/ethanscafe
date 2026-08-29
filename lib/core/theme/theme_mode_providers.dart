import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../l10n/app_localizations.dart';

const _themeModeKey = 'theme_mode';

/// 앱을 켤 때 미리 읽어 둔 저장값. 첫 프레임이 저장된 테마와 다른 색으로
/// 잠깐 그려지지 않도록 `main`에서 override 한다.
final storedThemeModeProvider = Provider<ThemeMode>((ref) => ThemeMode.system);

ThemeMode decodeThemeMode(String? name) {
  return ThemeMode.values.firstWhere(
    (mode) => mode.name == name,
    orElse: () => ThemeMode.system,
  );
}

Future<ThemeMode> loadStoredThemeMode() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    return decodeThemeMode(prefs.getString(_themeModeKey));
  } catch (_) {
    return ThemeMode.system;
  }
}

final themeModeProvider = NotifierProvider<ThemeModeController, ThemeMode>(
  ThemeModeController.new,
);

class ThemeModeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ref.watch(storedThemeModeProvider);

  Future<void> select(ThemeMode mode) async {
    state = mode;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeModeKey, mode.name);
    } catch (_) {
      // 저장에 실패해도 이번 실행에서는 고른 테마를 그대로 쓴다.
    }
  }
}

extension ThemeModeLabels on AppLocalizations {
  String themeModeLabel(ThemeMode mode) => switch (mode) {
    ThemeMode.system => themeModeSystem,
    ThemeMode.light => themeModeLight,
    ThemeMode.dark => themeModeDark,
  };

  String themeModeDescription(ThemeMode mode) => switch (mode) {
    ThemeMode.system => themeModeSystemDescription,
    ThemeMode.light => themeModeLightDescription,
    ThemeMode.dark => themeModeDarkDescription,
  };
}
