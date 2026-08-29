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

  /// No description provided for @homeGreetingGuestName.
  ///
  /// In ko, this message translates to:
  /// **'고객'**
  String get homeGreetingGuestName;

  /// No description provided for @homeGreetingMember.
  ///
  /// In ko, this message translates to:
  /// **'{name}님,\n반가워요!'**
  String homeGreetingMember(String name);

  /// No description provided for @homeGreetingVisitor.
  ///
  /// In ko, this message translates to:
  /// **'폭스트롯에\n어서오세요!'**
  String get homeGreetingVisitor;

  /// No description provided for @homeGreetingSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'오늘도 향긋한 커피 한 잔의 여유를 즐겨보세요'**
  String get homeGreetingSubtitle;

  /// No description provided for @homeFindStore.
  ///
  /// In ko, this message translates to:
  /// **'매장 찾기'**
  String get homeFindStore;

  /// No description provided for @homeNotifications.
  ///
  /// In ko, this message translates to:
  /// **'알림'**
  String get homeNotifications;

  /// No description provided for @homeSignIn.
  ///
  /// In ko, this message translates to:
  /// **'로그인'**
  String get homeSignIn;

  /// No description provided for @homeQuickOrder.
  ///
  /// In ko, this message translates to:
  /// **'주문하기'**
  String get homeQuickOrder;

  /// No description provided for @homeQuickCoupons.
  ///
  /// In ko, this message translates to:
  /// **'쿠폰함'**
  String get homeQuickCoupons;

  /// No description provided for @homeQuickOrderHistory.
  ///
  /// In ko, this message translates to:
  /// **'주문내역'**
  String get homeQuickOrderHistory;

  /// No description provided for @homeQuickStores.
  ///
  /// In ko, this message translates to:
  /// **'매장찾기'**
  String get homeQuickStores;

  /// No description provided for @homeRecommendedTitle.
  ///
  /// In ko, this message translates to:
  /// **'이 메뉴 어때요?'**
  String get homeRecommendedTitle;

  /// No description provided for @homeSeeAll.
  ///
  /// In ko, this message translates to:
  /// **'전체보기'**
  String get homeSeeAll;

  /// No description provided for @homeRewardsTitle.
  ///
  /// In ko, this message translates to:
  /// **'폭스트롯 리워드'**
  String get homeRewardsTitle;

  /// No description provided for @homeRewardsMineTitle.
  ///
  /// In ko, this message translates to:
  /// **'나의 리워드'**
  String get homeRewardsMineTitle;

  /// No description provided for @homeRewardsSignInPrompt.
  ///
  /// In ko, this message translates to:
  /// **'로그인하고\n포인트를 모아보세요'**
  String get homeRewardsSignInPrompt;

  /// No description provided for @homeRewardsSignInDetail.
  ///
  /// In ko, this message translates to:
  /// **'결제 금액의 10%가 적립되고, {goal}P를 모으면 무료 음료 쿠폰을 드려요!'**
  String homeRewardsSignInDetail(String goal);

  /// No description provided for @homeRewardsSignInAction.
  ///
  /// In ko, this message translates to:
  /// **'로그인하기'**
  String get homeRewardsSignInAction;

  /// No description provided for @homeRewardsBalance.
  ///
  /// In ko, this message translates to:
  /// **'{balance}P'**
  String homeRewardsBalance(String balance);

  /// No description provided for @homeRewardsRemaining.
  ///
  /// In ko, this message translates to:
  /// **'{remaining}P 더 모으면 무료 음료 쿠폰!'**
  String homeRewardsRemaining(String remaining);

  /// No description provided for @homeRewardsGoalReached.
  ///
  /// In ko, this message translates to:
  /// **'무료 음료 쿠폰으로 교환할 수 있어요!'**
  String get homeRewardsGoalReached;

  /// No description provided for @bannerIconSparkles.
  ///
  /// In ko, this message translates to:
  /// **'반짝임'**
  String get bannerIconSparkles;

  /// No description provided for @bannerIconSnowflake.
  ///
  /// In ko, this message translates to:
  /// **'눈꽃'**
  String get bannerIconSnowflake;

  /// No description provided for @bannerIconBean.
  ///
  /// In ko, this message translates to:
  /// **'원두'**
  String get bannerIconBean;

  /// No description provided for @bannerIconGift.
  ///
  /// In ko, this message translates to:
  /// **'선물'**
  String get bannerIconGift;

  /// No description provided for @authSignIn.
  ///
  /// In ko, this message translates to:
  /// **'로그인'**
  String get authSignIn;

  /// No description provided for @authSignedIn.
  ///
  /// In ko, this message translates to:
  /// **'로그인되었습니다.'**
  String get authSignedIn;

  /// No description provided for @authSignInWithKakao.
  ///
  /// In ko, this message translates to:
  /// **'카카오로 시작하기'**
  String get authSignInWithKakao;

  /// No description provided for @authSignInWithNaver.
  ///
  /// In ko, this message translates to:
  /// **'네이버로 시작하기'**
  String get authSignInWithNaver;

  /// No description provided for @authSignInWithGoogle.
  ///
  /// In ko, this message translates to:
  /// **'구글로 시작하기'**
  String get authSignInWithGoogle;

  /// No description provided for @authSignInLater.
  ///
  /// In ko, this message translates to:
  /// **'나중에 로그인하기'**
  String get authSignInLater;

  /// No description provided for @businessAccountTitle.
  ///
  /// In ko, this message translates to:
  /// **'사업자 계정'**
  String get businessAccountTitle;

  /// No description provided for @businessMissingFields.
  ///
  /// In ko, this message translates to:
  /// **'상호명과 사업자등록번호를 입력해주세요.'**
  String get businessMissingFields;

  /// No description provided for @businessNumberInvalid.
  ///
  /// In ko, this message translates to:
  /// **'사업자등록번호 10자리를 다시 확인해주세요.'**
  String get businessNumberInvalid;

  /// No description provided for @businessSwitched.
  ///
  /// In ko, this message translates to:
  /// **'사업자 계정으로 전환되었습니다. 도매 홈으로 이동합니다.'**
  String get businessSwitched;

  /// No description provided for @businessSwitchFailed.
  ///
  /// In ko, this message translates to:
  /// **'사업자 전환에 실패했습니다: {error}'**
  String businessSwitchFailed(String error);

  /// No description provided for @businessSwitchFailedRetry.
  ///
  /// In ko, this message translates to:
  /// **'사업자 전환에 실패했습니다. 다시 시도해주세요.'**
  String get businessSwitchFailedRetry;

  /// No description provided for @businessSwitchedBack.
  ///
  /// In ko, this message translates to:
  /// **'일반 고객 계정으로 전환되었습니다.'**
  String get businessSwitchedBack;

  /// No description provided for @businessIntro.
  ///
  /// In ko, this message translates to:
  /// **'사업자 계정으로 전환하면 홈 화면이 원두 도매(B2B) 화면으로 바뀌고, kg 단위 도매가로 견적을 요청할 수 있어요.'**
  String get businessIntro;

  /// No description provided for @businessSectionInfo.
  ///
  /// In ko, this message translates to:
  /// **'사업자 정보'**
  String get businessSectionInfo;

  /// No description provided for @businessFieldCompany.
  ///
  /// In ko, this message translates to:
  /// **'상호명 *'**
  String get businessFieldCompany;

  /// No description provided for @businessFieldCompanyHint.
  ///
  /// In ko, this message translates to:
  /// **'예) 카페 어라운드'**
  String get businessFieldCompanyHint;

  /// No description provided for @businessFieldNumber.
  ///
  /// In ko, this message translates to:
  /// **'사업자등록번호 *'**
  String get businessFieldNumber;

  /// No description provided for @businessFieldManager.
  ///
  /// In ko, this message translates to:
  /// **'담당자명'**
  String get businessFieldManager;

  /// No description provided for @businessFieldPhone.
  ///
  /// In ko, this message translates to:
  /// **'연락처'**
  String get businessFieldPhone;

  /// No description provided for @businessSwitchAction.
  ///
  /// In ko, this message translates to:
  /// **'사업자 계정으로 전환하기'**
  String get businessSwitchAction;

  /// No description provided for @businessSavedTitle.
  ///
  /// In ko, this message translates to:
  /// **'등록된 사업자 정보'**
  String get businessSavedTitle;

  /// No description provided for @businessSavedIntro.
  ///
  /// In ko, this message translates to:
  /// **'이전에 등록한 사업자 정보가 있어요. 다시 입력하지 않고 바로 사업자 계정으로 전환할 수 있어요.'**
  String get businessSavedIntro;

  /// No description provided for @businessSavedSwitch.
  ///
  /// In ko, this message translates to:
  /// **'사업자 계정으로 전환'**
  String get businessSavedSwitch;

  /// No description provided for @businessSavedEdit.
  ///
  /// In ko, this message translates to:
  /// **'사업자 정보 수정'**
  String get businessSavedEdit;

  /// No description provided for @businessLabelCompany.
  ///
  /// In ko, this message translates to:
  /// **'상호명'**
  String get businessLabelCompany;

  /// No description provided for @businessLabelNumber.
  ///
  /// In ko, this message translates to:
  /// **'사업자등록번호'**
  String get businessLabelNumber;

  /// No description provided for @businessLabelManager.
  ///
  /// In ko, this message translates to:
  /// **'담당자명'**
  String get businessLabelManager;

  /// No description provided for @businessLabelPhone.
  ///
  /// In ko, this message translates to:
  /// **'연락처'**
  String get businessLabelPhone;

  /// No description provided for @businessActiveTitle.
  ///
  /// In ko, this message translates to:
  /// **'사업자 계정 사용 중'**
  String get businessActiveTitle;

  /// No description provided for @businessActiveDescription.
  ///
  /// In ko, this message translates to:
  /// **'홈 화면에서 도매 원두 시세를 확인하고 견적을 요청할 수 있어요.'**
  String get businessActiveDescription;

  /// No description provided for @businessSwitchBackAction.
  ///
  /// In ko, this message translates to:
  /// **'일반 고객 계정으로 전환'**
  String get businessSwitchBackAction;

  /// No description provided for @priceWon.
  ///
  /// In ko, this message translates to:
  /// **'{amount}원'**
  String priceWon(String amount);

  /// No description provided for @priceWonFrom.
  ///
  /// In ko, this message translates to:
  /// **'{amount}원~'**
  String priceWonFrom(String amount);

  /// No description provided for @retry.
  ///
  /// In ko, this message translates to:
  /// **'다시 시도'**
  String get retry;

  /// No description provided for @menuCategoryDrip.
  ///
  /// In ko, this message translates to:
  /// **'드립 커피'**
  String get menuCategoryDrip;

  /// No description provided for @menuCategoryDripNote.
  ///
  /// In ko, this message translates to:
  /// **'싱글 오리진 원두 9종 · 매주 변경되는 시즌 컬렉션'**
  String get menuCategoryDripNote;

  /// No description provided for @menuCategoryEspresso.
  ///
  /// In ko, this message translates to:
  /// **'에스프레소'**
  String get menuCategoryEspresso;

  /// No description provided for @menuCategoryEspressoNote.
  ///
  /// In ko, this message translates to:
  /// **'우유 변경 오트·아몬드·소이 +0.5 · 락토프리·저지방 +0.3\n시럽 추가 바닐라·카라멜·헤이즐넛·라벤더 +0.3'**
  String get menuCategoryEspressoNote;

  /// No description provided for @menuCategoryBeverage.
  ///
  /// In ko, this message translates to:
  /// **'음료'**
  String get menuCategoryBeverage;

  /// No description provided for @menuCategoryBeverageNote.
  ///
  /// In ko, this message translates to:
  /// **'샷 추가 딸기라떼·발로나초코라떼·말차라떼·복숭아아이스티 +0.5'**
  String get menuCategoryBeverageNote;

  /// No description provided for @menuCategoryTea.
  ///
  /// In ko, this message translates to:
  /// **'티'**
  String get menuCategoryTea;

  /// No description provided for @menuCategoryTeaNote.
  ///
  /// In ko, this message translates to:
  /// **'타바론(Tavalon) 프리미엄 티 컬렉션'**
  String get menuCategoryTeaNote;

  /// No description provided for @menuCategoryDessert.
  ///
  /// In ko, this message translates to:
  /// **'디저트'**
  String get menuCategoryDessert;

  /// No description provided for @menuCategoryBeans.
  ///
  /// In ko, this message translates to:
  /// **'원두'**
  String get menuCategoryBeans;

  /// No description provided for @menuTitle.
  ///
  /// In ko, this message translates to:
  /// **'메뉴'**
  String get menuTitle;

  /// No description provided for @menuLoadFailed.
  ///
  /// In ko, this message translates to:
  /// **'메뉴 정보를 불러오지 못했습니다.'**
  String get menuLoadFailed;

  /// No description provided for @menuDetailTitle.
  ///
  /// In ko, this message translates to:
  /// **'메뉴 상세'**
  String get menuDetailTitle;

  /// No description provided for @menuOrderRequiresSignIn.
  ///
  /// In ko, this message translates to:
  /// **'메뉴 주문은 로그인 후 이용할 수 있어요.'**
  String get menuOrderRequiresSignIn;

  /// No description provided for @menuAddedToCart.
  ///
  /// In ko, this message translates to:
  /// **'{name}을(를) 장바구니에 담았습니다.'**
  String menuAddedToCart(String name);

  /// No description provided for @menuViewCart.
  ///
  /// In ko, this message translates to:
  /// **'보기'**
  String get menuViewCart;

  /// No description provided for @menuSoldOutNotice.
  ///
  /// In ko, this message translates to:
  /// **'오늘은 준비된 재료가 떨어졌어요'**
  String get menuSoldOutNotice;

  /// No description provided for @menuPickupOrder.
  ///
  /// In ko, this message translates to:
  /// **'매장 픽업 주문'**
  String get menuPickupOrder;

  /// No description provided for @menuSoldOut.
  ///
  /// In ko, this message translates to:
  /// **'품절'**
  String get menuSoldOut;

  /// No description provided for @menuOrder.
  ///
  /// In ko, this message translates to:
  /// **'주문하기'**
  String get menuOrder;

  /// No description provided for @menuFavoriteAdd.
  ///
  /// In ko, this message translates to:
  /// **'즐겨찾기 등록'**
  String get menuFavoriteAdd;

  /// No description provided for @menuFavoriteRemove.
  ///
  /// In ko, this message translates to:
  /// **'즐겨찾기 해제'**
  String get menuFavoriteRemove;

  /// No description provided for @menuFavoriteAdded.
  ///
  /// In ko, this message translates to:
  /// **'즐겨찾기에 추가되었습니다.'**
  String get menuFavoriteAdded;

  /// No description provided for @menuFavoriteRemoved.
  ///
  /// In ko, this message translates to:
  /// **'즐겨찾기에서 삭제되었습니다.'**
  String get menuFavoriteRemoved;

  /// No description provided for @menuSectionAbout.
  ///
  /// In ko, this message translates to:
  /// **'메뉴 소개'**
  String get menuSectionAbout;

  /// No description provided for @menuSectionOptions.
  ///
  /// In ko, this message translates to:
  /// **'옵션 안내'**
  String get menuSectionOptions;

  /// No description provided for @menuSectionDetails.
  ///
  /// In ko, this message translates to:
  /// **'상세 정보'**
  String get menuSectionDetails;

  /// No description provided for @menuFieldCategory.
  ///
  /// In ko, this message translates to:
  /// **'카테고리'**
  String get menuFieldCategory;

  /// No description provided for @menuFieldPrice.
  ///
  /// In ko, this message translates to:
  /// **'가격'**
  String get menuFieldPrice;

  /// No description provided for @menuFieldServingOptions.
  ///
  /// In ko, this message translates to:
  /// **'제공 옵션'**
  String get menuFieldServingOptions;

  /// No description provided for @menuNotFound.
  ///
  /// In ko, this message translates to:
  /// **'메뉴를 찾을 수 없습니다: {menuId}'**
  String menuNotFound(String menuId);

  /// No description provided for @favoriteMenuTitle.
  ///
  /// In ko, this message translates to:
  /// **'즐겨찾기 메뉴'**
  String get favoriteMenuTitle;

  /// No description provided for @favoriteMenuLoadFailed.
  ///
  /// In ko, this message translates to:
  /// **'즐겨찾기 메뉴를 불러오지 못했습니다.'**
  String get favoriteMenuLoadFailed;

  /// No description provided for @favoriteMenuEmptyTitle.
  ///
  /// In ko, this message translates to:
  /// **'아직 즐겨찾기한 메뉴가 없어요'**
  String get favoriteMenuEmptyTitle;

  /// No description provided for @favoriteMenuEmptyDetail.
  ///
  /// In ko, this message translates to:
  /// **'메뉴 상세에서 하트를 눌러 자주 마시는 메뉴를 등록해보세요.'**
  String get favoriteMenuEmptyDetail;

  /// No description provided for @favoriteMenuBrowse.
  ///
  /// In ko, this message translates to:
  /// **'메뉴 보러가기'**
  String get favoriteMenuBrowse;

  /// No description provided for @noticeCategoryEvent.
  ///
  /// In ko, this message translates to:
  /// **'이벤트'**
  String get noticeCategoryEvent;

  /// No description provided for @noticeCategoryNotice.
  ///
  /// In ko, this message translates to:
  /// **'공지'**
  String get noticeCategoryNotice;

  /// No description provided for @noticeCategoryBenefit.
  ///
  /// In ko, this message translates to:
  /// **'혜택'**
  String get noticeCategoryBenefit;

  /// No description provided for @noticeListTitle.
  ///
  /// In ko, this message translates to:
  /// **'알림'**
  String get noticeListTitle;

  /// No description provided for @noticeLoadFailed.
  ///
  /// In ko, this message translates to:
  /// **'알림을 불러오지 못했습니다.'**
  String get noticeLoadFailed;

  /// No description provided for @noticeEmpty.
  ///
  /// In ko, this message translates to:
  /// **'새로운 알림이 없어요'**
  String get noticeEmpty;

  /// No description provided for @noticeImportant.
  ///
  /// In ko, this message translates to:
  /// **'중요'**
  String get noticeImportant;

  /// No description provided for @reviewProductTypeMenu.
  ///
  /// In ko, this message translates to:
  /// **'메뉴'**
  String get reviewProductTypeMenu;

  /// No description provided for @reviewProductTypeBean.
  ///
  /// In ko, this message translates to:
  /// **'원두'**
  String get reviewProductTypeBean;

  /// No description provided for @reviewSheetTitle.
  ///
  /// In ko, this message translates to:
  /// **'{product} 후기 남기기'**
  String reviewSheetTitle(String product);

  /// No description provided for @reviewSheetHint.
  ///
  /// In ko, this message translates to:
  /// **'맛과 향은 어떠셨나요? 후기를 남겨주세요.'**
  String get reviewSheetHint;

  /// No description provided for @reviewSubmitting.
  ///
  /// In ko, this message translates to:
  /// **'등록 중...'**
  String get reviewSubmitting;

  /// No description provided for @reviewSubmit.
  ///
  /// In ko, this message translates to:
  /// **'후기 등록'**
  String get reviewSubmit;

  /// No description provided for @reviewSubmitted.
  ///
  /// In ko, this message translates to:
  /// **'소중한 후기가 등록되었습니다.'**
  String get reviewSubmitted;

  /// No description provided for @reviewSubmitFailed.
  ///
  /// In ko, this message translates to:
  /// **'후기 등록에 실패했습니다. 다시 시도해주세요.'**
  String get reviewSubmitFailed;

  /// No description provided for @reviewSectionTitle.
  ///
  /// In ko, this message translates to:
  /// **'리뷰'**
  String get reviewSectionTitle;

  /// No description provided for @reviewLoadFailed.
  ///
  /// In ko, this message translates to:
  /// **'리뷰를 불러오지 못했습니다.'**
  String get reviewLoadFailed;

  /// No description provided for @reviewMoreCount.
  ///
  /// In ko, this message translates to:
  /// **'외 {count}개의 리뷰가 있어요.'**
  String reviewMoreCount(int count);

  /// No description provided for @reviewEmpty.
  ///
  /// In ko, this message translates to:
  /// **'아직 리뷰가 없어요. 주문 내역에서 첫 리뷰를 남겨보세요.'**
  String get reviewEmpty;

  /// No description provided for @reviewRatingOutOfRange.
  ///
  /// In ko, this message translates to:
  /// **'별점은 {min}~{max}점 사이여야 합니다.'**
  String reviewRatingOutOfRange(int min, int max);

  /// No description provided for @congestionUnknown.
  ///
  /// In ko, this message translates to:
  /// **'정보 없음'**
  String get congestionUnknown;

  /// No description provided for @congestionRelaxed.
  ///
  /// In ko, this message translates to:
  /// **'여유'**
  String get congestionRelaxed;

  /// No description provided for @congestionNormal.
  ///
  /// In ko, this message translates to:
  /// **'보통'**
  String get congestionNormal;

  /// No description provided for @congestionBusy.
  ///
  /// In ko, this message translates to:
  /// **'혼잡'**
  String get congestionBusy;

  /// No description provided for @paymentTitle.
  ///
  /// In ko, this message translates to:
  /// **'결제하기'**
  String get paymentTitle;

  /// No description provided for @paymentApproving.
  ///
  /// In ko, this message translates to:
  /// **'결제 승인 중...'**
  String get paymentApproving;

  /// No description provided for @paymentCheckFailed.
  ///
  /// In ko, this message translates to:
  /// **'결제 정보 확인에 실패했습니다. 다시 시도해 주세요.'**
  String get paymentCheckFailed;

  /// No description provided for @paymentApproveFailed.
  ///
  /// In ko, this message translates to:
  /// **'결제 승인에 실패했습니다. 다시 시도해 주세요.'**
  String get paymentApproveFailed;

  /// No description provided for @paymentFailed.
  ///
  /// In ko, this message translates to:
  /// **'결제에 실패했습니다. 다시 시도해 주세요.'**
  String get paymentFailed;

  /// No description provided for @paymentProviderNotice.
  ///
  /// In ko, this message translates to:
  /// **'토스페이먼츠 안전결제'**
  String get paymentProviderNotice;

  /// No description provided for @storeCongestionNow.
  ///
  /// In ko, this message translates to:
  /// **'현재 {congestion}'**
  String storeCongestionNow(String congestion);
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
