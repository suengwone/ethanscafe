// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '폭스트롯';

  @override
  String get settingsAppearanceTitle => '화면 테마';

  @override
  String get settingsAppearanceThemeSection => '테마 선택';

  @override
  String get settingsAppearanceStoredOnThisDevice =>
      '고른 테마는 이 기기에만 저장됩니다. 다른 기기에서는 다시 골라 주세요.';

  @override
  String get settingsAppearancePreview => '미리보기';

  @override
  String get settingsAppearancePreviewRewards => '폭스트롯 리워드';

  @override
  String get settingsAppearancePreviewBalance => '보유 포인트 32,250P';

  @override
  String get settingsAppearancePreviewOrder => '주문하기';

  @override
  String get settingsAppearancePreviewCart => '장바구니';

  @override
  String get themeModeSystem => '시스템 설정';

  @override
  String get themeModeSystemDescription => '기기 설정을 따라 자동으로 바뀝니다';

  @override
  String get themeModeLight => '라이트';

  @override
  String get themeModeLightDescription => '밝은 배경으로 고정합니다';

  @override
  String get themeModeDark => '다크';

  @override
  String get themeModeDarkDescription => '어두운 배경으로 고정합니다';

  @override
  String get settingsLanguageTitle => '언어';

  @override
  String get settingsLanguageSection => '언어 선택';

  @override
  String get settingsLanguageSystem => '시스템 설정';

  @override
  String get settingsLanguageSystemDescription => '기기 언어를 따릅니다';

  @override
  String get settingsLanguageStoredOnThisDevice =>
      '고른 언어는 이 기기에만 저장됩니다. 다른 기기에서는 다시 골라 주세요.';

  @override
  String get settingsLanguageUnsupportedNotice =>
      '메뉴 이름과 매장 안내처럼 매장이 직접 올리는 글은 등록된 언어 그대로 보입니다.';

  @override
  String get homeGreetingGuestName => '고객';

  @override
  String homeGreetingMember(String name) {
    return '$name님,\n반가워요!';
  }

  @override
  String get homeGreetingVisitor => '폭스트롯에\n어서오세요!';

  @override
  String get homeGreetingSubtitle => '오늘도 향긋한 커피 한 잔의 여유를 즐겨보세요';

  @override
  String get homeFindStore => '매장 찾기';

  @override
  String get homeNotifications => '알림';

  @override
  String get homeSignIn => '로그인';

  @override
  String get homeQuickOrder => '주문하기';

  @override
  String get homeQuickCoupons => '쿠폰함';

  @override
  String get homeQuickOrderHistory => '주문내역';

  @override
  String get homeQuickStores => '매장찾기';

  @override
  String get homeRecommendedTitle => '이 메뉴 어때요?';

  @override
  String get homeSeeAll => '전체보기';

  @override
  String get homeRewardsTitle => '폭스트롯 리워드';

  @override
  String get homeRewardsMineTitle => '나의 리워드';

  @override
  String get homeRewardsSignInPrompt => '로그인하고\n포인트를 모아보세요';

  @override
  String homeRewardsSignInDetail(String goal) {
    return '결제 금액의 10%가 적립되고, ${goal}P를 모으면 무료 음료 쿠폰을 드려요!';
  }

  @override
  String get homeRewardsSignInAction => '로그인하기';

  @override
  String homeRewardsBalance(String balance) {
    return '${balance}P';
  }

  @override
  String homeRewardsRemaining(String remaining) {
    return '${remaining}P 더 모으면 무료 음료 쿠폰!';
  }

  @override
  String get homeRewardsGoalReached => '무료 음료 쿠폰으로 교환할 수 있어요!';

  @override
  String get bannerIconSparkles => '반짝임';

  @override
  String get bannerIconSnowflake => '눈꽃';

  @override
  String get bannerIconBean => '원두';

  @override
  String get bannerIconGift => '선물';
}
