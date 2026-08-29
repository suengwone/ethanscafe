import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _localeKey = 'locale';

/// 앱이 지원하는 언어. 첫 번째가 기본값이고, 기기 언어가 이 목록에 없으면
/// Flutter가 첫 번째를 고른다.
const supportedLocales = [Locale('ko'), Locale('en')];

/// 앱을 켤 때 미리 읽어 둔 저장값. 첫 프레임이 저장된 언어와 다른 말로 잠깐
/// 그려지지 않도록 `main`에서 override 한다. null이면 기기 설정을 따른다.
final storedLocaleProvider = Provider<Locale?>((ref) => null);

Locale? decodeLocale(String? code) {
  if (code == null || code.isEmpty) {
    return null;
  }
  for (final locale in supportedLocales) {
    if (locale.languageCode == code) {
      return locale;
    }
  }
  return null;
}

Future<Locale?> loadStoredLocale() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    return decodeLocale(prefs.getString(_localeKey));
  } catch (_) {
    return null;
  }
}

final localeProvider = NotifierProvider<LocaleController, Locale?>(
  LocaleController.new,
);

class LocaleController extends Notifier<Locale?> {
  @override
  Locale? build() => ref.watch(storedLocaleProvider);

  /// [locale]이 null이면 기기 설정을 따른다.
  Future<void> select(Locale? locale) async {
    state = locale;
    try {
      final prefs = await SharedPreferences.getInstance();
      if (locale == null) {
        await prefs.remove(_localeKey);
      } else {
        await prefs.setString(_localeKey, locale.languageCode);
      }
    } catch (_) {
      // 저장에 실패해도 이번 실행에서는 고른 언어를 그대로 쓴다.
    }
  }
}

/// 언어 이름은 그 언어로 적는다. 한국어 화면에서 'English'를 '영어'로 옮겨
/// 적으면, 정작 영어만 읽는 사람이 자기 언어를 찾지 못한다.
String localeName(Locale locale) => switch (locale.languageCode) {
  'ko' => '한국어',
  'en' => 'English',
  _ => locale.languageCode,
};
