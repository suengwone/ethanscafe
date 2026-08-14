import '../domain/coupon_models.dart';
import '../domain/coupons_repository.dart';

class LocalCouponsRepository implements CouponsRepository {
  final List<Coupon> _coupons = [..._seedCoupons];

  @override
  Future<List<Coupon>> loadCoupons() async {
    final coupons = [..._coupons]
      ..sort((a, b) => a.expiresAt.compareTo(b.expiresAt));
    return coupons;
  }

  @override
  Future<bool> issueCoupon(Coupon coupon) async {
    if (_coupons.any((existing) => existing.id == coupon.id)) {
      return false;
    }
    _coupons.add(coupon);
    return true;
  }

  @override
  Future<void> markUsed(String couponId) async {
    final index = _coupons.indexWhere((coupon) => coupon.id == couponId);
    if (index == -1) {
      throw ArgumentError.value(couponId, 'couponId', '쿠폰을 찾을 수 없습니다.');
    }
    if (_coupons[index].isUsed) {
      throw StateError('이미 사용 처리된 쿠폰입니다.');
    }
    _coupons[index] = _coupons[index].copyWith(isUsed: true);
  }

  @override
  Future<void> markUnused(String couponId) async {
    final index = _coupons.indexWhere((coupon) => coupon.id == couponId);
    if (index == -1) {
      throw ArgumentError.value(couponId, 'couponId', '쿠폰을 찾을 수 없습니다.');
    }
    _coupons[index] = _coupons[index].copyWith(isUsed: false);
  }

  static final _seedCoupons = <Coupon>[
    Coupon(
      id: 'welcome-americano',
      title: '웰컴 아메리카노 1잔',
      description: '첫 가입 기념 아메리카노 HOT/ICED 무료 쿠폰',
      expiresAt: DateTime(2026, 8, 31, 23, 59),
    ),
    Coupon(
      id: 'summer-dessert-30',
      title: '디저트 30% 할인',
      description: '여름 시즌 한정 전 디저트 메뉴 30% 할인',
      expiresAt: DateTime(2026, 8, 15, 23, 59),
    ),
    Coupon(
      id: 'bean-order-3000',
      title: '원두 주문 3,000원 할인',
      description: '원두 20,000원 이상 주문 시 3,000원 할인',
      expiresAt: DateTime(2026, 12, 31, 23, 59),
      discountAmount: 3000,
      minOrderAmount: 20000,
    ),
    Coupon(
      id: 'bean-order-10p',
      title: '원두 주문 10% 할인',
      description: '원두 주문 결제 금액의 10% 할인',
      expiresAt: DateTime(2026, 9, 30, 23, 59),
      discountRate: 10,
    ),
    Coupon(
      id: 'stack-extra-1000',
      title: '1,000원 중복 할인',
      description: '다른 쿠폰과 함께 쓸 수 있는 1,000원 추가 할인',
      expiresAt: DateTime(2026, 12, 31, 23, 59),
      discountAmount: 1000,
      isStackable: true,
    ),
    Coupon(
      id: 'spring-drip-free',
      title: '드립 커피 1잔 무료',
      description: '봄 시즌 이벤트 드립 커피 무료 쿠폰',
      expiresAt: DateTime(2026, 5, 31, 23, 59),
    ),
    Coupon(
      id: 'used-latte-free',
      title: '카페 라떼 1잔 무료',
      description: '스탬프 보상 카페 라떼 무료 쿠폰',
      expiresAt: DateTime(2026, 9, 30, 23, 59),
      isUsed: true,
    ),
  ];
}
