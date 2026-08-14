import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cafe_app/features/beans/domain/bean_models.dart';
import 'package:cafe_app/features/subscription/data/local_bean_subscriptions_repository.dart';
import 'package:cafe_app/features/subscription/domain/subscription_models.dart';

void main() {
  late LocalBeanSubscriptionsRepository repository;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repository = LocalBeanSubscriptionsRepository();
  });

  Future<BeanSubscription> subscribe({
    SubscriptionCycle cycle = SubscriptionCycle.monthly,
    int quantity = 1,
  }) {
    return repository.subscribe(
      beanId: 'ethiopia-yirgacheffe-aricha',
      beanName: '에티오피아 예가체프 아리차 에이미 G1',
      weight: BeanWeight.g200,
      grind: GrindOption.handDrip,
      quantity: quantity,
      cycle: cycle,
      unitPrice: 18000,
    );
  }

  test('최초 로드 시 빈 구독 목록을 반환한다', () async {
    final subscriptions = await repository.load();

    expect(subscriptions, isEmpty);
  });

  test('구독 신청 시 활성 상태와 다음 배송일이 기록된다', () async {
    final before = DateTime.now();
    final subscription = await subscribe(
      cycle: SubscriptionCycle.biweekly,
      quantity: 2,
    );

    expect(subscription.id, isNotEmpty);
    expect(subscription.status, SubscriptionStatus.active);
    expect(subscription.pricePerDelivery, 36000);
    expect(subscription.cycleLabel, '격주 2개');
    expect(subscription.optionLabel, '200g · 핸드드립');
    expect(
      subscription.nextDeliveryDate.difference(before).inDays,
      inInclusiveRange(13, 14),
    );
  });

  test('수량이 1개 미만이면 구독할 수 없다', () async {
    expect(() => subscribe(quantity: 0), throwsArgumentError);
  });

  test('구독이 로컬에 영속화되고 최신순으로 쌓인다', () async {
    await subscribe();
    final second = await subscribe(cycle: SubscriptionCycle.weekly);

    final reloaded = await LocalBeanSubscriptionsRepository().load();

    expect(reloaded, hasLength(2));
    expect(reloaded.first.id, second.id);
    expect(reloaded.first.cycle, SubscriptionCycle.weekly);
  });

  test('구독을 일시정지하고 재개하면 다음 배송일이 다시 계산된다', () async {
    final subscription = await subscribe(cycle: SubscriptionCycle.weekly);

    final paused = await repository.updateStatus(
      id: subscription.id,
      status: SubscriptionStatus.paused,
    );
    expect(paused.status, SubscriptionStatus.paused);
    expect(paused.nextDeliveryDate, subscription.nextDeliveryDate);

    final resumed = await repository.updateStatus(
      id: subscription.id,
      status: SubscriptionStatus.active,
    );
    expect(resumed.status, SubscriptionStatus.active);
    expect(
      resumed.nextDeliveryDate.isAtSameMomentAs(subscription.nextDeliveryDate) ||
          resumed.nextDeliveryDate.isAfter(subscription.nextDeliveryDate),
      isTrue,
    );
  });

  test('구독 해지 상태가 영속화된다', () async {
    final subscription = await subscribe();

    await repository.updateStatus(
      id: subscription.id,
      status: SubscriptionStatus.cancelled,
    );

    final reloaded = await LocalBeanSubscriptionsRepository().load();
    expect(reloaded.single.status, SubscriptionStatus.cancelled);
    expect(reloaded.single.isCancelled, isTrue);
  });

  test('존재하지 않는 구독 상태는 변경할 수 없다', () async {
    expect(
      () => repository.updateStatus(
        id: 'missing',
        status: SubscriptionStatus.paused,
      ),
      throwsArgumentError,
    );
  });
}
