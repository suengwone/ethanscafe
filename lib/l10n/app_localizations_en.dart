// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Foxtrot';

  @override
  String get settingsAppearanceTitle => 'Theme';

  @override
  String get settingsAppearanceThemeSection => 'Choose a theme';

  @override
  String get settingsAppearanceStoredOnThisDevice =>
      'Your choice is saved on this device only. Pick it again on another device.';

  @override
  String get settingsAppearancePreview => 'Preview';

  @override
  String get settingsAppearancePreviewRewards => 'Foxtrot Rewards';

  @override
  String get settingsAppearancePreviewBalance => '32,250P available';

  @override
  String get settingsAppearancePreviewOrder => 'Order';

  @override
  String get settingsAppearancePreviewCart => 'Cart';

  @override
  String get themeModeSystem => 'System setting';

  @override
  String get themeModeSystemDescription => 'Follows your device setting';

  @override
  String get themeModeLight => 'Light';

  @override
  String get themeModeLightDescription => 'Always use the light background';

  @override
  String get themeModeDark => 'Dark';

  @override
  String get themeModeDarkDescription => 'Always use the dark background';

  @override
  String get settingsLanguageTitle => 'Language';

  @override
  String get settingsLanguageSection => 'Choose a language';

  @override
  String get settingsLanguageSystem => 'System setting';

  @override
  String get settingsLanguageSystemDescription =>
      'Follows your device language';

  @override
  String get settingsLanguageStoredOnThisDevice =>
      'Your choice is saved on this device only. Pick it again on another device.';

  @override
  String get settingsLanguageUnsupportedNotice =>
      'Text the store enters itself, such as menu names and store notices, appears in the language it was written in.';

  @override
  String get homeGreetingGuestName => 'there';

  @override
  String homeGreetingMember(String name) {
    return 'Hello, $name!\nGood to see you.';
  }

  @override
  String get homeGreetingVisitor => 'Welcome to\nFoxtrot!';

  @override
  String get homeGreetingSubtitle =>
      'Take a moment today over a good cup of coffee';

  @override
  String get homeFindStore => 'Find a store';

  @override
  String get homeNotifications => 'Notifications';

  @override
  String get homeSignIn => 'Sign in';

  @override
  String get homeQuickOrder => 'Order';

  @override
  String get homeQuickCoupons => 'Coupons';

  @override
  String get homeQuickOrderHistory => 'Orders';

  @override
  String get homeQuickStores => 'Stores';

  @override
  String get homeRecommendedTitle => 'How about these?';

  @override
  String get homeSeeAll => 'See all';

  @override
  String get homeRewardsTitle => 'Foxtrot Rewards';

  @override
  String get homeRewardsMineTitle => 'My rewards';

  @override
  String get homeRewardsSignInPrompt => 'Sign in and\nstart earning points';

  @override
  String homeRewardsSignInDetail(String goal) {
    return 'Earn 10% of what you pay, and get a free drink coupon at ${goal}P.';
  }

  @override
  String get homeRewardsSignInAction => 'Sign in';

  @override
  String homeRewardsBalance(String balance) {
    return '${balance}P';
  }

  @override
  String homeRewardsRemaining(String remaining) {
    return '${remaining}P more for a free drink coupon!';
  }

  @override
  String get homeRewardsGoalReached =>
      'You can trade this for a free drink coupon!';

  @override
  String get bannerIconSparkles => 'Sparkles';

  @override
  String get bannerIconSnowflake => 'Snowflake';

  @override
  String get bannerIconBean => 'Bean';

  @override
  String get bannerIconGift => 'Gift';
}
