import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko'),
  ];

  /// 앱 이름. 작업 전환기와 브라우저 탭에 보인다
  ///
  /// In ko, this message translates to:
  /// **'폭스트롯'**
  String get appTitle;

  /// No description provided for @settingsAppearanceTitle.
  ///
  /// In ko, this message translates to:
  /// **'화면 테마'**
  String get settingsAppearanceTitle;

  /// No description provided for @settingsAppearanceThemeSection.
  ///
  /// In ko, this message translates to:
  /// **'테마 선택'**
  String get settingsAppearanceThemeSection;

  /// No description provided for @settingsAppearanceStoredOnThisDevice.
  ///
  /// In ko, this message translates to:
  /// **'고른 테마는 이 기기에만 저장됩니다. 다른 기기에서는 다시 골라 주세요.'**
  String get settingsAppearanceStoredOnThisDevice;

  /// No description provided for @settingsAppearancePreview.
  ///
  /// In ko, this message translates to:
  /// **'미리보기'**
  String get settingsAppearancePreview;

  /// No description provided for @settingsAppearancePreviewRewards.
  ///
  /// In ko, this message translates to:
  /// **'폭스트롯 리워드'**
  String get settingsAppearancePreviewRewards;

  /// No description provided for @settingsAppearancePreviewBalance.
  ///
  /// In ko, this message translates to:
  /// **'보유 포인트 32,250P'**
  String get settingsAppearancePreviewBalance;

  /// No description provided for @settingsAppearancePreviewOrder.
  ///
  /// In ko, this message translates to:
  /// **'주문하기'**
  String get settingsAppearancePreviewOrder;

  /// No description provided for @settingsAppearancePreviewCart.
  ///
  /// In ko, this message translates to:
  /// **'장바구니'**
  String get settingsAppearancePreviewCart;

  /// No description provided for @themeModeSystem.
  ///
  /// In ko, this message translates to:
  /// **'시스템 설정'**
  String get themeModeSystem;

  /// No description provided for @themeModeSystemDescription.
  ///
  /// In ko, this message translates to:
  /// **'기기 설정을 따라 자동으로 바뀝니다'**
  String get themeModeSystemDescription;

  /// No description provided for @themeModeLight.
  ///
  /// In ko, this message translates to:
  /// **'라이트'**
  String get themeModeLight;

  /// No description provided for @themeModeLightDescription.
  ///
  /// In ko, this message translates to:
  /// **'밝은 배경으로 고정합니다'**
  String get themeModeLightDescription;

  /// No description provided for @themeModeDark.
  ///
  /// In ko, this message translates to:
  /// **'다크'**
  String get themeModeDark;

  /// No description provided for @themeModeDarkDescription.
  ///
  /// In ko, this message translates to:
  /// **'어두운 배경으로 고정합니다'**
  String get themeModeDarkDescription;

  /// No description provided for @settingsLanguageTitle.
  ///
  /// In ko, this message translates to:
  /// **'언어'**
  String get settingsLanguageTitle;

  /// No description provided for @settingsLanguageSection.
  ///
  /// In ko, this message translates to:
  /// **'언어 선택'**
  String get settingsLanguageSection;

  /// No description provided for @settingsLanguageSystem.
  ///
  /// In ko, this message translates to:
  /// **'시스템 설정'**
  String get settingsLanguageSystem;

  /// No description provided for @settingsLanguageSystemDescription.
  ///
  /// In ko, this message translates to:
  /// **'기기 언어를 따릅니다'**
  String get settingsLanguageSystemDescription;

  /// No description provided for @settingsLanguageStoredOnThisDevice.
  ///
  /// In ko, this message translates to:
  /// **'고른 언어는 이 기기에만 저장됩니다. 다른 기기에서는 다시 골라 주세요.'**
  String get settingsLanguageStoredOnThisDevice;

  /// No description provided for @settingsLanguageUnsupportedNotice.
  ///
  /// In ko, this message translates to:
  /// **'메뉴 이름과 매장 안내처럼 매장이 직접 올리는 글은 등록된 언어 그대로 보입니다.'**
  String get settingsLanguageUnsupportedNotice;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
