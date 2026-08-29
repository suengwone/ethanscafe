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

  @override
  String priceWon(String amount) {
    return '₩$amount';
  }

  @override
  String priceWonFrom(String amount) {
    return 'From ₩$amount';
  }

  @override
  String get retry => 'Try again';

  @override
  String get menuCategoryDrip => 'Drip coffee';

  @override
  String get menuCategoryDripNote =>
      'Nine single origins · a seasonal collection that changes weekly';

  @override
  String get menuCategoryEspresso => 'Espresso';

  @override
  String get menuCategoryEspressoNote =>
      'Milk swap oat, almond, soy +0.5 · lactose-free, low-fat +0.3\nSyrup vanilla, caramel, hazelnut, lavender +0.3';

  @override
  String get menuCategoryBeverage => 'Drinks';

  @override
  String get menuCategoryBeverageNote =>
      'Extra shot strawberry latte, Valrhona chocolate latte, matcha latte, peach iced tea +0.5';

  @override
  String get menuCategoryTea => 'Tea';

  @override
  String get menuCategoryTeaNote => 'The Tavalon premium tea collection';

  @override
  String get menuCategoryDessert => 'Desserts';

  @override
  String get menuCategoryBeans => 'Beans';

  @override
  String get menuTitle => 'Menu';

  @override
  String get menuLoadFailed => 'Could not load the menu.';

  @override
  String get menuDetailTitle => 'Menu item';

  @override
  String get menuOrderRequiresSignIn => 'Sign in to order from the menu.';

  @override
  String menuAddedToCart(String name) {
    return '$name is in your cart.';
  }

  @override
  String get menuViewCart => 'View';

  @override
  String get menuSoldOutNotice => 'We ran out of what this needs today';

  @override
  String get menuPickupOrder => 'Pick up in store';

  @override
  String get menuSoldOut => 'Sold out';

  @override
  String get menuOrder => 'Order';

  @override
  String get menuFavoriteAdd => 'Add to favorites';

  @override
  String get menuFavoriteRemove => 'Remove from favorites';

  @override
  String get menuFavoriteAdded => 'Added to your favorites.';

  @override
  String get menuFavoriteRemoved => 'Removed from your favorites.';

  @override
  String get menuSectionAbout => 'About this item';

  @override
  String get menuSectionOptions => 'Options';

  @override
  String get menuSectionDetails => 'Details';

  @override
  String get menuFieldCategory => 'Category';

  @override
  String get menuFieldPrice => 'Price';

  @override
  String get menuFieldServingOptions => 'Served as';

  @override
  String menuNotFound(String menuId) {
    return 'Menu item not found: $menuId';
  }

  @override
  String get favoriteMenuTitle => 'Favorite items';

  @override
  String get favoriteMenuLoadFailed => 'Could not load your favorites.';

  @override
  String get favoriteMenuEmptyTitle => 'No favorites yet';

  @override
  String get favoriteMenuEmptyDetail =>
      'Tap the heart on a menu item to keep the ones you drink often.';

  @override
  String get favoriteMenuBrowse => 'Browse the menu';

  @override
  String get noticeCategoryEvent => 'Event';

  @override
  String get noticeCategoryNotice => 'Notice';

  @override
  String get noticeCategoryBenefit => 'Perk';

  @override
  String get noticeListTitle => 'Notifications';

  @override
  String get noticeLoadFailed => 'Could not load your notifications.';

  @override
  String get noticeEmpty => 'Nothing new';

  @override
  String get noticeImportant => 'Important';

  @override
  String get reviewProductTypeMenu => 'Menu item';

  @override
  String get reviewProductTypeBean => 'Beans';

  @override
  String reviewSheetTitle(String product) {
    return 'Review this $product';
  }

  @override
  String get reviewSheetHint => 'How did it taste and smell? Tell us about it.';

  @override
  String get reviewSubmitting => 'Posting…';

  @override
  String get reviewSubmit => 'Post review';

  @override
  String get reviewSubmitted => 'Thanks — your review is posted.';

  @override
  String get reviewSubmitFailed => 'Could not post your review. Try again.';

  @override
  String get reviewSectionTitle => 'Reviews';

  @override
  String get reviewLoadFailed => 'Could not load the reviews.';

  @override
  String reviewMoreCount(int count) {
    return 'and $count more reviews.';
  }

  @override
  String get reviewEmpty =>
      'No reviews yet. Leave the first one from your order history.';

  @override
  String reviewRatingOutOfRange(int min, int max) {
    return 'The rating must be between $min and $max.';
  }

  @override
  String get congestionUnknown => 'No data';

  @override
  String get congestionRelaxed => 'Quiet';

  @override
  String get congestionNormal => 'Steady';

  @override
  String get congestionBusy => 'Busy';

  @override
  String get paymentTitle => 'Payment';

  @override
  String get paymentApproving => 'Approving payment…';

  @override
  String get paymentCheckFailed =>
      'Could not confirm the payment details. Try again.';

  @override
  String get paymentApproveFailed => 'The payment was not approved. Try again.';

  @override
  String get paymentFailed => 'The payment failed. Try again.';

  @override
  String get paymentProviderNotice => 'Secured by Toss Payments';

  @override
  String storeCongestionNow(String congestion) {
    return '$congestion right now';
  }
}
