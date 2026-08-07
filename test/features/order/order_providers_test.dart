import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cafe_app/features/beans/domain/bean_cart_models.dart';
import 'package:cafe_app/features/beans/domain/bean_models.dart';
import 'package:cafe_app/features/order/domain/order_models.dart';
import 'package:cafe_app/features/order/presentation/order_providers.dart';
import 'package:cafe_app/features/points/domain/points_models.dart';
import 'package:cafe_app/features/points/presentation/points_providers.dart';

Bean _bean(String id, {int price200 = 15000, int price500 = 32000}) {
  return Bean(
    id: id,
    name: '테스트 원두 $id',
    origin: '테스트 원산지',
    description: '테스트 설명',
    story: '테스트 스토리',
    roastLevel: RoastLevel.medium,
    process: '워시드',
    tastingNotes: const ['초콜릿'],
    acidity: 3,
    body: 3,
    sweetness: 3,
    recommendedBrews: const ['핸드드립'],
    price200: price200,
    price500: price500,
  );
}

List<BeanCartItem> _cartItems() => [
      BeanCartItem(
        bean: _bean('a'),
        weight: BeanWeight.g200,
        grind: GrindOption.handDrip,
        quantity: 2,
      ),
      BeanCartItem(
        bean: _bean('b'),
        weight: BeanWeight.g500,
        grind: GrindOption.wholeBean,
        quantity: 1,
      ),
    ];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  ProviderContainer createContainer() {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    return container;
  }

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('주문 생성 시 결제 금액의 10%가 적립되고 주문이 저장된다', () async {
    final container = createContainer();
    final controller = container.read(beanOrdersControllerProvider.notifier);

    final order = await controller.placeOrder(cartItems: _cartItems());

    expect(order.totalAmount, 62000);
    expect(order.usedPoints, 0);
    expect(order.earnedPoints, 6200);
    expect(order.paidAmount, 62000);

    final orders = await container.read(beanOrdersControllerProvider.future);
    expect(orders, hasLength(1));

    final points = await container.read(pointsRepositoryProvider).load();
    expect(points.balance, 6200);
    expect(points.history.first.description, beanOrderPaymentDescription);
    expect(points.history.first.paymentAmount, 62000);
  });

  test('포인트 사용 시 잔액이 차감되고 결제 금액 기준으로 적립된다', () async {
    final container = createContainer();
    await container
        .read(pointsRepositoryProvider)
        .recordPayment(paymentAmount: 50000);

    final controller = container.read(beanOrdersControllerProvider.notifier);
    final order = await controller.placeOrder(
      cartItems: _cartItems(),
      usedPoints: 5000,
    );

    expect(order.usedPoints, 5000);
    expect(order.paidAmount, 57000);
    expect(order.earnedPoints, 5700);

    final points = await container.read(pointsRepositoryProvider).load();
    expect(points.balance, 5700);
    expect(
      points.history.map((entry) => entry.description),
      containsAll([beanOrderPaymentDescription, beanOrderPointsUseDescription]),
    );
    expect(
      points.history
          .firstWhere((entry) => entry.type == PointHistoryType.use)
          .amount,
      -5000,
    );
  });

  test('전액 포인트 결제 시 적립이 발생하지 않는다', () async {
    final container = createContainer();
    await container
        .read(pointsRepositoryProvider)
        .recordPayment(paymentAmount: 700000);

    final controller = container.read(beanOrdersControllerProvider.notifier);
    final order = await controller.placeOrder(
      cartItems: _cartItems(),
      usedPoints: 62000,
    );

    expect(order.paidAmount, 0);
    expect(order.earnedPoints, 0);

    final points = await container.read(pointsRepositoryProvider).load();
    expect(points.balance, 70000 - 62000);
  });

  test('잔액을 초과한 포인트 사용은 실패하고 주문이 생성되지 않는다', () async {
    final container = createContainer();
    final controller = container.read(beanOrdersControllerProvider.notifier);

    await expectLater(
      controller.placeOrder(cartItems: _cartItems(), usedPoints: 1000),
      throwsStateError,
    );

    final orders = await container.read(beanOrdersControllerProvider.future);
    expect(orders, isEmpty);
  });

  test('결제 금액을 초과한 포인트 지정은 거부된다', () async {
    final container = createContainer();
    final controller = container.read(beanOrdersControllerProvider.notifier);

    await expectLater(
      controller.placeOrder(cartItems: _cartItems(), usedPoints: 62001),
      throwsArgumentError,
    );
  });

  test('빈 장바구니로는 주문할 수 없다', () async {
    final container = createContainer();
    final controller = container.read(beanOrdersControllerProvider.notifier);

    await expectLater(
      controller.placeOrder(cartItems: const []),
      throwsStateError,
    );
  });
}
