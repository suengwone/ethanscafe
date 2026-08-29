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
  String get menuFieldPrice => 'Price (₩)';

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

  @override
  String storeCallFailed(String phone) {
    return 'Could not place the call: $phone';
  }

  @override
  String get storeMapFailed => 'Could not open the map.';

  @override
  String get storeOpenNow => 'Open';

  @override
  String get storeClosedNow => 'Closed';

  @override
  String get storeCall => 'Call';

  @override
  String get storeOpenMap => 'Open map';

  @override
  String get storeListTitle => 'Find a store';

  @override
  String get storeLocationUnavailable => 'Could not find your location.';

  @override
  String get storeSortByDistance => 'Sort by distance';

  @override
  String get storeLoadFailed => 'Could not load the stores.';

  @override
  String get storeSortHint =>
      'Tap the button at the top right to sort by how close each store is.';

  @override
  String get storeSortedByDistance => 'Sorted by distance from you.';

  @override
  String storeHoursSummary(String weekday, String weekend) {
    return 'Weekdays $weekday · Weekends $weekend';
  }

  @override
  String get storeDetailTitle => 'Store';

  @override
  String get storeNotFound => 'This store is closed or does not exist.';

  @override
  String storeDistanceFromYou(String distance) {
    return '$distance from you';
  }

  @override
  String storeCongestionMeasured(int count) {
    return 'Measured from $count orders in progress.';
  }

  @override
  String get storeHoursUnknown => 'No opening hours listed.';

  @override
  String storeHoursToday(String hours) {
    return 'Today $hours';
  }

  @override
  String get storeSectionHours => 'Opening hours';

  @override
  String get storeHoursWeekday => 'Weekdays';

  @override
  String get storeHoursWeekend => 'Weekends';

  @override
  String get storeSectionFacilities => 'Facilities';

  @override
  String get storeNoticeTitle => 'Store notice';

  @override
  String get storeNoInfo => 'Not listed';

  @override
  String get storeLocationServiceOff =>
      'Location services are off. Turn them on in Settings.';

  @override
  String get storeLocationPermissionDenied =>
      'Without location access we cannot work out the distance.';

  @override
  String get roastLight => 'Light';

  @override
  String get roastMediumLight => 'Medium light';

  @override
  String get roastMedium => 'Medium';

  @override
  String get roastMediumDark => 'Medium dark';

  @override
  String get roastDark => 'Dark';

  @override
  String get grindWholeBean => 'Whole bean';

  @override
  String get grindWholeBeanNote => 'Left unground';

  @override
  String get grindEspresso => 'Espresso';

  @override
  String get grindEspressoNote => 'For a home espresso machine';

  @override
  String get grindMokaPot => 'Moka pot';

  @override
  String get grindMokaPotNote => 'For a moka pot';

  @override
  String get grindHandDrip => 'Hand drip';

  @override
  String get grindHandDripNote => 'For pour-over and drippers';

  @override
  String get grindFrenchPress => 'French press';

  @override
  String get grindFrenchPressNote => 'For immersion brewing';

  @override
  String get subscriptionCycleWeekly => 'Weekly';

  @override
  String get subscriptionCycleBiweekly => 'Every two weeks';

  @override
  String get subscriptionCycleMonthly => 'Monthly';

  @override
  String get subscriptionStatusActive => 'Active';

  @override
  String get subscriptionStatusPaused => 'Paused';

  @override
  String get subscriptionStatusCancelled => 'Cancelled';

  @override
  String get beanOrderStatusReceived => 'Order received';

  @override
  String get beanOrderStatusRoasting => 'Roasting';

  @override
  String get beanOrderStatusShipped => 'Shipped';

  @override
  String get beanOrderStatusDelivered => 'Delivered';

  @override
  String get beanOrderStatusReady => 'Ready for pickup';

  @override
  String get beanOrderStatusPickedUp => 'Picked up';

  @override
  String get beanOrderStatusCancelled => 'Cancelled';

  @override
  String get fulfillmentDelivery => 'Delivery';

  @override
  String get fulfillmentPickup => 'Store pickup';

  @override
  String get pickupStatusReceived => 'Order received';

  @override
  String get pickupStatusPreparing => 'Making it';

  @override
  String get pickupStatusReady => 'Ready for pickup';

  @override
  String get pickupStatusPickedUp => 'Picked up';

  @override
  String get pickupStatusCancelled => 'Cancelled';

  @override
  String get refundStatusPending => 'Refund in progress';

  @override
  String get refundStatusDone => 'Refunded';

  @override
  String get refundStatusFailed => 'Checking the refund';

  @override
  String get wholesaleStatusRequested => 'Reviewing your request';

  @override
  String get wholesaleStatusQuoted => 'Quote sent';

  @override
  String get wholesaleStatusConfirmed => 'Order confirmed';

  @override
  String orderItemsSummary(String first, int others) {
    return '$first and $others more';
  }

  @override
  String get orderTypePickup => 'Pickup';

  @override
  String get orderTypeBean => 'Beans';

  @override
  String get orderRecipientUnset => 'No recipient';

  @override
  String get orderStoreUnset => 'No store';

  @override
  String beanOptionLabel(String weight, String grind) {
    return '$weight · $grind';
  }

  @override
  String beanQuantity(String name, int count) {
    return '$name ×$count';
  }

  @override
  String subscriptionCycleQuantity(String cycle, int count) {
    return '$cycle, ×$count';
  }

  @override
  String get beansLoadFailed => 'Could not load the beans.';

  @override
  String get beansFilterAcidic => 'Bright and fruity';

  @override
  String get beansFilterAcidicNote => 'If you like a light, fruity cup';

  @override
  String get beansFilterMellow => 'Low acidity, nutty';

  @override
  String get beansFilterMellowNote =>
      'If you want something round and full with little acidity';

  @override
  String get beansFilterDecaf => 'Decaf';

  @override
  String get beansFilterDecafNote => 'For late afternoons';

  @override
  String beansCartCount(int count) {
    return 'Cart · $count';
  }

  @override
  String get beansRoastNotice =>
      'We roast every Tuesday and ship whole bean or ground to your grind.';

  @override
  String beansRoastOf(String origin, String roast) {
    return '$origin · $roast roast';
  }

  @override
  String get beansPricePer200g => 'For 200g';

  @override
  String beanNotFound(String beanId) {
    return 'Bean not found: $beanId';
  }

  @override
  String get beanCartTitle => 'Bean cart';

  @override
  String get beanCartEmptyTitle => 'Your cart is empty';

  @override
  String get beanCartEmptyDetail => 'Add a bean you like the look of.';

  @override
  String get beanCartBrowse => 'Browse the beans';

  @override
  String get beanCartFulfillment => 'How to receive it';

  @override
  String get beanCartNoAddress => 'No address saved yet. Add one to continue.';

  @override
  String get beanCartAddAddress => 'Add an address';

  @override
  String get beanCartChange => 'Change';

  @override
  String get beanCartNoStore => 'Choose a store to pick the beans up from.';

  @override
  String get beanCartChooseStore => 'Choose a store';

  @override
  String get beanCartAddressSheetTitle => 'Choose an address';

  @override
  String get beanCartAddressSheetDetail => 'Where should the beans go?';

  @override
  String get beanCartAddressLoadFailed => 'Could not load your addresses.';

  @override
  String get beanCartManageAddresses => 'Manage addresses';

  @override
  String get beanCartClose => 'Close';

  @override
  String get beanCartDefaultAddress => 'Default address';

  @override
  String get beanCartStoreSheetTitle => 'Choose a pickup store';

  @override
  String get beanCartStoreSheetDetail =>
      'Once roasting is done you can collect from the store you pick.';

  @override
  String get beanCartStoreLoadFailed => 'Could not load the stores.';

  @override
  String beanCartRemoved(String name) {
    return 'Removed $name from your cart.';
  }

  @override
  String get beanCartUndo => 'Undo';

  @override
  String get beanCartDelete => 'Remove';

  @override
  String get beanCartNeedAddress => 'Add an address first.';

  @override
  String get beanCartNeedStore => 'Choose a pickup store first.';

  @override
  String get beanCartPaymentIncomplete => 'The payment did not go through.';

  @override
  String beanCartOrderedWithPoints(String points) {
    return 'Your bean order is in. You earned ${points}P.';
  }

  @override
  String get beanCartOrderedPickup =>
      'Your bean order is in. Collect it from the store once it is roasted.';

  @override
  String get beanCartOrderedDelivery =>
      'Your bean order is in. It ships once it is roasted.';

  @override
  String get beanCartOrderFailed => 'Could not place the order. Try again.';

  @override
  String beanCartCouponsApplied(int count) {
    return '$count coupons applied';
  }

  @override
  String get beanCartNoUsableCoupons => 'No coupons apply here';

  @override
  String beanCartUsableCoupons(int count) {
    return '$count coupons available';
  }

  @override
  String get beanCartChooseCoupon => 'Choose a coupon';

  @override
  String beanCartUsePoints(String balance) {
    return 'Use points (${balance}P available)';
  }

  @override
  String get beanCartNoPoints => 'No points available';

  @override
  String beanCartItemCount(int count) {
    return '$count items';
  }

  @override
  String get beanCartOrdering => 'Placing the order…';

  @override
  String get beanCartPay => 'Pay';

  @override
  String get beanCartOrder => 'Place order';

  @override
  String discountAmount(String amount) {
    return '-₩$amount';
  }

  @override
  String get beanDetailTitle => 'Bean';

  @override
  String beanRoastBadge(String roast) {
    return '$roast roast';
  }

  @override
  String get beanSectionNotes => 'Tasting notes';

  @override
  String get beanSectionProfile => 'Flavour profile';

  @override
  String get beanProfileAcidity => 'Acidity';

  @override
  String get beanProfileBody => 'Body';

  @override
  String get beanProfileSweetness => 'Sweetness';

  @override
  String get beanSectionStory => 'The story';

  @override
  String get beanSectionDetails => 'Details';

  @override
  String get beanFieldOrigin => 'Origin';

  @override
  String get beanFieldProcess => 'Process';

  @override
  String get beanFieldRoast => 'Roast';

  @override
  String get beanFieldBrews => 'Brew with';

  @override
  String get beanFieldPrice => 'Price';

  @override
  String beanPriceBoth(String price200, String price500) {
    return '200g ₩$price200 · 500g ₩$price500';
  }

  @override
  String get beanCartTooltip => 'Bean cart';

  @override
  String get beanGiftTooltip => 'Send as a gift';

  @override
  String get beanSubscribe => 'Subscribe';

  @override
  String get beanSoldOut => 'Sold out';

  @override
  String get beanOrder => 'Order';

  @override
  String get beanGiftRequiresSignIn => 'Sign in to send beans as a gift.';

  @override
  String get beanOrderRequiresSignIn => 'Sign in to order beans.';

  @override
  String beanAddedToCart(String name) {
    return '$name is in your cart.';
  }

  @override
  String get beanViewCart => 'View';

  @override
  String get beanFieldWeight => 'Size';

  @override
  String get beanFieldGrind => 'Grind';

  @override
  String get beanFieldQuantity => 'Quantity';

  @override
  String get beanTotalPrice => 'Total';

  @override
  String get beanAddToCart => 'Add to cart';

  @override
  String beanOrderForAmount(String amount) {
    return 'Order for ₩$amount';
  }

  @override
  String get subscriptionRequiresSignIn => 'Sign in to subscribe to beans.';

  @override
  String subscriptionStarted(String bean, String cycle) {
    return 'Your $cycle subscription to $bean has started.';
  }

  @override
  String get subscriptionManage => 'Manage';

  @override
  String get subscriptionTitle => 'Bean subscription';

  @override
  String get subscriptionFieldCycle => 'How often';

  @override
  String get subscriptionFieldQuantity => 'Bags per delivery';

  @override
  String get subscriptionFieldPrice => 'Charged per delivery';

  @override
  String subscriptionNotice(String cycle) {
    return 'We roast and ship $cycle. Pause or cancel whenever you like.';
  }

  @override
  String subscriptionStart(String cycle) {
    return 'Start a $cycle subscription';
  }

  @override
  String subscriptionEveryDays(int days) {
    return 'Every $days days';
  }

  @override
  String get subscriptionListTitle => 'Bean subscriptions';

  @override
  String get subscriptionLoadFailed => 'Could not load your subscriptions.';

  @override
  String get subscriptionEmptyTitle => 'No subscriptions yet';

  @override
  String get subscriptionEmptyDetail =>
      'Start one from a bean\'s page and we will ship on your schedule.';

  @override
  String get subscriptionBrowse => 'Browse the beans';

  @override
  String get subscriptionCancelTitle => 'Cancel subscription';

  @override
  String subscriptionCancelConfirm(String bean) {
    return 'Cancel your $bean subscription?\nDeliveries stop after that.';
  }

  @override
  String subscriptionCancelled(String bean) {
    return 'Your $bean subscription is cancelled.';
  }

  @override
  String subscriptionStartedOn(String date) {
    return 'Started $date';
  }

  @override
  String subscriptionNextDelivery(String date) {
    return 'Next delivery $date';
  }

  @override
  String subscriptionPricePerDelivery(String amount) {
    return '₩$amount per delivery';
  }

  @override
  String get subscriptionResume => 'Resume';

  @override
  String get subscriptionPause => 'Pause';

  @override
  String get subscriptionCancelAction => 'Cancel';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get adminOrdersTitle => 'Orders';

  @override
  String get adminOrdersRefresh => 'Refresh';

  @override
  String get adminOrdersTabRefundFailed => 'Failed refunds';

  @override
  String get adminOrdersNoPickup => 'No pickup orders to work on.';

  @override
  String get adminOrdersNoBean => 'No bean orders to work on.';

  @override
  String get adminOrdersNoRefundFailures => 'No refunds are stuck.';

  @override
  String get adminOrdersRefunded => 'Refunded.';

  @override
  String adminOrdersRefundFailed(String error) {
    return 'The refund failed: $error';
  }

  @override
  String adminOrdersRefundFailedLabel(String type) {
    return '$type · refund failed';
  }

  @override
  String get adminOrdersRetryRefund => 'Retry the refund';

  @override
  String get adminOrdersAdvanceFailed => 'Could not change the status';

  @override
  String get adminOrdersCancelTitle => 'Cancel this order?';

  @override
  String adminOrdersCancelBody(String summary) {
    return 'This cancels $summary. Points and coupons go back, and the payment is refunded.';
  }

  @override
  String get adminOrdersCancelFailed => 'Could not cancel the order';

  @override
  String get adminOrdersCancelAction => 'Cancel the order';

  @override
  String adminOrdersAdvanceTo(String status) {
    return 'Move to $status';
  }

  @override
  String get adminOrdersLoadFailed => 'Could not load the orders.';

  @override
  String get commonClose => 'Close';

  @override
  String get orderHistoryTitle => 'Order history';

  @override
  String get orderHistoryLoadFailed => 'Could not load your orders.';

  @override
  String get orderHistoryEmptyTitle => 'No orders yet';

  @override
  String get orderHistoryEmptyDetail =>
      'Pay in store or place a pickup or bean order and it shows up here.';

  @override
  String orderCouponDiscount(String amount) {
    return 'Coupon -₩$amount';
  }

  @override
  String orderPointsUsed(String amount) {
    return '-${amount}P used';
  }

  @override
  String orderPointsEarned(String amount) {
    return '+${amount}P earned';
  }

  @override
  String get orderBeanLabel => 'Bean order';

  @override
  String orderItemCount(int count) {
    return '$count items';
  }

  @override
  String get orderReorder => 'Order again';

  @override
  String get orderCancel => 'Cancel order';

  @override
  String get orderReorderUnavailableBeans =>
      'These beans are no longer sold, so we cannot reorder them.';

  @override
  String get orderReorderUnavailableMenu =>
      'This item is no longer on the menu, so we cannot reorder it.';

  @override
  String orderReorderPartialBeans(String names) {
    return 'Added everything except $names, which we no longer sell.';
  }

  @override
  String orderReorderPartialMenu(String names) {
    return 'Added everything except $names, which is off the menu.';
  }

  @override
  String get orderReorderDone => 'Your previous order is back in the cart.';

  @override
  String get orderCancelBeanTitle => 'Cancel this bean order?';

  @override
  String get orderCancelledNotice =>
      'The order is cancelled. Your coupons and points come back.';

  @override
  String orderPickupSummary(String store, int number, int count) {
    return 'Pickup · $store · order #$number · $count items';
  }

  @override
  String get orderTrackStatus => 'Track this order';

  @override
  String get orderWriteReview => 'Write a review';

  @override
  String get pickupOptionTitle => 'Options';

  @override
  String get pickupTotalPrice => 'Order total';

  @override
  String get pickupAddToCart => 'Add to cart';

  @override
  String get pickupCartTitle => 'Pickup order';

  @override
  String get pickupCartRequiresSignIn => 'Sign in to use the cart.';

  @override
  String get pickupCartTooltip => 'Pickup cart';

  @override
  String get pickupCartEmptyTitle => 'Your cart is empty';

  @override
  String get pickupCartEmptyDetail => 'Add something from the menu.';

  @override
  String get pickupCartBrowse => 'Browse the menu';

  @override
  String get pickupCartChooseStorePrompt => 'Choose a pickup store';

  @override
  String get pickupCartStoreRequired => 'Pick a store before you order.';

  @override
  String pickupCartRemoved(String name) {
    return 'Removed $name from your cart.';
  }

  @override
  String get pickupCartStoreSheetDetail =>
      'Where will you collect your drinks?';

  @override
  String pickupCartOrderedWithPoints(int number, String points) {
    return 'Your pickup order is in. Order #$number · you earned ${points}P.';
  }

  @override
  String pickupCartOrdered(int number) {
    return 'Your pickup order is in. Order #$number · we will tell you when it is ready.';
  }

  @override
  String get pickupTrackingTitle => 'Order status';

  @override
  String get pickupTrackingLoadFailed => 'Could not load the order status.';

  @override
  String get pickupTrackingLiveNotice =>
      'This updates the moment the order moves.';

  @override
  String get pickupTrackingNotFound => 'Order not found';

  @override
  String get pickupTrackingNotFoundDetail => 'Check your order history.';

  @override
  String pickupOrderNumber(int number) {
    return 'Order #$number';
  }

  @override
  String pickupOrderedAt(String time) {
    return 'Ordered at $time';
  }

  @override
  String get pickupStepReceived => 'The store is looking at your order.';

  @override
  String get pickupStepPreparing => 'A barista is making it.';

  @override
  String get pickupStepReady => 'Collect it from the pickup counter.';

  @override
  String get pickupStepPickedUp => 'Enjoy — and thank you!';

  @override
  String get pickupInProgress => 'In progress';

  @override
  String get pickupRefundChecking =>
      'Your coupons and points are back. We are still checking the refund — contact support if it drags on.';

  @override
  String get pickupRefundNormal =>
      'Your coupons and points are back. The refund can take three to five days depending on how you paid.';

  @override
  String get pickupCancelledTitle => 'This order was cancelled';

  @override
  String get pickupCancelAction => 'Cancel this order';

  @override
  String get pickupCancelTitle => 'Cancel this pickup order?';

  @override
  String get pickupSectionItems => 'What you ordered';

  @override
  String pickupItemQuantity(int count) {
    return '×$count';
  }

  @override
  String get pickupPaidAmount => 'Paid';

  @override
  String get giftStatusSent => 'Sent';

  @override
  String get giftStatusRedeemed => 'Received';

  @override
  String get orderDestinationNoRecipient => 'No recipient';

  @override
  String get orderDestinationNoStore => 'No store';

  @override
  String get accountDisplayFallback => 'Member';

  @override
  String get qrMalformed => 'That is not a valid membership QR code.';

  @override
  String get qrExpired =>
      'That membership QR code has expired. Ask for a fresh one and scan again.';

  @override
  String get couponSelectTitle => 'Choose coupons';

  @override
  String get couponSelectNotice =>
      'You can use one ordinary coupon; stacking coupons can go together.';

  @override
  String get couponSelectNone => 'No coupon';

  @override
  String couponSelectApplyWithDiscount(String amount) {
    return 'Apply (-₩$amount)';
  }

  @override
  String get couponSelectApply => 'Apply';

  @override
  String get couponStackable => 'Stacks';

  @override
  String get couponListTitle => 'Coupons';

  @override
  String get couponLoadFailed => 'Could not load your coupons.';

  @override
  String couponSectionUsable(int count) {
    return '$count available';
  }

  @override
  String get couponSectionSpent => 'Used and expired';

  @override
  String get couponMarkedUsed => 'The coupon is marked used.';

  @override
  String get couponUseFailed => 'Could not use the coupon. Try again.';

  @override
  String get couponEmpty => 'You have no coupons';

  @override
  String get couponStateUsed => 'Used';

  @override
  String get couponStateExpired => 'Expired';

  @override
  String get couponStateUsable => 'Available';

  @override
  String get couponUseTitle => 'Use this coupon';

  @override
  String get couponUseConfirm =>
      'Have a member of staff confirm first. Once used, a coupon cannot be put back.';

  @override
  String get couponUseAction => 'Use';

  @override
  String couponValidUntil(String date) {
    return 'Valid until $date';
  }

  @override
  String get couponShowQr =>
      'Show this QR code to a member of staff. Tap Use once they have scanned it.';

  @override
  String get couponUseButton => 'Use it';

  @override
  String get giftHistoryTitle => 'Gifts you sent';

  @override
  String get giftHistoryLoadFailed => 'Could not load your gifts.';

  @override
  String get giftHistoryEmptyTitle => 'You have not sent any gifts';

  @override
  String get giftHistoryEmptyDetail =>
      'Send beans to someone from a bean\'s page.';

  @override
  String get giftScreenTitle => 'Send beans';

  @override
  String giftSent(String name, String bean) {
    return 'Sent $bean to $name.';
  }

  @override
  String get giftViewHistory => 'See gifts';

  @override
  String get giftSectionOptions => 'Choose options';

  @override
  String get giftSectionRecipient => 'Who it is for';

  @override
  String get giftFieldName => 'Name';

  @override
  String get giftFieldNameHint => 'The recipient\'s name';

  @override
  String get giftFieldNameRequired => 'Enter the recipient\'s name.';

  @override
  String get giftFieldPhoneRequired => 'Enter the recipient\'s phone number.';

  @override
  String get giftFieldMessage => 'Message (optional)';

  @override
  String get giftFieldMessageHint => 'Say something to go with it.';

  @override
  String get giftTotalPrice => 'Gift total';

  @override
  String get giftSending => 'Sending…';

  @override
  String get giftSend => 'Send the gift';

  @override
  String get navHome => 'Home';

  @override
  String get navOrder => 'Order';

  @override
  String get navPay => 'Pay';

  @override
  String get navProfile => 'You';

  @override
  String get badgeSoldOut => 'Sold out';

  @override
  String get updateRequiredTitle => 'Time to update';

  @override
  String get updateRequiredDetail =>
      'Update to the newest version for a safer, smoother app.';

  @override
  String get updateGo => 'Go and update';

  @override
  String get offlineBanner => 'You are offline';

  @override
  String get commonDelete => 'Delete';

  @override
  String orderCancelRestoreCoupon(String title) {
    return 'Coupon ($title) returned';
  }

  @override
  String orderCancelRefundPoints(String amount) {
    return '${amount}P refunded';
  }

  @override
  String orderCancelTakeBackPoints(String amount) {
    return '${amount}P earned taken back';
  }

  @override
  String get orderCancelIrreversible => 'You cannot undo a cancellation.';

  @override
  String orderCancelWithSummary(String summary) {
    return 'You cannot undo a cancellation.\n$summary happens at the same time.';
  }

  @override
  String get orderCancelGoBack => 'Go back';

  @override
  String get notificationChannelName => 'Important alerts';

  @override
  String get notificationChannelDescription =>
      'Order updates, events and other app notifications';

  @override
  String referralInvitation(String code, String reward) {
    return 'Fancy a coffee at Foxtrot? Sign up, enter invite code $code, and we will give you ${reward}P.';
  }

  @override
  String get referralCodeInvalid =>
      'Check the six-character invite code again.';

  @override
  String referralRedeemed(String reward) {
    return 'You earned ${reward}P, and so did your friend.';
  }

  @override
  String get referralRedeemFailed =>
      'We could not check that invite code. Try again in a moment.';

  @override
  String get referralTitle => 'Invite a friend';

  @override
  String get referralLoadFailed => 'Could not load your invite code.';

  @override
  String get referralCodeCopied => 'Invite code copied.';

  @override
  String get referralMessageCopied => 'Invitation copied.';

  @override
  String get referralRewardTitle => 'Invite reward';

  @override
  String referralRewardBoth(String reward) {
    return '${reward}P for both of you';
  }

  @override
  String get referralRewardHow =>
      'When a friend signs up and enters your code, you both get the points.';

  @override
  String get referralMyCode => 'Your invite code';

  @override
  String get referralCopyCode => 'Copy the code';

  @override
  String get referralCopyMessage => 'Copy the invitation';

  @override
  String get referralInvitedCount => 'Friends invited';

  @override
  String referralPeopleCount(int count) {
    return '$count';
  }

  @override
  String get referralRewardEarned => 'Rewards earned';

  @override
  String get referralRemaining => 'Invites left';

  @override
  String get referralEnterCode => 'Enter an invite code';

  @override
  String get referralCodeHint => 'e.g. A2K9PX';

  @override
  String get referralChecking => 'Checking…';

  @override
  String get referralClaim => 'Claim the points';

  @override
  String get referralAlreadyRedeemed => 'Code already used';

  @override
  String referralRedeemedDetail(String code, String reward) {
    return 'You got ${reward}P with code $code.';
  }

  @override
  String get referralRuleOnce => 'One invite code per account.';

  @override
  String get referralRuleNotSelf => 'You cannot use your own code.';

  @override
  String referralRuleLimit(int limit) {
    return 'Invite rewards stop after $limit friends.';
  }

  @override
  String get referralRuleImmediate =>
      'The points land straight away and show on your points screen.';

  @override
  String get referralNoticeTitle => 'Good to know';

  @override
  String get wholesaleMemberFallback => 'Business member';

  @override
  String get wholesaleQuoteSubmitted =>
      'Your quote request is in. Someone will be in touch shortly.';

  @override
  String wholesaleQuoteFailed(String error) {
    return 'The quote request failed: $error';
  }

  @override
  String get wholesaleQuoteTitle => 'Request a wholesale quote';

  @override
  String get wholesaleBeansLoadFailed => 'Could not load the wholesale beans.';

  @override
  String get wholesaleSectionBeans => 'Choose beans';

  @override
  String get wholesaleSectionNotes => 'Anything else';

  @override
  String get wholesaleNotesHint =>
      'Delivery schedule, dates, grind — tell us what you need';

  @override
  String wholesaleBusinessNumber(String number) {
    return 'Business number $number';
  }

  @override
  String wholesalePricePerKg(String price, int minKg) {
    return 'From ₩$price/kg · minimum ${minKg}kg';
  }

  @override
  String wholesaleAppliedPrice(String price, String total) {
    return '₩$price/kg applied · ₩$total total';
  }

  @override
  String wholesaleTotalKg(int kg) {
    return '${kg}kg total';
  }

  @override
  String wholesaleEstimate(String amount) {
    return 'About ₩$amount';
  }

  @override
  String get wholesaleSubmit => 'Request a quote';

  @override
  String get wholesaleHistoryTitle => 'Quote requests';

  @override
  String get wholesaleHistoryLoadFailed => 'Could not load your quotes.';

  @override
  String get wholesaleHistoryEmptyTitle => 'No quote requests yet';

  @override
  String get wholesaleHistoryEmptyDetail =>
      'Pick beans from the wholesale list and ask for a quote.';

  @override
  String wholesaleCompanyAndKg(String company, int kg) {
    return '$company · ${kg}kg total';
  }

  @override
  String get wholesaleBeanList => 'Wholesale beans';

  @override
  String get wholesaleRequestQuote => 'Request a quote';

  @override
  String wholesaleGreeting(String company) {
    return 'Hello $company,\nhere is to good business!';
  }

  @override
  String get wholesaleGreetingSubtitle =>
      'We roast to order and supply at trade prices';

  @override
  String get wholesalePerkMinimum => 'From 5kg up, with trade prices by volume';

  @override
  String get wholesalePerkRoast =>
      'Roasted the day we confirm · two to three days nationwide';

  @override
  String get wholesalePerkInvoice =>
      'Tax invoices and standing supply contracts';

  @override
  String get wholesaleGuideTitle => 'How wholesale supply works';

  @override
  String get wholesaleQuoteHistory => 'Your quotes';

  @override
  String get wholesaleSupport => 'Support';

  @override
  String wholesaleTierPrice(int minKg, String price) {
    return '${minKg}kg+ ₩$price';
  }

  @override
  String wholesaleFromPricePerKg(String price) {
    return 'From ₩$price/kg';
  }

  @override
  String wholesaleMinOrder(int minKg) {
    return 'Minimum ${minKg}kg';
  }

  @override
  String get wholesaleAddToQuote => 'Add to quote';

  @override
  String get pointsEarnDone => 'Points added';

  @override
  String pointsPaidAmount(String amount) {
    return 'Paid ₩$amount';
  }

  @override
  String pointsBalanceNow(String amount) {
    return 'Balance ${amount}P';
  }

  @override
  String get commonConfirm => 'OK';

  @override
  String get pointsEarnFailed => 'Could not add the points. Try again.';

  @override
  String get pointsScanTitle => 'Add member points';

  @override
  String get pointsScanIntro =>
      'Scan the customer\'s membership QR, then enter what they paid. They earn 10% of it.';

  @override
  String get pointsEarnDialogTitle => 'Add points';

  @override
  String get pointsPaidAmountField => 'Amount paid (₩)';

  @override
  String get pointsAmountInvalid => 'Enter a number of 1 or more.';

  @override
  String get pointsEarnAction => 'Add';

  @override
  String get pointsChargeTitle => 'Top up points';

  @override
  String get pointsChargeChoose => 'Choose an amount';

  @override
  String get pointsChargePaying => 'Taking payment…';

  @override
  String pointsChargePay(String amount) {
    return 'Pay ₩$amount';
  }

  @override
  String get pointsChargeRefundNotice =>
      'Refunds on a top-up go through support.';

  @override
  String pointsChargeOrderName(String description, String amount) {
    return '$description ₩$amount';
  }

  @override
  String pointsChargedWithBonus(String total, String bonus) {
    return '${total}P added, including a ${bonus}P bonus.';
  }

  @override
  String pointsCharged(String total) {
    return '${total}P added.';
  }

  @override
  String get pointsCurrentBalance => 'Points you have';

  @override
  String pointsChargePlan(String amount) {
    return '₩$amount top-up';
  }

  @override
  String pointsChargeBonus(String bonus) {
    return 'Bonus +${bonus}P';
  }

  @override
  String get pointsChargeNoBonus => 'No bonus';

  @override
  String get pointsChargeAmount => 'You pay';

  @override
  String get pointsChargePoints => 'Points added';

  @override
  String get pointsChargeBonusLabel => 'Bonus points';

  @override
  String get pointsChargeExpected => 'Balance afterwards';

  @override
  String get pointsTitle => 'Points';

  @override
  String get pointsLoadFailed => 'Could not load your points.';

  @override
  String get pointsSectionBarcode => 'Membership code';

  @override
  String get pointsSectionHistory => 'Points history';

  @override
  String get pointsMine => 'Your points';

  @override
  String pointsEarnNotice(int rate) {
    return 'Pay in store, show the QR below, and $rate% of what you paid lands automatically. Ordering in the app earns it without any of that.';
  }

  @override
  String get pointsChargeAction => 'Top up';

  @override
  String get pointsUseAction => 'Use points';

  @override
  String pointsUseHelper(String balance) {
    return '${balance}P available';
  }

  @override
  String get pointsUseField => 'Points to use (P)';

  @override
  String get pointsUseConfirm => 'Use';

  @override
  String get pointsUseFailed => 'Could not use the points. Try again.';

  @override
  String pointsUsed(String amount, String balance) {
    return 'Used ${amount}P. ${balance}P left.';
  }

  @override
  String get pointsInsufficient => 'Not enough points.';

  @override
  String get pointsStaffMode => 'Staff tools';

  @override
  String get pointsStaffIntro =>
      'Scan a customer\'s membership QR to add the points they earned.';

  @override
  String get pointsStaffScan => 'Scan a member QR';

  @override
  String get pointsStaffOrders => 'Orders';

  @override
  String get pointsStaffCatalog => 'Catalogue';

  @override
  String get pointsQrRefreshNotice =>
      'For safety the QR code refreshes every minute.';

  @override
  String get pointsHistoryEmpty => 'Nothing earned or spent yet.';

  @override
  String pointsPaidWithBonus(String amount, String bonus) {
    return 'Paid ₩$amount · bonus +${bonus}P';
  }

  @override
  String adminSaveFailed(String error) {
    return 'Could not save: $error';
  }

  @override
  String adminRemoveFailed(String error) {
    return 'Could not take it down: $error';
  }

  @override
  String get adminSortOrder => 'Sort order';

  @override
  String get adminSortOrderHelper => 'Lower numbers come first.';

  @override
  String get adminCreate => 'Create';

  @override
  String get adminSave => 'Save';

  @override
  String get adminFieldTitle => 'Title';

  @override
  String get adminFieldTitleRequired => 'Enter a title.';

  @override
  String get adminFieldDescription => 'Description';

  @override
  String get adminFieldIcon => 'Icon';

  @override
  String get adminFieldName => 'Name';

  @override
  String get adminFieldNameRequired => 'Enter a name.';

  @override
  String get adminPriceInvalid => 'Enter the price as a number.';

  @override
  String get bannerCreateTitle => 'New banner';

  @override
  String get bannerEditTitle => 'Edit banner';

  @override
  String get bannerRemoveTitle => 'Take this banner down?';

  @override
  String bannerRemoveBody(String title) {
    return 'This removes $title from the home tab.';
  }

  @override
  String get bannerRemoveAction => 'Take it down';

  @override
  String get storeCreateTitle => 'New store';

  @override
  String get storeEditTitle => 'Edit store';

  @override
  String get storeRemoveTitle => 'Take this store down?';

  @override
  String storeRemoveBody(String name) {
    return 'This removes $name from Find a store.';
  }

  @override
  String get storeRemoveAction => 'Take it down';

  @override
  String get storeFieldName => 'Store name';

  @override
  String get storeFieldNameRequired => 'Enter the store name.';

  @override
  String get storeFieldAddress => 'Address';

  @override
  String get storeFieldPhone => 'Phone';

  @override
  String get storeFieldLatitude => 'Latitude';

  @override
  String get storeFieldLongitude => 'Longitude';

  @override
  String get storeFieldWeekdayHours => 'Weekday hours';

  @override
  String get storeFieldWeekendHours => 'Weekend hours';

  @override
  String get storeFieldFacilities => 'Facilities';

  @override
  String get storeFieldFacilitiesHelper =>
      'Comma separated, e.g. two hours free parking, terrace';

  @override
  String get storeFieldNotice => 'Store notice';

  @override
  String get storeFieldNoticeHelper =>
      'Sits at the top of the store page. Leave it empty to hide it.';

  @override
  String get storeFieldCongestion => 'How busy it is now';

  @override
  String storeCongestionHelper(int hours) {
    return 'After $hours hours this is hidden and the count of orders in progress takes over.';
  }

  @override
  String storeNumberInvalid(String label, String range) {
    return 'Enter $label as a number between $range.';
  }

  @override
  String get menuCreateTitle => 'New menu item';

  @override
  String get menuEditTitle => 'Edit menu item';

  @override
  String get menuRemoveTitle => 'Take this item down?';

  @override
  String menuRemoveBody(String name) {
    return 'This removes $name from the catalogue. Past orders stay as they are.';
  }

  @override
  String get menuRemoveAction => 'Take it down';

  @override
  String get menuFieldCategoryLabel => 'Category';

  @override
  String get menuFieldPriceFrom => 'Show the price as a starting price';

  @override
  String get menuFieldPriceFromHelper =>
      'For items where options push the price up';

  @override
  String get menuFieldBadge => 'Badge';

  @override
  String get menuBadgeNone => 'None';

  @override
  String get menuFieldDetail => 'Long description (optional)';

  @override
  String get menuFieldRecommended => 'Recommended';

  @override
  String get menuFieldSoldOut => 'Sold out';

  @override
  String get noticeCreateTitle => 'New notice';

  @override
  String get noticeEditTitle => 'Edit notice';

  @override
  String get noticeRemoveTitle => 'Take this notice down?';

  @override
  String noticeRemoveBody(String title) {
    return 'This removes $title from the notification list.';
  }

  @override
  String get noticeRemoveAction => 'Take it down';

  @override
  String get noticeFieldBody => 'Body';

  @override
  String get noticeFieldBodyRequired => 'Enter the body text.';

  @override
  String get noticeFieldCategory => 'Category';

  @override
  String get noticeFieldDate => 'Publish date';

  @override
  String get noticeFieldDateHelper => 'Later dates show higher in the list.';

  @override
  String get noticeChooseDate => 'Choose a date';

  @override
  String get noticeFieldImportant => 'Important';

  @override
  String get noticeFieldImportantHelper =>
      'Adds an Important badge in the list.';

  @override
  String get beanCreateTitle => 'New bean';

  @override
  String get beanEditTitle => 'Edit bean';

  @override
  String get beanRemoveTitle => 'Take this bean down?';

  @override
  String beanRemoveBody(String name) {
    return 'This removes $name from the catalogue. Past orders stay as they are.';
  }

  @override
  String get beanRemoveAction => 'Take it down';

  @override
  String beanFieldRequired(String label) {
    return 'Enter $label.';
  }

  @override
  String get beanFieldOriginLabel => 'Origin';

  @override
  String get beanFieldStory => 'Story';

  @override
  String get beanFieldRoastLevel => 'Roast level';

  @override
  String get beanFieldProcessLabel => 'Process';

  @override
  String get beanFieldProcessHelper => 'Washed, natural, decaf and so on';

  @override
  String get beanFieldNotes => 'Tasting notes';

  @override
  String get beanFieldNotesHelper =>
      'Comma separated, e.g. grapefruit, jasmine, brown sugar';

  @override
  String get beanFieldBrewsLabel => 'Brew methods';

  @override
  String get beanFieldBrewsHelper =>
      'Comma separated, e.g. hand drip, espresso';

  @override
  String get beanFieldPrice200 => '200g price (₩)';

  @override
  String get beanFieldPrice500 => '500g price (₩)';

  @override
  String get beanFieldNewBadge => 'NEW badge';

  @override
  String get catalogAdminTitle => 'Catalogue';

  @override
  String get catalogTabMenu => 'Menu';

  @override
  String get catalogAddMenu => 'New menu item';

  @override
  String get catalogTabBeans => 'Beans';

  @override
  String get catalogAddBean => 'New bean';

  @override
  String get catalogTabBanners => 'Banners';

  @override
  String get catalogAddBanner => 'New banner';

  @override
  String get catalogTabStores => 'Stores';

  @override
  String get catalogAddStore => 'New store';

  @override
  String get catalogTabNotices => 'Notices';

  @override
  String get catalogAddNotice => 'New notice';

  @override
  String get catalogMenuEmpty => 'No menu items yet.';

  @override
  String get catalogBeansEmpty => 'No beans yet.';

  @override
  String get catalogBannersLoadFailed => 'Could not load the banners.';

  @override
  String get catalogBannersEmpty => 'No banners yet.';

  @override
  String get catalogStoresEmpty => 'No stores yet.';

  @override
  String get catalogNoticesLoadFailed => 'Could not load the notices.';

  @override
  String get catalogNoticesEmpty => 'No notices yet.';

  @override
  String catalogSoldOutFailed(String error) {
    return 'Could not change availability: $error';
  }

  @override
  String catalogSoldOutPrefix(String subtitle) {
    return 'Sold out · $subtitle';
  }
}
