import 'package:flutter_test/flutter_test.dart';

import 'package:cafe_app/features/coupon/data/local_coupons_repository.dart';

void main() {
  final repository = LocalCouponsRepository();

  test('쿠폰 목록이 비어있지 않다', () async {
    final coupons = await repository.loadCoupons();

    expect(coupons, isNotEmpty);
  });

  test('쿠폰은 만료일 오름차순으로 정렬된다', () async {
    final coupons = await repository.loadCoupons();

    for (var i = 0; i < coupons.length - 1; i++) {
      expect(
        coupons[i].expiresAt.isBefore(coupons[i + 1].expiresAt) ||
            coupons[i].expiresAt.isAtSameMomentAs(coupons[i + 1].expiresAt),
        isTrue,
      );
    }
  });

  test('쿠폰 id는 중복되지 않는다', () async {
    final coupons = await repository.loadCoupons();
    final ids = coupons.map((coupon) => coupon.id).toSet();

    expect(ids.length, coupons.length);
  });

  test('사용 완료·기간 만료 쿠폰은 사용 가능 목록에서 제외된다', () async {
    final coupons = await repository.loadCoupons();
    final now = DateTime(2026, 8, 3);

    final usable = coupons.where((coupon) => coupon.isUsable(now));

    expect(usable.length, 2);
    expect(usable.any((coupon) => coupon.isUsed), isFalse);
    expect(usable.any((coupon) => coupon.isExpired(now)), isFalse);
  });
}
