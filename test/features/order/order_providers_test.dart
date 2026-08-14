import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cafe_app/features/beans/domain/bean_cart_models.dart';
import 'package:cafe_app/features/beans/domain/bean_models.dart';
import 'package:cafe_app/features/coupon/domain/coupon_models.dart';
import 'package:cafe_app/features/coupon/presentation/coupons_providers.dart';
import 'package:cafe_app/features/order/domain/order_models.dart';
import 'package:cafe_app/features/order/presentation/order_providers.dart';
import 'package:cafe_app/features/payment/domain/payment_models.dart';
import 'package:cafe_app/features/points/domain/points_models.dart';
import 'package:cafe_app/features/points/presentation/points_providers.dart';
import 'package:cafe_app/features/profile/domain/delivery_address.dart';
import 'package:cafe_app/features/store/domain/store_models.dart';

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

const _address = DeliveryAddress(
  id: 'seed-home',
  label: '집',
  recipient: '이단',
  phone: '010-1234-5678',
  address1: '서울 성동구 연무장길 47',
  address2: '101동 1001호',
  isDefault: true,
);

const _store = CafeStore(
  id: 'macheon',
  name: '폭스트롯 마천점',
  address: '서울 송파구 마천로 일대',
  phone: '02-000-0000',
  latitude: 37.4949,
  longitude: 127.1478,
  weekdayHours: '09:00 - 21:00',
  weekendHours: '10:00 - 21:00',
);

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

  test('택배 주문 시 배송지 스냅샷이 주문에 기록된다', () async {
    final container = createContainer();
    final controller = container.read(beanOrdersControllerProvider.notifier);

    final order = await controller.placeOrder(
      cartItems: _cartItems(),
      deliveryAddress: _address,
    );

    expect(order.fulfillmentMethod, BeanFulfillmentMethod.delivery);
    expect(order.recipient, '이단');
    expect(order.recipientPhone, '010-1234-5678');
    expect(order.shippingAddress, '서울 성동구 연무장길 47 101동 1001호');
    expect(order.storeId, isNull);
    expect(order.storeName, isNull);
  });

  test('픽업 주문 시 매장 정보가 기록되고 배송지는 저장되지 않는다', () async {
    final container = createContainer();
    final controller = container.read(beanOrdersControllerProvider.notifier);

    final order = await controller.placeOrder(
      cartItems: _cartItems(),
      fulfillmentMethod: BeanFulfillmentMethod.pickup,
      pickupStore: _store,
      deliveryAddress: _address,
    );

    expect(order.fulfillmentMethod, BeanFulfillmentMethod.pickup);
    expect(order.storeId, 'macheon');
    expect(order.storeName, '폭스트롯 마천점');
    expect(order.recipient, isNull);
    expect(order.shippingAddress, isNull);
  });

  test('픽업 주문에 매장이 없으면 주문이 생성되지 않는다', () async {
    final container = createContainer();
    final controller = container.read(beanOrdersControllerProvider.notifier);

    await expectLater(
      controller.placeOrder(
        cartItems: _cartItems(),
        fulfillmentMethod: BeanFulfillmentMethod.pickup,
      ),
      throwsStateError,
    );

    final orders = await container.read(beanOrdersControllerProvider.future);
    expect(orders, isEmpty);
  });

  test('빈 장바구니로는 주문할 수 없다', () async {
    final container = createContainer();
    final controller = container.read(beanOrdersControllerProvider.notifier);

    await expectLater(
      controller.placeOrder(cartItems: const []),
      throwsStateError,
    );
  });

  Future<Coupon> loadCoupon(ProviderContainer container, String id) async {
    final coupons = await container.read(couponsControllerProvider.future);
    return coupons.firstWhere((coupon) => coupon.id == id);
  }

  test('정액 쿠폰 적용 시 할인되고 쿠폰이 사용 처리된다', () async {
    final container = createContainer();
    final coupon = await loadCoupon(container, 'bean-order-3000');
    final controller = container.read(beanOrdersControllerProvider.notifier);

    final order = await controller.placeOrder(
      cartItems: _cartItems(),
      coupons: [coupon],
    );

    expect(order.couponId, 'bean-order-3000');
    expect(order.couponTitle, coupon.title);
    expect(order.couponDiscount, 3000);
    expect(order.paidAmount, 59000);
    expect(order.earnedPoints, 5900);

    final coupons = await container.read(couponsControllerProvider.future);
    expect(
      coupons.firstWhere((c) => c.id == 'bean-order-3000').isUsed,
      isTrue,
    );

    final points = await container.read(pointsRepositoryProvider).load();
    expect(points.balance, 5900);
    expect(points.history.first.paymentAmount, 59000);
  });

  test('정률 쿠폰은 주문 금액의 비율만큼 할인된다', () async {
    final container = createContainer();
    final coupon = await loadCoupon(container, 'bean-order-10p');
    final controller = container.read(beanOrdersControllerProvider.notifier);

    final order = await controller.placeOrder(
      cartItems: _cartItems(),
      coupons: [coupon],
    );

    expect(order.couponDiscount, 6200);
    expect(order.paidAmount, 55800);
    expect(order.earnedPoints, 5580);
  });

  test('쿠폰과 포인트를 함께 사용하면 할인 후 금액에서 차감된다', () async {
    final container = createContainer();
    await container
        .read(pointsRepositoryProvider)
        .recordPayment(paymentAmount: 50000);
    final coupon = await loadCoupon(container, 'bean-order-3000');
    final controller = container.read(beanOrdersControllerProvider.notifier);

    final order = await controller.placeOrder(
      cartItems: _cartItems(),
      usedPoints: 5000,
      coupons: [coupon],
    );

    expect(order.couponDiscount, 3000);
    expect(order.usedPoints, 5000);
    expect(order.paidAmount, 54000);
    expect(order.earnedPoints, 5400);
  });

  test('할인 후 금액을 초과한 포인트 지정은 거부된다', () async {
    final container = createContainer();
    final coupon = await loadCoupon(container, 'bean-order-3000');
    final controller = container.read(beanOrdersControllerProvider.notifier);

    await expectLater(
      controller.placeOrder(
        cartItems: _cartItems(),
        usedPoints: 59001,
        coupons: [coupon],
      ),
      throwsArgumentError,
    );
  });

  test('최소 주문 금액 미달 쿠폰은 거부되고 주문이 생성되지 않는다', () async {
    final container = createContainer();
    final coupon = await loadCoupon(container, 'bean-order-3000');
    final controller = container.read(beanOrdersControllerProvider.notifier);
    final smallCart = [
      BeanCartItem(
        bean: _bean('a'),
        weight: BeanWeight.g200,
        grind: GrindOption.handDrip,
        quantity: 1,
      ),
    ];

    await expectLater(
      controller.placeOrder(cartItems: smallCart, coupons: [coupon]),
      throwsStateError,
    );

    final orders = await container.read(beanOrdersControllerProvider.future);
    expect(orders, isEmpty);
    final coupons = await container.read(couponsControllerProvider.future);
    expect(
      coupons.firstWhere((c) => c.id == 'bean-order-3000').isUsed,
      isFalse,
    );
  });

  test('결제 승인 정보가 주문에 기록된다', () async {
    final container = createContainer();
    final controller = container.read(beanOrdersControllerProvider.notifier);

    final order = await controller.placeOrder(
      cartItems: _cartItems(),
      payment: const PaymentApproval(
        paymentKey: 'pk-123',
        orderId: 'bean-123456',
        amount: 62000,
        method: '카드',
      ),
    );

    expect(order.paymentKey, 'pk-123');
    expect(order.paymentMethod, '카드');
    expect(order.paidAmount, 62000);

    final orders = await container.read(beanOrdersControllerProvider.future);
    expect(orders.first.paymentKey, 'pk-123');
    expect(orders.first.paymentMethod, '카드');
  });

  test('결제 승인 금액이 주문 금액과 다르면 거부된다', () async {
    final container = createContainer();
    final coupon = await loadCoupon(container, 'bean-order-3000');
    final controller = container.read(beanOrdersControllerProvider.notifier);

    await expectLater(
      controller.placeOrder(
        cartItems: _cartItems(),
        coupons: [coupon],
        payment: const PaymentApproval(
          paymentKey: 'pk-123',
          orderId: 'bean-123456',
          amount: 62000,
          method: '카드',
        ),
      ),
      throwsStateError,
    );

    final orders = await container.read(beanOrdersControllerProvider.future);
    expect(orders, isEmpty);
    final coupons = await container.read(couponsControllerProvider.future);
    expect(
      coupons.firstWhere((c) => c.id == 'bean-order-3000').isUsed,
      isFalse,
    );
  });

  test('이미 사용된 쿠폰은 적용할 수 없다', () async {
    final container = createContainer();
    final coupon = await loadCoupon(container, 'bean-order-3000');
    final controller = container.read(beanOrdersControllerProvider.notifier);

    await expectLater(
      controller.placeOrder(
        cartItems: _cartItems(),
        coupons: [coupon.copyWith(isUsed: true)],
      ),
      throwsStateError,
    );
  });

  test('중복 사용 쿠폰은 일반 쿠폰과 함께 적용되고 모두 사용 처리된다', () async {
    final container = createContainer();
    final regular = await loadCoupon(container, 'bean-order-3000');
    final stackable = await loadCoupon(container, 'stack-extra-1000');
    final controller = container.read(beanOrdersControllerProvider.notifier);

    final order = await controller.placeOrder(
      cartItems: _cartItems(),
      coupons: [regular, stackable],
    );

    expect(order.couponId, 'bean-order-3000,stack-extra-1000');
    expect(order.couponTitle, '${regular.title} + ${stackable.title}');
    expect(order.couponDiscount, 4000);
    expect(order.paidAmount, 58000);
    expect(order.earnedPoints, 5800);

    final coupons = await container.read(couponsControllerProvider.future);
    expect(
      coupons.firstWhere((c) => c.id == 'bean-order-3000').isUsed,
      isTrue,
    );
    expect(
      coupons.firstWhere((c) => c.id == 'stack-extra-1000').isUsed,
      isTrue,
    );
  });

  test('일반 쿠폰 2장은 함께 적용할 수 없다', () async {
    final container = createContainer();
    final first = await loadCoupon(container, 'bean-order-3000');
    final second = await loadCoupon(container, 'bean-order-10p');
    final controller = container.read(beanOrdersControllerProvider.notifier);

    await expectLater(
      controller.placeOrder(cartItems: _cartItems(), coupons: [first, second]),
      throwsStateError,
    );

    final orders = await container.read(beanOrdersControllerProvider.future);
    expect(orders, isEmpty);
    final coupons = await container.read(couponsControllerProvider.future);
    expect(coupons.any((c) => c.isUsed && c.id != 'used-latte-free'), isFalse);
  });

  test('중복 사용 쿠폰 단독으로도 적용할 수 있다', () async {
    final container = createContainer();
    final stackable = await loadCoupon(container, 'stack-extra-1000');
    final controller = container.read(beanOrdersControllerProvider.notifier);

    final order = await controller.placeOrder(
      cartItems: _cartItems(),
      coupons: [stackable],
    );

    expect(order.couponDiscount, 1000);
    expect(order.paidAmount, 61000);
  });

  test('주문 취소 시 쿠폰이 복구되고 포인트가 환급·회수된다', () async {
    final container = createContainer();
    await container
        .read(pointsRepositoryProvider)
        .recordPayment(paymentAmount: 50000);
    final coupon = await loadCoupon(container, 'bean-order-3000');
    final controller = container.read(beanOrdersControllerProvider.notifier);

    final order = await controller.placeOrder(
      cartItems: _cartItems(),
      usedPoints: 5000,
      coupons: [coupon],
    );
    expect(order.paidAmount, 54000);
    expect(order.earnedPoints, 5400);

    final cancelled = await controller.cancelOrder(order.id);

    expect(cancelled.status, BeanOrderStatus.cancelled);
    final orders = await container.read(beanOrdersControllerProvider.future);
    expect(orders.single.isCancelled, isTrue);

    final coupons = await container.read(couponsControllerProvider.future);
    expect(
      coupons.firstWhere((c) => c.id == 'bean-order-3000').isUsed,
      isFalse,
    );

    final points = await container.read(pointsRepositoryProvider).load();
    expect(points.balance, 5000);
    expect(
      points.history.map((entry) => entry.description),
      containsAll([
        '$beanOrderCancelDescription 포인트 환급',
        '$beanOrderCancelDescription 적립 회수',
      ]),
    );
  });

  test('포인트·쿠폰 없이 결제한 주문 취소 시 적립 포인트만 회수된다', () async {
    final container = createContainer();
    final controller = container.read(beanOrdersControllerProvider.notifier);

    final order = await controller.placeOrder(cartItems: _cartItems());
    expect(order.earnedPoints, 6200);

    await controller.cancelOrder(order.id);

    final points = await container.read(pointsRepositoryProvider).load();
    expect(points.balance, 0);
    expect(
      points.history.first.description,
      '$beanOrderCancelDescription 적립 회수',
    );
    expect(points.history.first.amount, -6200);
  });
}
