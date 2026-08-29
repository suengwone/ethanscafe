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

  @override
  String get roastLight => '라이트';

  @override
  String get roastMediumLight => '미디엄 라이트';

  @override
  String get roastMedium => '미디엄';

  @override
  String get roastMediumDark => '미디엄 다크';

  @override
  String get roastDark => '다크';

  @override
  String get grindWholeBean => '홀빈';

  @override
  String get grindWholeBeanNote => '분쇄하지 않은 원두 그대로';

  @override
  String get grindEspresso => '에스프레소';

  @override
  String get grindEspressoNote => '가정용 에스프레소 머신용';

  @override
  String get grindMokaPot => '모카포트';

  @override
  String get grindMokaPotNote => '모카포트 추출용';

  @override
  String get grindHandDrip => '핸드드립';

  @override
  String get grindHandDripNote => '푸어오버·드리퍼용';

  @override
  String get grindFrenchPress => '프렌치프레스';

  @override
  String get grindFrenchPressNote => '침출식 추출용';

  @override
  String get subscriptionCycleWeekly => '매주';

  @override
  String get subscriptionCycleBiweekly => '격주';

  @override
  String get subscriptionCycleMonthly => '매월';

  @override
  String get subscriptionStatusActive => '구독 중';

  @override
  String get subscriptionStatusPaused => '일시정지';

  @override
  String get subscriptionStatusCancelled => '해지됨';

  @override
  String get beanOrderStatusReceived => '주문 접수';

  @override
  String get beanOrderStatusRoasting => '로스팅 중';

  @override
  String get beanOrderStatusShipped => '발송 완료';

  @override
  String get beanOrderStatusDelivered => '배송 완료';

  @override
  String get beanOrderStatusReady => '픽업 대기';

  @override
  String get beanOrderStatusPickedUp => '픽업 완료';

  @override
  String get beanOrderStatusCancelled => '주문 취소';

  @override
  String get fulfillmentDelivery => '택배 배송';

  @override
  String get fulfillmentPickup => '매장 픽업';

  @override
  String get pickupStatusReceived => '주문 접수';

  @override
  String get pickupStatusPreparing => '제조 중';

  @override
  String get pickupStatusReady => '픽업 대기';

  @override
  String get pickupStatusPickedUp => '픽업 완료';

  @override
  String get pickupStatusCancelled => '주문 취소';

  @override
  String get refundStatusPending => '환불 처리 중';

  @override
  String get refundStatusDone => '환불 완료';

  @override
  String get refundStatusFailed => '환불 확인 중';

  @override
  String get wholesaleStatusRequested => '견적 확인 중';

  @override
  String get wholesaleStatusQuoted => '견적서 발송';

  @override
  String get wholesaleStatusConfirmed => '주문 확정';

  @override
  String orderItemsSummary(String first, int others) {
    return '$first 외 $others건';
  }

  @override
  String get orderTypePickup => '픽업';

  @override
  String get orderTypeBean => '원두';

  @override
  String get orderRecipientUnset => '수령인 미지정';

  @override
  String get orderStoreUnset => '매장 미지정';

  @override
  String beanOptionLabel(String weight, String grind) {
    return '$weight · $grind';
  }

  @override
  String beanQuantity(String name, int count) {
    return '$name $count개';
  }

  @override
  String subscriptionCycleQuantity(String cycle, int count) {
    return '$cycle $count개';
  }

  @override
  String get beansLoadFailed => '원두 정보를 불러오지 못했습니다.';

  @override
  String get beansFilterAcidic => '산미가 화사한 원두';

  @override
  String get beansFilterAcidicNote => '과일처럼 밝고 산뜻한 맛을 좋아한다면';

  @override
  String get beansFilterMellow => '산미 적은 고소한 원두';

  @override
  String get beansFilterMellowNote => '산미 부담 없이 고소하고 묵직한 한 잔을 원한다면';

  @override
  String get beansFilterDecaf => '디카페인';

  @override
  String get beansFilterDecafNote => '늦은 오후에도 카페인 걱정 없이';

  @override
  String beansCartCount(int count) {
    return '장바구니 · $count개';
  }

  @override
  String get beansRoastNotice => '매주 화요일 로스팅한 원두를 홀빈 또는 원하는 분쇄도로 보내드립니다.';

  @override
  String beansRoastOf(String origin, String roast) {
    return '$origin · $roast 로스팅';
  }

  @override
  String get beansPricePer200g => '200g 기준';

  @override
  String beanNotFound(String beanId) {
    return '원두를 찾을 수 없습니다: $beanId';
  }

  @override
  String get beanCartTitle => '원두 장바구니';

  @override
  String get beanCartEmptyTitle => '장바구니가 비어 있어요';

  @override
  String get beanCartEmptyDetail => '마음에 드는 원두를 담아보세요.';

  @override
  String get beanCartBrowse => '원두 보러 가기';

  @override
  String get beanCartFulfillment => '수령 방법';

  @override
  String get beanCartNoAddress => '등록된 배송지가 없어요. 배송지를 추가해 주세요.';

  @override
  String get beanCartAddAddress => '배송지 추가';

  @override
  String get beanCartChange => '변경';

  @override
  String get beanCartNoStore => '원두를 픽업할 매장을 선택해 주세요.';

  @override
  String get beanCartChooseStore => '매장 선택';

  @override
  String get beanCartAddressSheetTitle => '배송지 선택';

  @override
  String get beanCartAddressSheetDetail => '원두를 받을 배송지를 선택해 주세요.';

  @override
  String get beanCartAddressLoadFailed => '배송지를 불러오지 못했습니다.';

  @override
  String get beanCartManageAddresses => '배송지 관리';

  @override
  String get beanCartClose => '닫기';

  @override
  String get beanCartDefaultAddress => '기본 배송지';

  @override
  String get beanCartStoreSheetTitle => '픽업 매장 선택';

  @override
  String get beanCartStoreSheetDetail => '로스팅이 끝나면 선택한 매장에서 픽업할 수 있어요.';

  @override
  String get beanCartStoreLoadFailed => '매장 정보를 불러오지 못했습니다.';

  @override
  String beanCartRemoved(String name) {
    return '$name을(를) 장바구니에서 뺐어요.';
  }

  @override
  String get beanCartUndo => '실행취소';

  @override
  String get beanCartDelete => '삭제';

  @override
  String get beanCartNeedAddress => '배송지를 먼저 등록해 주세요.';

  @override
  String get beanCartNeedStore => '픽업 매장을 먼저 선택해 주세요.';

  @override
  String get beanCartPaymentIncomplete => '결제가 완료되지 않았습니다.';

  @override
  String beanCartOrderedWithPoints(String points) {
    return '원두 주문이 접수되었습니다. ${points}P가 적립됐어요.';
  }

  @override
  String get beanCartOrderedPickup => '원두 주문이 접수되었습니다. 로스팅 후 매장에서 픽업하실 수 있어요.';

  @override
  String get beanCartOrderedDelivery => '원두 주문이 접수되었습니다. 로스팅 후 순차 발송됩니다.';

  @override
  String get beanCartOrderFailed => '주문 처리에 실패했습니다. 다시 시도해 주세요.';

  @override
  String beanCartCouponsApplied(int count) {
    return '쿠폰 $count장 적용';
  }

  @override
  String get beanCartNoUsableCoupons => '적용 가능한 쿠폰이 없어요';

  @override
  String beanCartUsableCoupons(int count) {
    return '사용 가능한 쿠폰 $count장';
  }

  @override
  String get beanCartChooseCoupon => '쿠폰 선택';

  @override
  String beanCartUsePoints(String balance) {
    return '포인트 사용 (보유 ${balance}P)';
  }

  @override
  String get beanCartNoPoints => '사용 가능한 포인트가 없어요';

  @override
  String beanCartItemCount(int count) {
    return '총 $count개';
  }

  @override
  String get beanCartOrdering => '주문 중...';

  @override
  String get beanCartPay => '결제하기';

  @override
  String get beanCartOrder => '주문하기';

  @override
  String discountAmount(String amount) {
    return '-$amount원';
  }

  @override
  String get beanDetailTitle => '원두 상세';

  @override
  String beanRoastBadge(String roast) {
    return '$roast 로스팅';
  }

  @override
  String get beanSectionNotes => '향미 노트';

  @override
  String get beanSectionProfile => '테이스팅 프로필';

  @override
  String get beanProfileAcidity => '산미';

  @override
  String get beanProfileBody => '바디';

  @override
  String get beanProfileSweetness => '단맛';

  @override
  String get beanSectionStory => '원두 이야기';

  @override
  String get beanSectionDetails => '상세 정보';

  @override
  String get beanFieldOrigin => '원산지';

  @override
  String get beanFieldProcess => '가공 방식';

  @override
  String get beanFieldRoast => '로스팅';

  @override
  String get beanFieldBrews => '추천 추출';

  @override
  String get beanFieldPrice => '가격';

  @override
  String beanPriceBoth(String price200, String price500) {
    return '200g $price200원 · 500g $price500원';
  }

  @override
  String get beanCartTooltip => '원두 장바구니';

  @override
  String get beanGiftTooltip => '선물하기';

  @override
  String get beanSubscribe => '구독';

  @override
  String get beanSoldOut => '품절';

  @override
  String get beanOrder => '주문하기';

  @override
  String get beanGiftRequiresSignIn => '원두 선물하기는 로그인 후 이용할 수 있어요.';

  @override
  String get beanOrderRequiresSignIn => '원두 주문은 로그인 후 이용할 수 있어요.';

  @override
  String beanAddedToCart(String name) {
    return '$name을(를) 장바구니에 담았습니다.';
  }

  @override
  String get beanViewCart => '보기';

  @override
  String get beanFieldWeight => '용량';

  @override
  String get beanFieldGrind => '분쇄도';

  @override
  String get beanFieldQuantity => '수량';

  @override
  String get beanTotalPrice => '총 결제 금액';

  @override
  String get beanAddToCart => '장바구니 담기';

  @override
  String beanOrderForAmount(String amount) {
    return '$amount원 주문';
  }

  @override
  String get subscriptionRequiresSignIn => '원두 구독은 로그인 후 이용할 수 있어요.';

  @override
  String subscriptionStarted(String bean, String cycle) {
    return '$bean $cycle 정기구독이 시작되었습니다.';
  }

  @override
  String get subscriptionManage => '구독 관리';

  @override
  String get subscriptionTitle => '원두 정기구독';

  @override
  String get subscriptionFieldCycle => '배송 주기';

  @override
  String get subscriptionFieldQuantity => '회당 수량';

  @override
  String get subscriptionFieldPrice => '회당 결제 금액';

  @override
  String subscriptionNotice(String cycle) {
    return '$cycle 로스팅한 원두를 배송해 드려요. 언제든 일시정지·해지할 수 있어요.';
  }

  @override
  String subscriptionStart(String cycle) {
    return '$cycle 구독 시작하기';
  }

  @override
  String subscriptionEveryDays(int days) {
    return '$days일마다';
  }

  @override
  String get subscriptionListTitle => '원두 정기구독';

  @override
  String get subscriptionLoadFailed => '구독 정보를 불러오지 못했습니다.';

  @override
  String get subscriptionEmptyTitle => '구독 중인 원두가 없어요';

  @override
  String get subscriptionEmptyDetail => '원두 상세에서 정기구독을 시작하면 주기마다 배송해 드려요.';

  @override
  String get subscriptionBrowse => '원두 보러 가기';

  @override
  String get subscriptionCancelTitle => '구독 해지';

  @override
  String subscriptionCancelConfirm(String bean) {
    return '$bean 정기구독을 해지할까요?\n해지 후에는 배송이 중단됩니다.';
  }

  @override
  String subscriptionCancelled(String bean) {
    return '$bean 구독이 해지되었습니다.';
  }

  @override
  String subscriptionStartedOn(String date) {
    return '구독 시작 $date';
  }

  @override
  String subscriptionNextDelivery(String date) {
    return '다음 배송 $date';
  }

  @override
  String subscriptionPricePerDelivery(String amount) {
    return '회당 $amount원';
  }

  @override
  String get subscriptionResume => '구독 재개';

  @override
  String get subscriptionPause => '일시정지';

  @override
  String get subscriptionCancelAction => '해지하기';

  @override
  String get commonCancel => '취소';

  @override
  String get adminOrdersTitle => '주문 관리';

  @override
  String get adminOrdersRefresh => '새로고침';

  @override
  String get adminOrdersTabRefundFailed => '환불 실패';

  @override
  String get adminOrdersNoPickup => '처리할 픽업 주문이 없습니다.';

  @override
  String get adminOrdersNoBean => '처리할 원두 주문이 없습니다.';

  @override
  String get adminOrdersNoRefundFailures => '환불이 밀린 주문이 없습니다.';

  @override
  String get adminOrdersRefunded => '환불했습니다.';

  @override
  String adminOrdersRefundFailed(String error) {
    return '환불에 실패했습니다: $error';
  }

  @override
  String adminOrdersRefundFailedLabel(String type) {
    return '$type · 환불 실패';
  }

  @override
  String get adminOrdersRetryRefund => '환불 재시도';

  @override
  String get adminOrdersAdvanceFailed => '상태를 바꾸지 못했습니다';

  @override
  String get adminOrdersCancelTitle => '주문을 취소할까요?';

  @override
  String adminOrdersCancelBody(String summary) {
    return '$summary 주문을 취소합니다.\n사용한 포인트와 쿠폰을 돌려주고 결제한 금액을 환불합니다.';
  }

  @override
  String get adminOrdersCancelFailed => '주문을 취소하지 못했습니다';

  @override
  String get adminOrdersCancelAction => '주문 취소';

  @override
  String adminOrdersAdvanceTo(String status) {
    return '$status로';
  }

  @override
  String get adminOrdersLoadFailed => '주문을 불러오지 못했습니다.';

  @override
  String get commonClose => '닫기';

  @override
  String get orderHistoryTitle => '주문 내역';

  @override
  String get orderHistoryLoadFailed => '주문 내역을 불러오지 못했습니다.';

  @override
  String get orderHistoryEmptyTitle => '주문 내역이 없어요';

  @override
  String get orderHistoryEmptyDetail => '매장 결제나 픽업 · 원두 주문을 하면 내역이 쌓여요.';

  @override
  String orderCouponDiscount(String amount) {
    return '쿠폰 -$amount원';
  }

  @override
  String orderPointsUsed(String amount) {
    return '-${amount}P 사용';
  }

  @override
  String orderPointsEarned(String amount) {
    return '+${amount}P 적립';
  }

  @override
  String get orderBeanLabel => '원두 주문';

  @override
  String orderItemCount(int count) {
    return '총 $count개';
  }

  @override
  String get orderReorder => '재주문';

  @override
  String get orderCancel => '주문 취소';

  @override
  String get orderReorderUnavailableBeans => '지금은 판매하지 않는 상품이라 재주문할 수 없어요.';

  @override
  String get orderReorderUnavailableMenu => '지금은 판매하지 않는 메뉴라 재주문할 수 없어요.';

  @override
  String orderReorderPartialBeans(String names) {
    return '판매 종료된 $names 상품은 제외하고 장바구니에 담았어요.';
  }

  @override
  String orderReorderPartialMenu(String names) {
    return '판매 종료된 $names 메뉴는 제외하고 장바구니에 담았어요.';
  }

  @override
  String get orderReorderDone => '이전 주문 구성을 장바구니에 담았어요.';

  @override
  String get orderCancelBeanTitle => '원두 주문을 취소할까요?';

  @override
  String get orderCancelledNotice => '주문이 취소되었어요. 사용한 쿠폰과 포인트는 복구됩니다.';

  @override
  String orderPickupSummary(String store, int number, int count) {
    return '픽업 주문 · $store · 주문번호 $number번 · 총 $count개';
  }

  @override
  String get orderTrackStatus => '주문 현황 보기';

  @override
  String get orderWriteReview => '리뷰 쓰기';

  @override
  String get pickupOptionTitle => '옵션';

  @override
  String get pickupTotalPrice => '총 주문 금액';

  @override
  String get pickupAddToCart => '장바구니 담기';

  @override
  String get pickupCartTitle => '픽업 주문';

  @override
  String get pickupCartRequiresSignIn => '장바구니는 로그인 후 이용할 수 있어요.';

  @override
  String get pickupCartTooltip => '픽업 장바구니';

  @override
  String get pickupCartEmptyTitle => '장바구니가 비어 있어요';

  @override
  String get pickupCartEmptyDetail => '메뉴에서 마시고 싶은 음료를 담아보세요.';

  @override
  String get pickupCartBrowse => '메뉴 보러 가기';

  @override
  String get pickupCartChooseStorePrompt => '픽업 매장을 선택해 주세요';

  @override
  String get pickupCartStoreRequired => '주문 전에 픽업할 매장이 필요해요.';

  @override
  String pickupCartRemoved(String name) {
    return '$name을(를) 장바구니에서 뺐어요.';
  }

  @override
  String get pickupCartStoreSheetDetail => '음료를 픽업할 매장을 선택해 주세요.';

  @override
  String pickupCartOrderedWithPoints(int number, String points) {
    return '픽업 주문이 접수되었습니다. 주문번호 $number번 · ${points}P가 적립됐어요.';
  }

  @override
  String pickupCartOrdered(int number) {
    return '픽업 주문이 접수되었습니다. 주문번호 $number번 · 준비가 끝나면 알려드릴게요.';
  }

  @override
  String get pickupTrackingTitle => '주문 현황';

  @override
  String get pickupTrackingLoadFailed => '주문 현황을 불러오지 못했습니다.';

  @override
  String get pickupTrackingLiveNotice => '주문 상태가 바뀌면 실시간으로 반영돼요.';

  @override
  String get pickupTrackingNotFound => '주문을 찾을 수 없어요';

  @override
  String get pickupTrackingNotFoundDetail => '주문 내역에서 다시 확인해 주세요.';

  @override
  String pickupOrderNumber(int number) {
    return '주문번호 $number번';
  }

  @override
  String pickupOrderedAt(String time) {
    return '$time 주문';
  }

  @override
  String get pickupStepReceived => '매장에서 주문을 확인하고 있어요.';

  @override
  String get pickupStepPreparing => '바리스타가 정성껏 만들고 있어요.';

  @override
  String get pickupStepReady => '픽업대에서 주문을 찾아가세요.';

  @override
  String get pickupStepPickedUp => '맛있게 즐기세요. 감사합니다!';

  @override
  String get pickupInProgress => '진행 중';

  @override
  String get pickupRefundChecking =>
      '사용한 쿠폰과 포인트는 복구되었어요. 결제 환불은 확인 중이며, 오래 걸리면 고객센터로 문의해 주세요.';

  @override
  String get pickupRefundNormal =>
      '사용한 쿠폰과 포인트는 복구되었어요. 결제 환불은 수단에 따라 3~5일 소요될 수 있어요.';

  @override
  String get pickupCancelledTitle => '주문이 취소되었어요';

  @override
  String get pickupCancelAction => '주문 취소하기';

  @override
  String get pickupCancelTitle => '픽업 주문을 취소할까요?';

  @override
  String get pickupSectionItems => '주문 상품';

  @override
  String pickupItemQuantity(int count) {
    return '$count개';
  }

  @override
  String get pickupPaidAmount => '결제 금액';
}
