import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cafe_app/features/auth/domain/account_models.dart';
import 'package:cafe_app/features/auth/domain/auth_models.dart';
import 'package:cafe_app/features/auth/presentation/account_providers.dart';
import 'package:cafe_app/features/auth/presentation/auth_providers.dart';
import 'package:cafe_app/features/coupon/data/local_coupons_repository.dart';
import 'package:cafe_app/features/coupon/presentation/auto_coupon_providers.dart';
import 'package:cafe_app/features/coupon/presentation/coupons_providers.dart';

import '../auth/fake_account_repository.dart';
import '../auth/fake_auth_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const user = AppUser(
    uid: 'fake-uid',
    displayName: '테스트 사용자',
    email: 'test@example.com',
    providerId: 'google',
  );

  ProviderContainer createContainer({
    AppUser? currentUser,
    AccountProfile profile = const AccountProfile(),
  }) {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          FakeAuthRepository(user: currentUser),
        ),
        accountRepositoryProvider.overrideWithValue(
          FakeAccountRepository(profile: profile),
        ),
        couponsRepositoryProvider.overrideWithValue(LocalCouponsRepository()),
        couponNowProvider.overrideWithValue(DateTime(2026, 8, 14)),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  Future<T> readAsync<T>(
    ProviderContainer container,
    ProviderListenable<Future<T>> provider,
  ) async {
    final subscription = container.listen(provider, (previous, next) {});
    try {
      return await subscription.read();
    } finally {
      subscription.close();
    }
  }

  test('로그인하지 않으면 쿠폰을 발급하지 않는다', () async {
    final container = createContainer();

    await readAsync(container, autoCouponSetupProvider.future);

    final coupons = await readAsync(
      container,
      couponsControllerProvider.future,
    );
    expect(coupons.any((c) => c.id.startsWith('welcome-fake')), isFalse);
  });

  test('로그인하면 웰컴 쿠폰을 발급한다', () async {
    final container = createContainer(currentUser: user);
    await readAsync(container, authStateProvider.future);

    await readAsync(container, autoCouponSetupProvider.future);

    final coupons = await readAsync(
      container,
      couponsControllerProvider.future,
    );
    expect(coupons.any((c) => c.id == 'welcome-fake-uid'), isTrue);
  });

  test('생일 주간이면 생일 쿠폰도 발급한다', () async {
    final container = createContainer(
      currentUser: user,
      profile: AccountProfile(birthDate: DateTime(1994, 8, 14)),
    );
    await readAsync(container, authStateProvider.future);

    await readAsync(container, autoCouponSetupProvider.future);

    final coupons = await readAsync(
      container,
      couponsControllerProvider.future,
    );
    expect(coupons.any((c) => c.id == 'birthday-2026-fake-uid'), isTrue);
  });

  test('생일 주간이 아니면 생일 쿠폰을 발급하지 않는다', () async {
    final container = createContainer(
      currentUser: user,
      profile: AccountProfile(birthDate: DateTime(1994, 1, 1)),
    );
    await readAsync(container, authStateProvider.future);

    await readAsync(container, autoCouponSetupProvider.future);

    final coupons = await readAsync(
      container,
      couponsControllerProvider.future,
    );
    expect(coupons.any((c) => c.id == 'welcome-fake-uid'), isTrue);
    expect(coupons.any((c) => c.id.startsWith('birthday-')), isFalse);
  });

  test('다시 실행해도 같은 쿠폰을 중복 발급하지 않는다', () async {
    final container = createContainer(
      currentUser: user,
      profile: AccountProfile(birthDate: DateTime(1994, 8, 14)),
    );
    await readAsync(container, authStateProvider.future);

    await readAsync(container, autoCouponSetupProvider.future);
    container.invalidate(autoCouponSetupProvider);
    await readAsync(container, autoCouponSetupProvider.future);

    final coupons = await readAsync(
      container,
      couponsControllerProvider.future,
    );
    expect(coupons.where((c) => c.id == 'welcome-fake-uid').length, 1);
    expect(coupons.where((c) => c.id == 'birthday-2026-fake-uid').length, 1);
  });
}
