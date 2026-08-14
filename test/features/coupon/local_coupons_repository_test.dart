import 'package:flutter_test/flutter_test.dart';

import 'package:cafe_app/features/coupon/data/local_coupons_repository.dart';
import 'package:cafe_app/features/coupon/domain/coupon_models.dart';

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

    expect(usable.length, 5);
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

  test('markUnused는 사용된 쿠폰을 다시 사용 가능하게 복구한다', () async {
    final repository = LocalCouponsRepository();
    await repository.markUsed('welcome-americano');

    await repository.markUnused('welcome-americano');

    final coupons = await repository.loadCoupons();
    expect(
      coupons.firstWhere((c) => c.id == 'welcome-americano').isUsed,
      isFalse,
    );
  });

  test('존재하지 않는 쿠폰 복구 처리는 실패한다', () async {
    final repository = LocalCouponsRepository();

    await expectLater(
      repository.markUnused('unknown-coupon'),
      throwsArgumentError,
    );
  });

  test('issueCoupon은 새 쿠폰을 추가하고 true를 반환한다', () async {
    final repository = LocalCouponsRepository();
    final coupon = Coupon(
      id: 'welcome-user-1',
      title: '웰컴 3,000원 할인',
      description: '가입 축하 쿠폰',
      expiresAt: DateTime(2026, 9, 12, 23, 59),
      discountAmount: 3000,
    );

    final issued = await repository.issueCoupon(coupon);

    expect(issued, isTrue);
    final coupons = await repository.loadCoupons();
    expect(coupons.any((c) => c.id == 'welcome-user-1'), isTrue);
  });

  test('issueCoupon은 같은 id 쿠폰을 중복 발급하지 않는다', () async {
    final repository = LocalCouponsRepository();
    final coupon = Coupon(
      id: 'welcome-user-1',
      title: '웰컴 3,000원 할인',
      description: '가입 축하 쿠폰',
      expiresAt: DateTime(2026, 9, 12, 23, 59),
      discountAmount: 3000,
    );
    await repository.issueCoupon(coupon);

    final reissued = await repository.issueCoupon(coupon);

    expect(reissued, isFalse);
    final coupons = await repository.loadCoupons();
    expect(coupons.where((c) => c.id == 'welcome-user-1').length, 1);
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
