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

  /// No description provided for @storeCallFailed.
  ///
  /// In ko, this message translates to:
  /// **'전화 연결에 실패했습니다: {phone}'**
  String storeCallFailed(String phone);

  /// No description provided for @storeMapFailed.
  ///
  /// In ko, this message translates to:
  /// **'지도를 열 수 없습니다.'**
  String get storeMapFailed;

  /// No description provided for @storeOpenNow.
  ///
  /// In ko, this message translates to:
  /// **'영업 중'**
  String get storeOpenNow;

  /// No description provided for @storeClosedNow.
  ///
  /// In ko, this message translates to:
  /// **'영업 종료'**
  String get storeClosedNow;

  /// No description provided for @storeCall.
  ///
  /// In ko, this message translates to:
  /// **'전화'**
  String get storeCall;

  /// No description provided for @storeOpenMap.
  ///
  /// In ko, this message translates to:
  /// **'지도 보기'**
  String get storeOpenMap;

  /// No description provided for @storeListTitle.
  ///
  /// In ko, this message translates to:
  /// **'매장 찾기'**
  String get storeListTitle;

  /// No description provided for @storeLocationUnavailable.
  ///
  /// In ko, this message translates to:
  /// **'현재 위치를 확인할 수 없습니다.'**
  String get storeLocationUnavailable;

  /// No description provided for @storeSortByDistance.
  ///
  /// In ko, this message translates to:
  /// **'내 주변 거리 보기'**
  String get storeSortByDistance;

  /// No description provided for @storeLoadFailed.
  ///
  /// In ko, this message translates to:
  /// **'매장 정보를 불러오지 못했습니다.'**
  String get storeLoadFailed;

  /// No description provided for @storeSortHint.
  ///
  /// In ko, this message translates to:
  /// **'우측 상단 버튼을 누르면 내 위치에서 가까운 순으로 정렬됩니다.'**
  String get storeSortHint;

  /// No description provided for @storeSortedByDistance.
  ///
  /// In ko, this message translates to:
  /// **'내 위치에서 가까운 순으로 정렬되었습니다.'**
  String get storeSortedByDistance;

  /// No description provided for @storeHoursSummary.
  ///
  /// In ko, this message translates to:
  /// **'평일 {weekday} · 주말 {weekend}'**
  String storeHoursSummary(String weekday, String weekend);

  /// No description provided for @storeDetailTitle.
  ///
  /// In ko, this message translates to:
  /// **'매장 정보'**
  String get storeDetailTitle;

  /// No description provided for @storeNotFound.
  ///
  /// In ko, this message translates to:
  /// **'문 닫은 매장이거나 없는 매장입니다.'**
  String get storeNotFound;

  /// No description provided for @storeDistanceFromYou.
  ///
  /// In ko, this message translates to:
  /// **'내 위치에서 {distance}'**
  String storeDistanceFromYou(String distance);

  /// No description provided for @storeCongestionMeasured.
  ///
  /// In ko, this message translates to:
  /// **'진행 중인 주문 {count}건으로 자동 집계했어요.'**
  String storeCongestionMeasured(int count);

  /// No description provided for @storeHoursUnknown.
  ///
  /// In ko, this message translates to:
  /// **'영업시간 정보가 없습니다.'**
  String get storeHoursUnknown;

  /// No description provided for @storeHoursToday.
  ///
  /// In ko, this message translates to:
  /// **'오늘 {hours}'**
  String storeHoursToday(String hours);

  /// No description provided for @storeSectionHours.
  ///
  /// In ko, this message translates to:
  /// **'영업시간'**
  String get storeSectionHours;

  /// No description provided for @storeHoursWeekday.
  ///
  /// In ko, this message translates to:
  /// **'평일'**
  String get storeHoursWeekday;

  /// No description provided for @storeHoursWeekend.
  ///
  /// In ko, this message translates to:
  /// **'주말'**
  String get storeHoursWeekend;

  /// No description provided for @storeSectionFacilities.
  ///
  /// In ko, this message translates to:
  /// **'편의시설'**
  String get storeSectionFacilities;

  /// No description provided for @storeNoticeTitle.
  ///
  /// In ko, this message translates to:
  /// **'매장 공지'**
  String get storeNoticeTitle;

  /// No description provided for @storeNoInfo.
  ///
  /// In ko, this message translates to:
  /// **'정보 없음'**
  String get storeNoInfo;

  /// No description provided for @storeLocationServiceOff.
  ///
  /// In ko, this message translates to:
  /// **'위치 서비스가 꺼져 있습니다. 설정에서 위치 서비스를 켜주세요.'**
  String get storeLocationServiceOff;

  /// No description provided for @storeLocationPermissionDenied.
  ///
  /// In ko, this message translates to:
  /// **'위치 권한이 없어 거리를 계산할 수 없습니다.'**
  String get storeLocationPermissionDenied;

  /// No description provided for @roastLight.
  ///
  /// In ko, this message translates to:
  /// **'라이트'**
  String get roastLight;

  /// No description provided for @roastMediumLight.
  ///
  /// In ko, this message translates to:
  /// **'미디엄 라이트'**
  String get roastMediumLight;

  /// No description provided for @roastMedium.
  ///
  /// In ko, this message translates to:
  /// **'미디엄'**
  String get roastMedium;

  /// No description provided for @roastMediumDark.
  ///
  /// In ko, this message translates to:
  /// **'미디엄 다크'**
  String get roastMediumDark;

  /// No description provided for @roastDark.
  ///
  /// In ko, this message translates to:
  /// **'다크'**
  String get roastDark;

  /// No description provided for @grindWholeBean.
  ///
  /// In ko, this message translates to:
  /// **'홀빈'**
  String get grindWholeBean;

  /// No description provided for @grindWholeBeanNote.
  ///
  /// In ko, this message translates to:
  /// **'분쇄하지 않은 원두 그대로'**
  String get grindWholeBeanNote;

  /// No description provided for @grindEspresso.
  ///
  /// In ko, this message translates to:
  /// **'에스프레소'**
  String get grindEspresso;

  /// No description provided for @grindEspressoNote.
  ///
  /// In ko, this message translates to:
  /// **'가정용 에스프레소 머신용'**
  String get grindEspressoNote;

  /// No description provided for @grindMokaPot.
  ///
  /// In ko, this message translates to:
  /// **'모카포트'**
  String get grindMokaPot;

  /// No description provided for @grindMokaPotNote.
  ///
  /// In ko, this message translates to:
  /// **'모카포트 추출용'**
  String get grindMokaPotNote;

  /// No description provided for @grindHandDrip.
  ///
  /// In ko, this message translates to:
  /// **'핸드드립'**
  String get grindHandDrip;

  /// No description provided for @grindHandDripNote.
  ///
  /// In ko, this message translates to:
  /// **'푸어오버·드리퍼용'**
  String get grindHandDripNote;

  /// No description provided for @grindFrenchPress.
  ///
  /// In ko, this message translates to:
  /// **'프렌치프레스'**
  String get grindFrenchPress;

  /// No description provided for @grindFrenchPressNote.
  ///
  /// In ko, this message translates to:
  /// **'침출식 추출용'**
  String get grindFrenchPressNote;

  /// No description provided for @subscriptionCycleWeekly.
  ///
  /// In ko, this message translates to:
  /// **'매주'**
  String get subscriptionCycleWeekly;

  /// No description provided for @subscriptionCycleBiweekly.
  ///
  /// In ko, this message translates to:
  /// **'격주'**
  String get subscriptionCycleBiweekly;

  /// No description provided for @subscriptionCycleMonthly.
  ///
  /// In ko, this message translates to:
  /// **'매월'**
  String get subscriptionCycleMonthly;

  /// No description provided for @subscriptionStatusActive.
  ///
  /// In ko, this message translates to:
  /// **'구독 중'**
  String get subscriptionStatusActive;

  /// No description provided for @subscriptionStatusPaused.
  ///
  /// In ko, this message translates to:
  /// **'일시정지'**
  String get subscriptionStatusPaused;

  /// No description provided for @subscriptionStatusCancelled.
  ///
  /// In ko, this message translates to:
  /// **'해지됨'**
  String get subscriptionStatusCancelled;

  /// No description provided for @beanOrderStatusReceived.
  ///
  /// In ko, this message translates to:
  /// **'주문 접수'**
  String get beanOrderStatusReceived;

  /// No description provided for @beanOrderStatusRoasting.
  ///
  /// In ko, this message translates to:
  /// **'로스팅 중'**
  String get beanOrderStatusRoasting;

  /// No description provided for @beanOrderStatusShipped.
  ///
  /// In ko, this message translates to:
  /// **'발송 완료'**
  String get beanOrderStatusShipped;

  /// No description provided for @beanOrderStatusDelivered.
  ///
  /// In ko, this message translates to:
  /// **'배송 완료'**
  String get beanOrderStatusDelivered;

  /// No description provided for @beanOrderStatusReady.
  ///
  /// In ko, this message translates to:
  /// **'픽업 대기'**
  String get beanOrderStatusReady;

  /// No description provided for @beanOrderStatusPickedUp.
  ///
  /// In ko, this message translates to:
  /// **'픽업 완료'**
  String get beanOrderStatusPickedUp;

  /// No description provided for @beanOrderStatusCancelled.
  ///
  /// In ko, this message translates to:
  /// **'주문 취소'**
  String get beanOrderStatusCancelled;

  /// No description provided for @fulfillmentDelivery.
  ///
  /// In ko, this message translates to:
  /// **'택배 배송'**
  String get fulfillmentDelivery;

  /// No description provided for @fulfillmentPickup.
  ///
  /// In ko, this message translates to:
  /// **'매장 픽업'**
  String get fulfillmentPickup;

  /// No description provided for @pickupStatusReceived.
  ///
  /// In ko, this message translates to:
  /// **'주문 접수'**
  String get pickupStatusReceived;

  /// No description provided for @pickupStatusPreparing.
  ///
  /// In ko, this message translates to:
  /// **'제조 중'**
  String get pickupStatusPreparing;

  /// No description provided for @pickupStatusReady.
  ///
  /// In ko, this message translates to:
  /// **'픽업 대기'**
  String get pickupStatusReady;

  /// No description provided for @pickupStatusPickedUp.
  ///
  /// In ko, this message translates to:
  /// **'픽업 완료'**
  String get pickupStatusPickedUp;

  /// No description provided for @pickupStatusCancelled.
  ///
  /// In ko, this message translates to:
  /// **'주문 취소'**
  String get pickupStatusCancelled;

  /// No description provided for @refundStatusPending.
  ///
  /// In ko, this message translates to:
  /// **'환불 처리 중'**
  String get refundStatusPending;

  /// No description provided for @refundStatusDone.
  ///
  /// In ko, this message translates to:
  /// **'환불 완료'**
  String get refundStatusDone;

  /// No description provided for @refundStatusFailed.
  ///
  /// In ko, this message translates to:
  /// **'환불 확인 중'**
  String get refundStatusFailed;

  /// No description provided for @wholesaleStatusRequested.
  ///
  /// In ko, this message translates to:
  /// **'견적 확인 중'**
  String get wholesaleStatusRequested;

  /// No description provided for @wholesaleStatusQuoted.
  ///
  /// In ko, this message translates to:
  /// **'견적서 발송'**
  String get wholesaleStatusQuoted;

  /// No description provided for @wholesaleStatusConfirmed.
  ///
  /// In ko, this message translates to:
  /// **'주문 확정'**
  String get wholesaleStatusConfirmed;

  /// No description provided for @orderItemsSummary.
  ///
  /// In ko, this message translates to:
  /// **'{first} 외 {others}건'**
  String orderItemsSummary(String first, int others);

  /// No description provided for @orderTypePickup.
  ///
  /// In ko, this message translates to:
  /// **'픽업'**
  String get orderTypePickup;

  /// No description provided for @orderTypeBean.
  ///
  /// In ko, this message translates to:
  /// **'원두'**
  String get orderTypeBean;

  /// No description provided for @orderRecipientUnset.
  ///
  /// In ko, this message translates to:
  /// **'수령인 미지정'**
  String get orderRecipientUnset;

  /// No description provided for @orderStoreUnset.
  ///
  /// In ko, this message translates to:
  /// **'매장 미지정'**
  String get orderStoreUnset;

  /// No description provided for @beanOptionLabel.
  ///
  /// In ko, this message translates to:
  /// **'{weight} · {grind}'**
  String beanOptionLabel(String weight, String grind);

  /// No description provided for @beanQuantity.
  ///
  /// In ko, this message translates to:
  /// **'{name} {count}개'**
  String beanQuantity(String name, int count);

  /// No description provided for @subscriptionCycleQuantity.
  ///
  /// In ko, this message translates to:
  /// **'{cycle} {count}개'**
  String subscriptionCycleQuantity(String cycle, int count);

  /// No description provided for @beansLoadFailed.
  ///
  /// In ko, this message translates to:
  /// **'원두 정보를 불러오지 못했습니다.'**
  String get beansLoadFailed;

  /// No description provided for @beansFilterAcidic.
  ///
  /// In ko, this message translates to:
  /// **'산미가 화사한 원두'**
  String get beansFilterAcidic;

  /// No description provided for @beansFilterAcidicNote.
  ///
  /// In ko, this message translates to:
  /// **'과일처럼 밝고 산뜻한 맛을 좋아한다면'**
  String get beansFilterAcidicNote;

  /// No description provided for @beansFilterMellow.
  ///
  /// In ko, this message translates to:
  /// **'산미 적은 고소한 원두'**
  String get beansFilterMellow;

  /// No description provided for @beansFilterMellowNote.
  ///
  /// In ko, this message translates to:
  /// **'산미 부담 없이 고소하고 묵직한 한 잔을 원한다면'**
  String get beansFilterMellowNote;

  /// No description provided for @beansFilterDecaf.
  ///
  /// In ko, this message translates to:
  /// **'디카페인'**
  String get beansFilterDecaf;

  /// No description provided for @beansFilterDecafNote.
  ///
  /// In ko, this message translates to:
  /// **'늦은 오후에도 카페인 걱정 없이'**
  String get beansFilterDecafNote;

  /// No description provided for @beansCartCount.
  ///
  /// In ko, this message translates to:
  /// **'장바구니 · {count}개'**
  String beansCartCount(int count);

  /// No description provided for @beansRoastNotice.
  ///
  /// In ko, this message translates to:
  /// **'매주 화요일 로스팅한 원두를 홀빈 또는 원하는 분쇄도로 보내드립니다.'**
  String get beansRoastNotice;

  /// No description provided for @beansRoastOf.
  ///
  /// In ko, this message translates to:
  /// **'{origin} · {roast} 로스팅'**
  String beansRoastOf(String origin, String roast);

  /// No description provided for @beansPricePer200g.
  ///
  /// In ko, this message translates to:
  /// **'200g 기준'**
  String get beansPricePer200g;

  /// No description provided for @beanNotFound.
  ///
  /// In ko, this message translates to:
  /// **'원두를 찾을 수 없습니다: {beanId}'**
  String beanNotFound(String beanId);

  /// No description provided for @beanCartTitle.
  ///
  /// In ko, this message translates to:
  /// **'원두 장바구니'**
  String get beanCartTitle;

  /// No description provided for @beanCartEmptyTitle.
  ///
  /// In ko, this message translates to:
  /// **'장바구니가 비어 있어요'**
  String get beanCartEmptyTitle;

  /// No description provided for @beanCartEmptyDetail.
  ///
  /// In ko, this message translates to:
  /// **'마음에 드는 원두를 담아보세요.'**
  String get beanCartEmptyDetail;

  /// No description provided for @beanCartBrowse.
  ///
  /// In ko, this message translates to:
  /// **'원두 보러 가기'**
  String get beanCartBrowse;

  /// No description provided for @beanCartFulfillment.
  ///
  /// In ko, this message translates to:
  /// **'수령 방법'**
  String get beanCartFulfillment;

  /// No description provided for @beanCartNoAddress.
  ///
  /// In ko, this message translates to:
  /// **'등록된 배송지가 없어요. 배송지를 추가해 주세요.'**
  String get beanCartNoAddress;

  /// No description provided for @beanCartAddAddress.
  ///
  /// In ko, this message translates to:
  /// **'배송지 추가'**
  String get beanCartAddAddress;

  /// No description provided for @beanCartChange.
  ///
  /// In ko, this message translates to:
  /// **'변경'**
  String get beanCartChange;

  /// No description provided for @beanCartNoStore.
  ///
  /// In ko, this message translates to:
  /// **'원두를 픽업할 매장을 선택해 주세요.'**
  String get beanCartNoStore;

  /// No description provided for @beanCartChooseStore.
  ///
  /// In ko, this message translates to:
  /// **'매장 선택'**
  String get beanCartChooseStore;

  /// No description provided for @beanCartAddressSheetTitle.
  ///
  /// In ko, this message translates to:
  /// **'배송지 선택'**
  String get beanCartAddressSheetTitle;

  /// No description provided for @beanCartAddressSheetDetail.
  ///
  /// In ko, this message translates to:
  /// **'원두를 받을 배송지를 선택해 주세요.'**
  String get beanCartAddressSheetDetail;

  /// No description provided for @beanCartAddressLoadFailed.
  ///
  /// In ko, this message translates to:
  /// **'배송지를 불러오지 못했습니다.'**
  String get beanCartAddressLoadFailed;

  /// No description provided for @beanCartManageAddresses.
  ///
  /// In ko, this message translates to:
  /// **'배송지 관리'**
  String get beanCartManageAddresses;

  /// No description provided for @beanCartClose.
  ///
  /// In ko, this message translates to:
  /// **'닫기'**
  String get beanCartClose;

  /// No description provided for @beanCartDefaultAddress.
  ///
  /// In ko, this message translates to:
  /// **'기본 배송지'**
  String get beanCartDefaultAddress;

  /// No description provided for @beanCartStoreSheetTitle.
  ///
  /// In ko, this message translates to:
  /// **'픽업 매장 선택'**
  String get beanCartStoreSheetTitle;

  /// No description provided for @beanCartStoreSheetDetail.
  ///
  /// In ko, this message translates to:
  /// **'로스팅이 끝나면 선택한 매장에서 픽업할 수 있어요.'**
  String get beanCartStoreSheetDetail;

  /// No description provided for @beanCartStoreLoadFailed.
  ///
  /// In ko, this message translates to:
  /// **'매장 정보를 불러오지 못했습니다.'**
  String get beanCartStoreLoadFailed;

  /// No description provided for @beanCartRemoved.
  ///
  /// In ko, this message translates to:
  /// **'{name}을(를) 장바구니에서 뺐어요.'**
  String beanCartRemoved(String name);

  /// No description provided for @beanCartUndo.
  ///
  /// In ko, this message translates to:
  /// **'실행취소'**
  String get beanCartUndo;

  /// No description provided for @beanCartDelete.
  ///
  /// In ko, this message translates to:
  /// **'삭제'**
  String get beanCartDelete;

  /// No description provided for @beanCartNeedAddress.
  ///
  /// In ko, this message translates to:
  /// **'배송지를 먼저 등록해 주세요.'**
  String get beanCartNeedAddress;

  /// No description provided for @beanCartNeedStore.
  ///
  /// In ko, this message translates to:
  /// **'픽업 매장을 먼저 선택해 주세요.'**
  String get beanCartNeedStore;

  /// No description provided for @beanCartPaymentIncomplete.
  ///
  /// In ko, this message translates to:
  /// **'결제가 완료되지 않았습니다.'**
  String get beanCartPaymentIncomplete;

  /// No description provided for @beanCartOrderedWithPoints.
  ///
  /// In ko, this message translates to:
  /// **'원두 주문이 접수되었습니다. {points}P가 적립됐어요.'**
  String beanCartOrderedWithPoints(String points);

  /// No description provided for @beanCartOrderedPickup.
  ///
  /// In ko, this message translates to:
  /// **'원두 주문이 접수되었습니다. 로스팅 후 매장에서 픽업하실 수 있어요.'**
  String get beanCartOrderedPickup;

  /// No description provided for @beanCartOrderedDelivery.
  ///
  /// In ko, this message translates to:
  /// **'원두 주문이 접수되었습니다. 로스팅 후 순차 발송됩니다.'**
  String get beanCartOrderedDelivery;

  /// No description provided for @beanCartOrderFailed.
  ///
  /// In ko, this message translates to:
  /// **'주문 처리에 실패했습니다. 다시 시도해 주세요.'**
  String get beanCartOrderFailed;

  /// No description provided for @beanCartCouponsApplied.
  ///
  /// In ko, this message translates to:
  /// **'쿠폰 {count}장 적용'**
  String beanCartCouponsApplied(int count);

  /// No description provided for @beanCartNoUsableCoupons.
  ///
  /// In ko, this message translates to:
  /// **'적용 가능한 쿠폰이 없어요'**
  String get beanCartNoUsableCoupons;

  /// No description provided for @beanCartUsableCoupons.
  ///
  /// In ko, this message translates to:
  /// **'사용 가능한 쿠폰 {count}장'**
  String beanCartUsableCoupons(int count);

  /// No description provided for @beanCartChooseCoupon.
  ///
  /// In ko, this message translates to:
  /// **'쿠폰 선택'**
  String get beanCartChooseCoupon;

  /// No description provided for @beanCartUsePoints.
  ///
  /// In ko, this message translates to:
  /// **'포인트 사용 (보유 {balance}P)'**
  String beanCartUsePoints(String balance);

  /// No description provided for @beanCartNoPoints.
  ///
  /// In ko, this message translates to:
  /// **'사용 가능한 포인트가 없어요'**
  String get beanCartNoPoints;

  /// No description provided for @beanCartItemCount.
  ///
  /// In ko, this message translates to:
  /// **'총 {count}개'**
  String beanCartItemCount(int count);

  /// No description provided for @beanCartOrdering.
  ///
  /// In ko, this message translates to:
  /// **'주문 중...'**
  String get beanCartOrdering;

  /// No description provided for @beanCartPay.
  ///
  /// In ko, this message translates to:
  /// **'결제하기'**
  String get beanCartPay;

  /// No description provided for @beanCartOrder.
  ///
  /// In ko, this message translates to:
  /// **'주문하기'**
  String get beanCartOrder;

  /// No description provided for @discountAmount.
  ///
  /// In ko, this message translates to:
  /// **'-{amount}원'**
  String discountAmount(String amount);

  /// No description provided for @beanDetailTitle.
  ///
  /// In ko, this message translates to:
  /// **'원두 상세'**
  String get beanDetailTitle;

  /// No description provided for @beanRoastBadge.
  ///
  /// In ko, this message translates to:
  /// **'{roast} 로스팅'**
  String beanRoastBadge(String roast);

  /// No description provided for @beanSectionNotes.
  ///
  /// In ko, this message translates to:
  /// **'향미 노트'**
  String get beanSectionNotes;

  /// No description provided for @beanSectionProfile.
  ///
  /// In ko, this message translates to:
  /// **'테이스팅 프로필'**
  String get beanSectionProfile;

  /// No description provided for @beanProfileAcidity.
  ///
  /// In ko, this message translates to:
  /// **'산미'**
  String get beanProfileAcidity;

  /// No description provided for @beanProfileBody.
  ///
  /// In ko, this message translates to:
  /// **'바디'**
  String get beanProfileBody;

  /// No description provided for @beanProfileSweetness.
  ///
  /// In ko, this message translates to:
  /// **'단맛'**
  String get beanProfileSweetness;

  /// No description provided for @beanSectionStory.
  ///
  /// In ko, this message translates to:
  /// **'원두 이야기'**
  String get beanSectionStory;

  /// No description provided for @beanSectionDetails.
  ///
  /// In ko, this message translates to:
  /// **'상세 정보'**
  String get beanSectionDetails;

  /// No description provided for @beanFieldOrigin.
  ///
  /// In ko, this message translates to:
  /// **'원산지'**
  String get beanFieldOrigin;

  /// No description provided for @beanFieldProcess.
  ///
  /// In ko, this message translates to:
  /// **'가공 방식'**
  String get beanFieldProcess;

  /// No description provided for @beanFieldRoast.
  ///
  /// In ko, this message translates to:
  /// **'로스팅'**
  String get beanFieldRoast;

  /// No description provided for @beanFieldBrews.
  ///
  /// In ko, this message translates to:
  /// **'추천 추출'**
  String get beanFieldBrews;

  /// No description provided for @beanFieldPrice.
  ///
  /// In ko, this message translates to:
  /// **'가격'**
  String get beanFieldPrice;

  /// No description provided for @beanPriceBoth.
  ///
  /// In ko, this message translates to:
  /// **'200g {price200}원 · 500g {price500}원'**
  String beanPriceBoth(String price200, String price500);

  /// No description provided for @beanCartTooltip.
  ///
  /// In ko, this message translates to:
  /// **'원두 장바구니'**
  String get beanCartTooltip;

  /// No description provided for @beanGiftTooltip.
  ///
  /// In ko, this message translates to:
  /// **'선물하기'**
  String get beanGiftTooltip;

  /// No description provided for @beanSubscribe.
  ///
  /// In ko, this message translates to:
  /// **'구독'**
  String get beanSubscribe;

  /// No description provided for @beanSoldOut.
  ///
  /// In ko, this message translates to:
  /// **'품절'**
  String get beanSoldOut;

  /// No description provided for @beanOrder.
  ///
  /// In ko, this message translates to:
  /// **'주문하기'**
  String get beanOrder;

  /// No description provided for @beanGiftRequiresSignIn.
  ///
  /// In ko, this message translates to:
  /// **'원두 선물하기는 로그인 후 이용할 수 있어요.'**
  String get beanGiftRequiresSignIn;

  /// No description provided for @beanOrderRequiresSignIn.
  ///
  /// In ko, this message translates to:
  /// **'원두 주문은 로그인 후 이용할 수 있어요.'**
  String get beanOrderRequiresSignIn;

  /// No description provided for @beanAddedToCart.
  ///
  /// In ko, this message translates to:
  /// **'{name}을(를) 장바구니에 담았습니다.'**
  String beanAddedToCart(String name);

  /// No description provided for @beanViewCart.
  ///
  /// In ko, this message translates to:
  /// **'보기'**
  String get beanViewCart;

  /// No description provided for @beanFieldWeight.
  ///
  /// In ko, this message translates to:
  /// **'용량'**
  String get beanFieldWeight;

  /// No description provided for @beanFieldGrind.
  ///
  /// In ko, this message translates to:
  /// **'분쇄도'**
  String get beanFieldGrind;

  /// No description provided for @beanFieldQuantity.
  ///
  /// In ko, this message translates to:
  /// **'수량'**
  String get beanFieldQuantity;

  /// No description provided for @beanTotalPrice.
  ///
  /// In ko, this message translates to:
  /// **'총 결제 금액'**
  String get beanTotalPrice;

  /// No description provided for @beanAddToCart.
  ///
  /// In ko, this message translates to:
  /// **'장바구니 담기'**
  String get beanAddToCart;

  /// No description provided for @beanOrderForAmount.
  ///
  /// In ko, this message translates to:
  /// **'{amount}원 주문'**
  String beanOrderForAmount(String amount);

  /// No description provided for @subscriptionRequiresSignIn.
  ///
  /// In ko, this message translates to:
  /// **'원두 구독은 로그인 후 이용할 수 있어요.'**
  String get subscriptionRequiresSignIn;

  /// No description provided for @subscriptionStarted.
  ///
  /// In ko, this message translates to:
  /// **'{bean} {cycle} 정기구독이 시작되었습니다.'**
  String subscriptionStarted(String bean, String cycle);

  /// No description provided for @subscriptionManage.
  ///
  /// In ko, this message translates to:
  /// **'구독 관리'**
  String get subscriptionManage;

  /// No description provided for @subscriptionTitle.
  ///
  /// In ko, this message translates to:
  /// **'원두 정기구독'**
  String get subscriptionTitle;

  /// No description provided for @subscriptionFieldCycle.
  ///
  /// In ko, this message translates to:
  /// **'배송 주기'**
  String get subscriptionFieldCycle;

  /// No description provided for @subscriptionFieldQuantity.
  ///
  /// In ko, this message translates to:
  /// **'회당 수량'**
  String get subscriptionFieldQuantity;

  /// No description provided for @subscriptionFieldPrice.
  ///
  /// In ko, this message translates to:
  /// **'회당 결제 금액'**
  String get subscriptionFieldPrice;

  /// No description provided for @subscriptionNotice.
  ///
  /// In ko, this message translates to:
  /// **'{cycle} 로스팅한 원두를 배송해 드려요. 언제든 일시정지·해지할 수 있어요.'**
  String subscriptionNotice(String cycle);

  /// No description provided for @subscriptionStart.
  ///
  /// In ko, this message translates to:
  /// **'{cycle} 구독 시작하기'**
  String subscriptionStart(String cycle);

  /// No description provided for @subscriptionEveryDays.
  ///
  /// In ko, this message translates to:
  /// **'{days}일마다'**
  String subscriptionEveryDays(int days);

  /// No description provided for @subscriptionListTitle.
  ///
  /// In ko, this message translates to:
  /// **'원두 정기구독'**
  String get subscriptionListTitle;

  /// No description provided for @subscriptionLoadFailed.
  ///
  /// In ko, this message translates to:
  /// **'구독 정보를 불러오지 못했습니다.'**
  String get subscriptionLoadFailed;

  /// No description provided for @subscriptionEmptyTitle.
  ///
  /// In ko, this message translates to:
  /// **'구독 중인 원두가 없어요'**
  String get subscriptionEmptyTitle;

  /// No description provided for @subscriptionEmptyDetail.
  ///
  /// In ko, this message translates to:
  /// **'원두 상세에서 정기구독을 시작하면 주기마다 배송해 드려요.'**
  String get subscriptionEmptyDetail;

  /// No description provided for @subscriptionBrowse.
  ///
  /// In ko, this message translates to:
  /// **'원두 보러 가기'**
  String get subscriptionBrowse;

  /// No description provided for @subscriptionCancelTitle.
  ///
  /// In ko, this message translates to:
  /// **'구독 해지'**
  String get subscriptionCancelTitle;

  /// No description provided for @subscriptionCancelConfirm.
  ///
  /// In ko, this message translates to:
  /// **'{bean} 정기구독을 해지할까요?\n해지 후에는 배송이 중단됩니다.'**
  String subscriptionCancelConfirm(String bean);

  /// No description provided for @subscriptionCancelled.
  ///
  /// In ko, this message translates to:
  /// **'{bean} 구독이 해지되었습니다.'**
  String subscriptionCancelled(String bean);

  /// No description provided for @subscriptionStartedOn.
  ///
  /// In ko, this message translates to:
  /// **'구독 시작 {date}'**
  String subscriptionStartedOn(String date);

  /// No description provided for @subscriptionNextDelivery.
  ///
  /// In ko, this message translates to:
  /// **'다음 배송 {date}'**
  String subscriptionNextDelivery(String date);

  /// No description provided for @subscriptionPricePerDelivery.
  ///
  /// In ko, this message translates to:
  /// **'회당 {amount}원'**
  String subscriptionPricePerDelivery(String amount);

  /// No description provided for @subscriptionResume.
  ///
  /// In ko, this message translates to:
  /// **'구독 재개'**
  String get subscriptionResume;

  /// No description provided for @subscriptionPause.
  ///
  /// In ko, this message translates to:
  /// **'일시정지'**
  String get subscriptionPause;

  /// No description provided for @subscriptionCancelAction.
  ///
  /// In ko, this message translates to:
  /// **'해지하기'**
  String get subscriptionCancelAction;

  /// No description provided for @commonCancel.
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get commonCancel;

  /// No description provided for @adminOrdersTitle.
  ///
  /// In ko, this message translates to:
  /// **'주문 관리'**
  String get adminOrdersTitle;

  /// No description provided for @adminOrdersRefresh.
  ///
  /// In ko, this message translates to:
  /// **'새로고침'**
  String get adminOrdersRefresh;

  /// No description provided for @adminOrdersTabRefundFailed.
  ///
  /// In ko, this message translates to:
  /// **'환불 실패'**
  String get adminOrdersTabRefundFailed;

  /// No description provided for @adminOrdersNoPickup.
  ///
  /// In ko, this message translates to:
  /// **'처리할 픽업 주문이 없습니다.'**
  String get adminOrdersNoPickup;

  /// No description provided for @adminOrdersNoBean.
  ///
  /// In ko, this message translates to:
  /// **'처리할 원두 주문이 없습니다.'**
  String get adminOrdersNoBean;

  /// No description provided for @adminOrdersNoRefundFailures.
  ///
  /// In ko, this message translates to:
  /// **'환불이 밀린 주문이 없습니다.'**
  String get adminOrdersNoRefundFailures;

  /// No description provided for @adminOrdersRefunded.
  ///
  /// In ko, this message translates to:
  /// **'환불했습니다.'**
  String get adminOrdersRefunded;

  /// No description provided for @adminOrdersRefundFailed.
  ///
  /// In ko, this message translates to:
  /// **'환불에 실패했습니다: {error}'**
  String adminOrdersRefundFailed(String error);

  /// No description provided for @adminOrdersRefundFailedLabel.
  ///
  /// In ko, this message translates to:
  /// **'{type} · 환불 실패'**
  String adminOrdersRefundFailedLabel(String type);

  /// No description provided for @adminOrdersRetryRefund.
  ///
  /// In ko, this message translates to:
  /// **'환불 재시도'**
  String get adminOrdersRetryRefund;

  /// No description provided for @adminOrdersAdvanceFailed.
  ///
  /// In ko, this message translates to:
  /// **'상태를 바꾸지 못했습니다'**
  String get adminOrdersAdvanceFailed;

  /// No description provided for @adminOrdersCancelTitle.
  ///
  /// In ko, this message translates to:
  /// **'주문을 취소할까요?'**
  String get adminOrdersCancelTitle;

  /// No description provided for @adminOrdersCancelBody.
  ///
  /// In ko, this message translates to:
  /// **'{summary} 주문을 취소합니다.\n사용한 포인트와 쿠폰을 돌려주고 결제한 금액을 환불합니다.'**
  String adminOrdersCancelBody(String summary);

  /// No description provided for @adminOrdersCancelFailed.
  ///
  /// In ko, this message translates to:
  /// **'주문을 취소하지 못했습니다'**
  String get adminOrdersCancelFailed;

  /// No description provided for @adminOrdersCancelAction.
  ///
  /// In ko, this message translates to:
  /// **'주문 취소'**
  String get adminOrdersCancelAction;

  /// No description provided for @adminOrdersAdvanceTo.
  ///
  /// In ko, this message translates to:
  /// **'{status}로'**
  String adminOrdersAdvanceTo(String status);

  /// No description provided for @adminOrdersLoadFailed.
  ///
  /// In ko, this message translates to:
  /// **'주문을 불러오지 못했습니다.'**
  String get adminOrdersLoadFailed;

  /// No description provided for @commonClose.
  ///
  /// In ko, this message translates to:
  /// **'닫기'**
  String get commonClose;

  /// No description provided for @orderHistoryTitle.
  ///
  /// In ko, this message translates to:
  /// **'주문 내역'**
  String get orderHistoryTitle;

  /// No description provided for @orderHistoryLoadFailed.
  ///
  /// In ko, this message translates to:
  /// **'주문 내역을 불러오지 못했습니다.'**
  String get orderHistoryLoadFailed;

  /// No description provided for @orderHistoryEmptyTitle.
  ///
  /// In ko, this message translates to:
  /// **'주문 내역이 없어요'**
  String get orderHistoryEmptyTitle;

  /// No description provided for @orderHistoryEmptyDetail.
  ///
  /// In ko, this message translates to:
  /// **'매장 결제나 픽업 · 원두 주문을 하면 내역이 쌓여요.'**
  String get orderHistoryEmptyDetail;

  /// No description provided for @orderCouponDiscount.
  ///
  /// In ko, this message translates to:
  /// **'쿠폰 -{amount}원'**
  String orderCouponDiscount(String amount);

  /// No description provided for @orderPointsUsed.
  ///
  /// In ko, this message translates to:
  /// **'-{amount}P 사용'**
  String orderPointsUsed(String amount);

  /// No description provided for @orderPointsEarned.
  ///
  /// In ko, this message translates to:
  /// **'+{amount}P 적립'**
  String orderPointsEarned(String amount);

  /// No description provided for @orderBeanLabel.
  ///
  /// In ko, this message translates to:
  /// **'원두 주문'**
  String get orderBeanLabel;

  /// No description provided for @orderItemCount.
  ///
  /// In ko, this message translates to:
  /// **'총 {count}개'**
  String orderItemCount(int count);

  /// No description provided for @orderReorder.
  ///
  /// In ko, this message translates to:
  /// **'재주문'**
  String get orderReorder;

  /// No description provided for @orderCancel.
  ///
  /// In ko, this message translates to:
  /// **'주문 취소'**
  String get orderCancel;

  /// No description provided for @orderReorderUnavailableBeans.
  ///
  /// In ko, this message translates to:
  /// **'지금은 판매하지 않는 상품이라 재주문할 수 없어요.'**
  String get orderReorderUnavailableBeans;

  /// No description provided for @orderReorderUnavailableMenu.
  ///
  /// In ko, this message translates to:
  /// **'지금은 판매하지 않는 메뉴라 재주문할 수 없어요.'**
  String get orderReorderUnavailableMenu;

  /// No description provided for @orderReorderPartialBeans.
  ///
  /// In ko, this message translates to:
  /// **'판매 종료된 {names} 상품은 제외하고 장바구니에 담았어요.'**
  String orderReorderPartialBeans(String names);

  /// No description provided for @orderReorderPartialMenu.
  ///
  /// In ko, this message translates to:
  /// **'판매 종료된 {names} 메뉴는 제외하고 장바구니에 담았어요.'**
  String orderReorderPartialMenu(String names);

  /// No description provided for @orderReorderDone.
  ///
  /// In ko, this message translates to:
  /// **'이전 주문 구성을 장바구니에 담았어요.'**
  String get orderReorderDone;

  /// No description provided for @orderCancelBeanTitle.
  ///
  /// In ko, this message translates to:
  /// **'원두 주문을 취소할까요?'**
  String get orderCancelBeanTitle;

  /// No description provided for @orderCancelledNotice.
  ///
  /// In ko, this message translates to:
  /// **'주문이 취소되었어요. 사용한 쿠폰과 포인트는 복구됩니다.'**
  String get orderCancelledNotice;

  /// No description provided for @orderPickupSummary.
  ///
  /// In ko, this message translates to:
  /// **'픽업 주문 · {store} · 주문번호 {number}번 · 총 {count}개'**
  String orderPickupSummary(String store, int number, int count);

  /// No description provided for @orderTrackStatus.
  ///
  /// In ko, this message translates to:
  /// **'주문 현황 보기'**
  String get orderTrackStatus;

  /// No description provided for @orderWriteReview.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 쓰기'**
  String get orderWriteReview;

  /// No description provided for @pickupOptionTitle.
  ///
  /// In ko, this message translates to:
  /// **'옵션'**
  String get pickupOptionTitle;

  /// No description provided for @pickupTotalPrice.
  ///
  /// In ko, this message translates to:
  /// **'총 주문 금액'**
  String get pickupTotalPrice;

  /// No description provided for @pickupAddToCart.
  ///
  /// In ko, this message translates to:
  /// **'장바구니 담기'**
  String get pickupAddToCart;

  /// No description provided for @pickupCartTitle.
  ///
  /// In ko, this message translates to:
  /// **'픽업 주문'**
  String get pickupCartTitle;

  /// No description provided for @pickupCartRequiresSignIn.
  ///
  /// In ko, this message translates to:
  /// **'장바구니는 로그인 후 이용할 수 있어요.'**
  String get pickupCartRequiresSignIn;

  /// No description provided for @pickupCartTooltip.
  ///
  /// In ko, this message translates to:
  /// **'픽업 장바구니'**
  String get pickupCartTooltip;

  /// No description provided for @pickupCartEmptyTitle.
  ///
  /// In ko, this message translates to:
  /// **'장바구니가 비어 있어요'**
  String get pickupCartEmptyTitle;

  /// No description provided for @pickupCartEmptyDetail.
  ///
  /// In ko, this message translates to:
  /// **'메뉴에서 마시고 싶은 음료를 담아보세요.'**
  String get pickupCartEmptyDetail;

  /// No description provided for @pickupCartBrowse.
  ///
  /// In ko, this message translates to:
  /// **'메뉴 보러 가기'**
  String get pickupCartBrowse;

  /// No description provided for @pickupCartChooseStorePrompt.
  ///
  /// In ko, this message translates to:
  /// **'픽업 매장을 선택해 주세요'**
  String get pickupCartChooseStorePrompt;

  /// No description provided for @pickupCartStoreRequired.
  ///
  /// In ko, this message translates to:
  /// **'주문 전에 픽업할 매장이 필요해요.'**
  String get pickupCartStoreRequired;

  /// No description provided for @pickupCartRemoved.
  ///
  /// In ko, this message translates to:
  /// **'{name}을(를) 장바구니에서 뺐어요.'**
  String pickupCartRemoved(String name);

  /// No description provided for @pickupCartStoreSheetDetail.
  ///
  /// In ko, this message translates to:
  /// **'음료를 픽업할 매장을 선택해 주세요.'**
  String get pickupCartStoreSheetDetail;

  /// No description provided for @pickupCartOrderedWithPoints.
  ///
  /// In ko, this message translates to:
  /// **'픽업 주문이 접수되었습니다. 주문번호 {number}번 · {points}P가 적립됐어요.'**
  String pickupCartOrderedWithPoints(int number, String points);

  /// No description provided for @pickupCartOrdered.
  ///
  /// In ko, this message translates to:
  /// **'픽업 주문이 접수되었습니다. 주문번호 {number}번 · 준비가 끝나면 알려드릴게요.'**
  String pickupCartOrdered(int number);

  /// No description provided for @pickupTrackingTitle.
  ///
  /// In ko, this message translates to:
  /// **'주문 현황'**
  String get pickupTrackingTitle;

  /// No description provided for @pickupTrackingLoadFailed.
  ///
  /// In ko, this message translates to:
  /// **'주문 현황을 불러오지 못했습니다.'**
  String get pickupTrackingLoadFailed;

  /// No description provided for @pickupTrackingLiveNotice.
  ///
  /// In ko, this message translates to:
  /// **'주문 상태가 바뀌면 실시간으로 반영돼요.'**
  String get pickupTrackingLiveNotice;

  /// No description provided for @pickupTrackingNotFound.
  ///
  /// In ko, this message translates to:
  /// **'주문을 찾을 수 없어요'**
  String get pickupTrackingNotFound;

  /// No description provided for @pickupTrackingNotFoundDetail.
  ///
  /// In ko, this message translates to:
  /// **'주문 내역에서 다시 확인해 주세요.'**
  String get pickupTrackingNotFoundDetail;

  /// No description provided for @pickupOrderNumber.
  ///
  /// In ko, this message translates to:
  /// **'주문번호 {number}번'**
  String pickupOrderNumber(int number);

  /// No description provided for @pickupOrderedAt.
  ///
  /// In ko, this message translates to:
  /// **'{time} 주문'**
  String pickupOrderedAt(String time);

  /// No description provided for @pickupStepReceived.
  ///
  /// In ko, this message translates to:
  /// **'매장에서 주문을 확인하고 있어요.'**
  String get pickupStepReceived;

  /// No description provided for @pickupStepPreparing.
  ///
  /// In ko, this message translates to:
  /// **'바리스타가 정성껏 만들고 있어요.'**
  String get pickupStepPreparing;

  /// No description provided for @pickupStepReady.
  ///
  /// In ko, this message translates to:
  /// **'픽업대에서 주문을 찾아가세요.'**
  String get pickupStepReady;

  /// No description provided for @pickupStepPickedUp.
  ///
  /// In ko, this message translates to:
  /// **'맛있게 즐기세요. 감사합니다!'**
  String get pickupStepPickedUp;

  /// No description provided for @pickupInProgress.
  ///
  /// In ko, this message translates to:
  /// **'진행 중'**
  String get pickupInProgress;

  /// No description provided for @pickupRefundChecking.
  ///
  /// In ko, this message translates to:
  /// **'사용한 쿠폰과 포인트는 복구되었어요. 결제 환불은 확인 중이며, 오래 걸리면 고객센터로 문의해 주세요.'**
  String get pickupRefundChecking;

  /// No description provided for @pickupRefundNormal.
  ///
  /// In ko, this message translates to:
  /// **'사용한 쿠폰과 포인트는 복구되었어요. 결제 환불은 수단에 따라 3~5일 소요될 수 있어요.'**
  String get pickupRefundNormal;

  /// No description provided for @pickupCancelledTitle.
  ///
  /// In ko, this message translates to:
  /// **'주문이 취소되었어요'**
  String get pickupCancelledTitle;

  /// No description provided for @pickupCancelAction.
  ///
  /// In ko, this message translates to:
  /// **'주문 취소하기'**
  String get pickupCancelAction;

  /// No description provided for @pickupCancelTitle.
  ///
  /// In ko, this message translates to:
  /// **'픽업 주문을 취소할까요?'**
  String get pickupCancelTitle;

  /// No description provided for @pickupSectionItems.
  ///
  /// In ko, this message translates to:
  /// **'주문 상품'**
  String get pickupSectionItems;

  /// No description provided for @pickupItemQuantity.
  ///
  /// In ko, this message translates to:
  /// **'{count}개'**
  String pickupItemQuantity(int count);

  /// No description provided for @pickupPaidAmount.
  ///
  /// In ko, this message translates to:
  /// **'결제 금액'**
  String get pickupPaidAmount;
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
