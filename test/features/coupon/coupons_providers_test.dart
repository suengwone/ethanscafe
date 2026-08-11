import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cafe_app/features/coupon/data/local_coupons_repository.dart';
import 'package:cafe_app/features/coupon/presentation/coupons_providers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  ProviderContainer createContainer() {
    final container = ProviderContainer(
      overrides: [
        couponsRepositoryProvider.overrideWithValue(LocalCouponsRepository()),
        couponNowProvider.overrideWithValue(DateTime(2026, 8, 3)),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('useCoupon은 쿠폰을 사용 처리하고 상태를 갱신한다', () async {
    final container = createContainer();
    await container.read(couponsControllerProvider.future);

    await container
        .read(couponsControllerProvider.notifier)
        .useCoupon('welcome-americano');

    final coupons = await container.read(couponsControllerProvider.future);
    expect(
      coupons.firstWhere((c) => c.id == 'welcome-americano').isUsed,
      isTrue,
    );
  });

  test('쿠폰 사용 시 사용 가능 쿠폰 수가 줄어든다', () async {
    final container = createContainer();
    expect(await container.read(usableCouponCountProvider.future), 5);

    await container.read(couponsControllerProvider.future);
    await container
        .read(couponsControllerProvider.notifier)
        .useCoupon('welcome-americano');

    expect(await container.read(usableCouponCountProvider.future), 4);
  });

  test('이미 사용된 쿠폰은 다시 사용할 수 없다', () async {
    final container = createContainer();
    await container.read(couponsControllerProvider.future);

    await expectLater(
      container
          .read(couponsControllerProvider.notifier)
          .useCoupon('used-latte-free'),
      throwsStateError,
    );
  });
}
