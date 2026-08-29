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

  @override
  String get authSignIn => 'Sign in';

  @override
  String get authSignedIn => 'You are signed in.';

  @override
  String get authSignInWithKakao => 'Continue with Kakao';

  @override
  String get authSignInWithNaver => 'Continue with Naver';

  @override
  String get authSignInWithGoogle => 'Continue with Google';

  @override
  String get authSignInLater => 'Maybe later';

  @override
  String get businessAccountTitle => 'Business account';

  @override
  String get businessMissingFields =>
      'Enter the company name and the business number.';

  @override
  String get businessNumberInvalid =>
      'Check the 10-digit business number again.';

  @override
  String get businessSwitched =>
      'Switched to a business account. Opening the wholesale home.';

  @override
  String businessSwitchFailed(String error) {
    return 'Could not switch to a business account: $error';
  }

  @override
  String get businessSwitchFailedRetry =>
      'Could not switch to a business account. Try again.';

  @override
  String get businessSwitchedBack => 'Switched back to a personal account.';

  @override
  String get businessIntro =>
      'A business account turns the home tab into the wholesale view, where you can request quotes at per-kilogram trade prices.';

  @override
  String get businessSectionInfo => 'Business details';

  @override
  String get businessFieldCompany => 'Company name *';

  @override
  String get businessFieldCompanyHint => 'e.g. Cafe Around';

  @override
  String get businessFieldNumber => 'Business number *';

  @override
  String get businessFieldManager => 'Contact name';

  @override
  String get businessFieldPhone => 'Phone';

  @override
  String get businessSwitchAction => 'Switch to a business account';

  @override
  String get businessSavedTitle => 'Saved business details';

  @override
  String get businessSavedIntro =>
      'You already registered business details. You can switch over without entering them again.';

  @override
  String get businessSavedSwitch => 'Switch to a business account';

  @override
  String get businessSavedEdit => 'Edit business details';

  @override
  String get businessLabelCompany => 'Company name';

  @override
  String get businessLabelNumber => 'Business number';

  @override
  String get businessLabelManager => 'Contact name';

  @override
  String get businessLabelPhone => 'Phone';

  @override
  String get businessActiveTitle => 'Business account active';

  @override
  String get businessActiveDescription =>
      'The home tab shows wholesale bean prices and lets you request a quote.';

  @override
  String get businessSwitchBackAction => 'Switch back to a personal account';
}
