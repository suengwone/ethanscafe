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

  @override
  String get authSignIn => '로그인';

  @override
  String get authSignedIn => '로그인되었습니다.';

  @override
  String get authSignInWithKakao => '카카오로 시작하기';

  @override
  String get authSignInWithNaver => '네이버로 시작하기';

  @override
  String get authSignInWithGoogle => '구글로 시작하기';

  @override
  String get authSignInLater => '나중에 로그인하기';

  @override
  String get businessAccountTitle => '사업자 계정';

  @override
  String get businessMissingFields => '상호명과 사업자등록번호를 입력해주세요.';

  @override
  String get businessNumberInvalid => '사업자등록번호 10자리를 다시 확인해주세요.';

  @override
  String get businessSwitched => '사업자 계정으로 전환되었습니다. 도매 홈으로 이동합니다.';

  @override
  String businessSwitchFailed(String error) {
    return '사업자 전환에 실패했습니다: $error';
  }

  @override
  String get businessSwitchFailedRetry => '사업자 전환에 실패했습니다. 다시 시도해주세요.';

  @override
  String get businessSwitchedBack => '일반 고객 계정으로 전환되었습니다.';

  @override
  String get businessIntro =>
      '사업자 계정으로 전환하면 홈 화면이 원두 도매(B2B) 화면으로 바뀌고, kg 단위 도매가로 견적을 요청할 수 있어요.';

  @override
  String get businessSectionInfo => '사업자 정보';

  @override
  String get businessFieldCompany => '상호명 *';

  @override
  String get businessFieldCompanyHint => '예) 카페 어라운드';

  @override
  String get businessFieldNumber => '사업자등록번호 *';

  @override
  String get businessFieldManager => '담당자명';

  @override
  String get businessFieldPhone => '연락처';

  @override
  String get businessSwitchAction => '사업자 계정으로 전환하기';

  @override
  String get businessSavedTitle => '등록된 사업자 정보';

  @override
  String get businessSavedIntro =>
      '이전에 등록한 사업자 정보가 있어요. 다시 입력하지 않고 바로 사업자 계정으로 전환할 수 있어요.';

  @override
  String get businessSavedSwitch => '사업자 계정으로 전환';

  @override
  String get businessSavedEdit => '사업자 정보 수정';

  @override
  String get businessLabelCompany => '상호명';

  @override
  String get businessLabelNumber => '사업자등록번호';

  @override
  String get businessLabelManager => '담당자명';

  @override
  String get businessLabelPhone => '연락처';

  @override
  String get businessActiveTitle => '사업자 계정 사용 중';

  @override
  String get businessActiveDescription =>
      '홈 화면에서 도매 원두 시세를 확인하고 견적을 요청할 수 있어요.';

  @override
  String get businessSwitchBackAction => '일반 고객 계정으로 전환';

  @override
  String priceWon(String amount) {
    return '$amount원';
  }

  @override
  String priceWonFrom(String amount) {
    return '$amount원~';
  }

  @override
  String get retry => '다시 시도';

  @override
  String get menuCategoryDrip => '드립 커피';

  @override
  String get menuCategoryDripNote => '싱글 오리진 원두 9종 · 매주 변경되는 시즌 컬렉션';

  @override
  String get menuCategoryEspresso => '에스프레소';

  @override
  String get menuCategoryEspressoNote =>
      '우유 변경 오트·아몬드·소이 +0.5 · 락토프리·저지방 +0.3\n시럽 추가 바닐라·카라멜·헤이즐넛·라벤더 +0.3';

  @override
  String get menuCategoryBeverage => '음료';

  @override
  String get menuCategoryBeverageNote => '샷 추가 딸기라떼·발로나초코라떼·말차라떼·복숭아아이스티 +0.5';

  @override
  String get menuCategoryTea => '티';

  @override
  String get menuCategoryTeaNote => '타바론(Tavalon) 프리미엄 티 컬렉션';

  @override
  String get menuCategoryDessert => '디저트';

  @override
  String get menuCategoryBeans => '원두';

  @override
  String get menuTitle => '메뉴';

  @override
  String get menuLoadFailed => '메뉴 정보를 불러오지 못했습니다.';

  @override
  String get menuDetailTitle => '메뉴 상세';

  @override
  String get menuOrderRequiresSignIn => '메뉴 주문은 로그인 후 이용할 수 있어요.';

  @override
  String menuAddedToCart(String name) {
    return '$name을(를) 장바구니에 담았습니다.';
  }

  @override
  String get menuViewCart => '보기';

  @override
  String get menuSoldOutNotice => '오늘은 준비된 재료가 떨어졌어요';

  @override
  String get menuPickupOrder => '매장 픽업 주문';

  @override
  String get menuSoldOut => '품절';

  @override
  String get menuOrder => '주문하기';

  @override
  String get menuFavoriteAdd => '즐겨찾기 등록';

  @override
  String get menuFavoriteRemove => '즐겨찾기 해제';

  @override
  String get menuFavoriteAdded => '즐겨찾기에 추가되었습니다.';

  @override
  String get menuFavoriteRemoved => '즐겨찾기에서 삭제되었습니다.';

  @override
  String get menuSectionAbout => '메뉴 소개';

  @override
  String get menuSectionOptions => '옵션 안내';

  @override
  String get menuSectionDetails => '상세 정보';

  @override
  String get menuFieldCategory => '카테고리';

  @override
  String get menuFieldPrice => '가격';

  @override
  String get menuFieldServingOptions => '제공 옵션';

  @override
  String menuNotFound(String menuId) {
    return '메뉴를 찾을 수 없습니다: $menuId';
  }

  @override
  String get favoriteMenuTitle => '즐겨찾기 메뉴';

  @override
  String get favoriteMenuLoadFailed => '즐겨찾기 메뉴를 불러오지 못했습니다.';

  @override
  String get favoriteMenuEmptyTitle => '아직 즐겨찾기한 메뉴가 없어요';

  @override
  String get favoriteMenuEmptyDetail => '메뉴 상세에서 하트를 눌러 자주 마시는 메뉴를 등록해보세요.';

  @override
  String get favoriteMenuBrowse => '메뉴 보러가기';

  @override
  String get noticeCategoryEvent => '이벤트';

  @override
  String get noticeCategoryNotice => '공지';

  @override
  String get noticeCategoryBenefit => '혜택';

  @override
  String get noticeListTitle => '알림';

  @override
  String get noticeLoadFailed => '알림을 불러오지 못했습니다.';

  @override
  String get noticeEmpty => '새로운 알림이 없어요';

  @override
  String get noticeImportant => '중요';

  @override
  String get reviewProductTypeMenu => '메뉴';

  @override
  String get reviewProductTypeBean => '원두';

  @override
  String reviewSheetTitle(String product) {
    return '$product 후기 남기기';
  }

  @override
  String get reviewSheetHint => '맛과 향은 어떠셨나요? 후기를 남겨주세요.';

  @override
  String get reviewSubmitting => '등록 중...';

  @override
  String get reviewSubmit => '후기 등록';

  @override
  String get reviewSubmitted => '소중한 후기가 등록되었습니다.';

  @override
  String get reviewSubmitFailed => '후기 등록에 실패했습니다. 다시 시도해주세요.';

  @override
  String get reviewSectionTitle => '리뷰';

  @override
  String get reviewLoadFailed => '리뷰를 불러오지 못했습니다.';

  @override
  String reviewMoreCount(int count) {
    return '외 $count개의 리뷰가 있어요.';
  }

  @override
  String get reviewEmpty => '아직 리뷰가 없어요. 주문 내역에서 첫 리뷰를 남겨보세요.';

  @override
  String reviewRatingOutOfRange(int min, int max) {
    return '별점은 $min~$max점 사이여야 합니다.';
  }

  @override
  String get congestionUnknown => '정보 없음';

  @override
  String get congestionRelaxed => '여유';

  @override
  String get congestionNormal => '보통';

  @override
  String get congestionBusy => '혼잡';

  @override
  String get paymentTitle => '결제하기';

  @override
  String get paymentApproving => '결제 승인 중...';

  @override
  String get paymentCheckFailed => '결제 정보 확인에 실패했습니다. 다시 시도해 주세요.';

  @override
  String get paymentApproveFailed => '결제 승인에 실패했습니다. 다시 시도해 주세요.';

  @override
  String get paymentFailed => '결제에 실패했습니다. 다시 시도해 주세요.';

  @override
  String get paymentProviderNotice => '토스페이먼츠 안전결제';

  @override
  String storeCongestionNow(String congestion) {
    return '현재 $congestion';
  }

  @override
  String storeCallFailed(String phone) {
    return '전화 연결에 실패했습니다: $phone';
  }

  @override
  String get storeMapFailed => '지도를 열 수 없습니다.';

  @override
  String get storeOpenNow => '영업 중';

  @override
  String get storeClosedNow => '영업 종료';

  @override
  String get storeCall => '전화';

  @override
  String get storeOpenMap => '지도 보기';

  @override
  String get storeListTitle => '매장 찾기';

  @override
  String get storeLocationUnavailable => '현재 위치를 확인할 수 없습니다.';

  @override
  String get storeSortByDistance => '내 주변 거리 보기';

  @override
  String get storeLoadFailed => '매장 정보를 불러오지 못했습니다.';

  @override
  String get storeSortHint => '우측 상단 버튼을 누르면 내 위치에서 가까운 순으로 정렬됩니다.';

  @override
  String get storeSortedByDistance => '내 위치에서 가까운 순으로 정렬되었습니다.';

  @override
  String storeHoursSummary(String weekday, String weekend) {
    return '평일 $weekday · 주말 $weekend';
  }

  @override
  String get storeDetailTitle => '매장 정보';

  @override
  String get storeNotFound => '문 닫은 매장이거나 없는 매장입니다.';

  @override
  String storeDistanceFromYou(String distance) {
    return '내 위치에서 $distance';
  }

  @override
  String storeCongestionMeasured(int count) {
    return '진행 중인 주문 $count건으로 자동 집계했어요.';
  }

  @override
  String get storeHoursUnknown => '영업시간 정보가 없습니다.';

  @override
  String storeHoursToday(String hours) {
    return '오늘 $hours';
  }

  @override
  String get storeSectionHours => '영업시간';

  @override
  String get storeHoursWeekday => '평일';

  @override
  String get storeHoursWeekend => '주말';

  @override
  String get storeSectionFacilities => '편의시설';

  @override
  String get storeNoticeTitle => '매장 공지';

  @override
  String get storeNoInfo => '정보 없음';

  @override
  String get storeLocationServiceOff => '위치 서비스가 꺼져 있습니다. 설정에서 위치 서비스를 켜주세요.';

  @override
  String get storeLocationPermissionDenied => '위치 권한이 없어 거리를 계산할 수 없습니다.';
}
