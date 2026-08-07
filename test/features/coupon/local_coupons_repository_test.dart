import 'package:flutter_test/flutter_test.dart';

import 'package:cafe_app/features/coupon/data/local_coupons_repository.dart';

void main() {
  test('쿠폰 목록이 비어있지 않다', () async {
    final coupons = await LocalCouponsRepository().loadCoupons();

    expect(coupons, isNotEmpty);
  });

  test('쿠폰은 만료일 오름차순으로 정렬된다', () async {
    final coupons = await LocalCouponsRepository().loadCoupons();

    for (var i = 0; i < coupons.length - 1; i++) {
      expect(
        coupons[i].expiresAt.isBefore(coupons[i + 1].expiresAt) ||
            coupons[i].expiresAt.isAtSameMomentAs(coupons[i + 1].expiresAt),
        isTrue,
      );
    }
  });

  test('쿠폰 id는 중복되지 않는다', () async {
    final coupons = await LocalCouponsRepository().loadCoupons();
    final ids = coupons.map((coupon) => coupon.id).toSet();

    expect(ids.length, coupons.length);
  });

  test('사용 완료·기간 만료 쿠폰은 사용 가능 목록에서 제외된다', () async {
    final coupons = await LocalCouponsRepository().loadCoupons();
    final now = DateTime(2026, 8, 3);

    final usable = coupons.where((coupon) => coupon.isUsable(now));

    expect(usable.length, 4);
    expect(usable.any((coupon) => coupon.isUsed), isFalse);
    expect(usable.any((coupon) => coupon.isExpired(now)), isFalse);
  });

  test('markUsed는 해당 쿠폰만 사용 처리한다', () async {
    final repository = LocalCouponsRepository();

    await repository.markUsed('welcome-americano');

    final coupons = await repository.loadCoupons();
    final used = coupons.firstWhere((c) => c.id == 'welcome-americano');
    expect(used.isUsed, isTrue);
    expect(
      coupons.where((coupon) => coupon.isUsed).length,
      2,
    );
  });

  test('이미 사용된 쿠폰을 다시 사용하면 실패한다', () async {
    final repository = LocalCouponsRepository();

    await expectLater(
      repository.markUsed('used-latte-free'),
      throwsStateError,
    );
  });

  test('존재하지 않는 쿠폰 사용 처리는 실패한다', () async {
    final repository = LocalCouponsRepository();

    await expectLater(
      repository.markUsed('unknown-coupon'),
      throwsArgumentError,
    );
  });

  test('사용 처리는 다른 인스턴스에 영향을 주지 않는다', () async {
    final repository = LocalCouponsRepository();
    await repository.markUsed('welcome-americano');

    final fresh = await LocalCouponsRepository().loadCoupons();
    expect(
      fresh.firstWhere((c) => c.id == 'welcome-americano').isUsed,
      isFalse,
    );
  });
}
