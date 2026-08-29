import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:cafe_app/core/l10n/locale_providers.dart';
import 'package:cafe_app/l10n/app_localizations.dart';

/// 화면을 직접 띄우는 테스트는 앱의 `MaterialApp`을 거치지 않으므로 delegate가
/// 붙지 않는다. 그대로 두면 `AppLocalizations.of`가 값을 찾지 못해 화면이
/// 그려지기 전에 터진다. 테스트가 만드는 `MaterialApp`에 이 둘을 넘긴다.
const testLocalizationsDelegates = <LocalizationsDelegate<dynamic>>[
  AppLocalizations.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

const testSupportedLocales = supportedLocales;

/// 테스트는 기본 로케일이 en이라 그대로 두면 화면이 영어로 그려진다. 골든과
/// 문자열 검사는 한국어 화면을 보고 쓴 것이므로 한국어로 못 박는다. 영어 화면을
/// 보려는 테스트는 이 값 대신 `Locale('en')`을 넘긴다.
const testLocale = Locale('ko');
