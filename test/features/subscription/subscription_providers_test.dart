import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cafe_app/features/beans/domain/bean_models.dart';
import 'package:cafe_app/features/subscription/domain/subscription_models.dart';
import 'package:cafe_app/features/subscription/presentation/subscription_providers.dart';

const _bean = Bean(
  id: 'ethiopia-yirgacheffe-aricha',
  name: '에티오피아 예가체프 아리차 에이미 G1',
  origin: '에티오피아',
  description: '테스트 설명',
  story: '테스트 스토리',
  roastLevel: RoastLevel.light,
  process: '워시드',
  tastingNotes: ['자스민'],
  acidity: 4,
  body: 2,
  sweetness: 3,
  recommendedBrews: ['핸드드립'],
  price200: 18000,
  price500: 38000,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  ProviderContainer createContainer() {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    return container;
  }

  test('구독 신청 시 목록 맨 앞에 추가된다', () async {
    final container = createContainer();
    await container.read(beanSubscriptionsControllerProvider.future);

    final subscription = await container
        .read(beanSubscriptionsControllerProvider.notifier)
        .subscribe(
          bean: _bean,
          weight: BeanWeight.g500,
          grind: GrindOption.wholeBean,
          quantity: 1,
          cycle: SubscriptionCycle.monthly,
        );

    final subscriptions =
        container.read(beanSubscriptionsControllerProvider).value!;
    expect(subscriptions.single.id, subscription.id);
    expect(subscriptions.single.unitPrice, 38000);
    expect(subscriptions.single.cycle, SubscriptionCycle.monthly);
    expect(container.read(activeSubscriptionCountProvider), 1);
  });

  test('일시정지·재개·해지가 상태에 반영된다', () async {
    final container = createContainer();
    await container.read(beanSubscriptionsControllerProvider.future);
    final notifier =
        container.read(beanSubscriptionsControllerProvider.notifier);
    final subscription = await notifier.subscribe(
      bean: _bean,
      weight: BeanWeight.g200,
      grind: GrindOption.handDrip,
      quantity: 2,
      cycle: SubscriptionCycle.weekly,
    );

    await notifier.pause(subscription.id);
    expect(
      container
          .read(beanSubscriptionsControllerProvider)
          .value!
          .single
          .status,
      SubscriptionStatus.paused,
    );

    await notifier.resume(subscription.id);
    expect(
      container
          .read(beanSubscriptionsControllerProvider)
          .value!
          .single
          .status,
      SubscriptionStatus.active,
    );

    await notifier.cancel(subscription.id);
    expect(
      container
          .read(beanSubscriptionsControllerProvider)
          .value!
          .single
          .status,
      SubscriptionStatus.cancelled,
    );
    expect(container.read(activeSubscriptionCountProvider), 0);
  });
}
