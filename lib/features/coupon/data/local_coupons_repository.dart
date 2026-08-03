import '../domain/coupon_models.dart';
import '../domain/coupons_repository.dart';

class LocalCouponsRepository implements CouponsRepository {
  @override
  Future<List<Coupon>> loadCoupons() async {
    final coupons = [..._coupons]
      ..sort((a, b) => a.expiresAt.compareTo(b.expiresAt));
    return coupons;
  }

  static final _coupons = <Coupon>[
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
