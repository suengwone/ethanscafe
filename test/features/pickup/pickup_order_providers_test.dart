import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cafe_app/features/coupon/domain/coupon_models.dart';
import 'package:cafe_app/features/coupon/presentation/coupons_providers.dart';
import 'package:cafe_app/features/menu/domain/menu_models.dart';
import 'package:cafe_app/features/payment/domain/payment_models.dart';
import 'package:cafe_app/features/pickup/domain/pickup_cart_models.dart';
import 'package:cafe_app/features/pickup/domain/pickup_order_models.dart';
import 'package:cafe_app/features/pickup/presentation/pickup_order_providers.dart';
import 'package:cafe_app/features/points/domain/points_models.dart';
import 'package:cafe_app/features/points/presentation/points_providers.dart';
import 'package:cafe_app/features/store/domain/store_models.dart';

MenuItem _menuItem(String id, {int price = 6000}) {
  return MenuItem(
    id: id,
    name: '테스트 메뉴 $id',
    description: '테스트 설명',
    category: MenuCategory.espresso,
    price: price,
    servingOptions: const ['HOT', 'ICED'],
  );
}

List<PickupCartItem> _cartItems() => [
      PickupCartItem(menuItem: _menuItem('a'), option: 'ICED', quantity: 2),
      PickupCartItem(menuItem: _menuItem('b', price: 8000), quantity: 1),
    ];

const _store = CafeStore(
  id: 'macheon',
  name: '폭스트롯 마천점',
  address: '서울 송파구',
  phone: '02-000-0000',
  latitude: 37.5,
  longitude: 127.1,
  weekdayHours: '08:00 - 22:00',
  weekendHours: '10:00 - 22:00',
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
    final controller = container.read(pickupOrdersControllerProvider.notifier);

    final order = await controller.placeOrder(
      cartItems: _cartItems(),
      store: _store,
    );

    expect(order.totalAmount, 20000);
    expect(order.usedPoints, 0);
    expect(order.earnedPoints, 2000);
    expect(order.paidAmount, 20000);
    expect(order.storeId, 'macheon');
    expect(order.pickupNumber, 1);

    final orders = await container.read(pickupOrdersControllerProvider.future);
    expect(orders, hasLength(1));

    final points = await container.read(pointsRepositoryProvider).load();
    expect(points.balance, 2000);
    expect(points.history.first.description, pickupOrderPaymentDescription);
    expect(points.history.first.paymentAmount, 20000);
  });

  test('포인트 사용 시 잔액이 차감되고 결제 금액 기준으로 적립된다', () async {
    final container = createContainer();
    await container
        .read(pointsRepositoryProvider)
        .recordPayment(paymentAmount: 50000);

    final controller = container.read(pickupOrdersControllerProvider.notifier);
    final order = await controller.placeOrder(
      cartItems: _cartItems(),
      store: _store,
      usedPoints: 5000,
    );

    expect(order.usedPoints, 5000);
    expect(order.paidAmount, 15000);
    expect(order.earnedPoints, 1500);

    final points = await container.read(pointsRepositoryProvider).load();
    expect(points.balance, 1500);
    expect(
      points.history.map((entry) => entry.description),
      containsAll(
        [pickupOrderPaymentDescription, pickupOrderPointsUseDescription],
      ),
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
        .recordPayment(paymentAmount: 300000);

    final controller = container.read(pickupOrdersControllerProvider.notifier);
    final order = await controller.placeOrder(
      cartItems: _cartItems(),
      store: _store,
      usedPoints: 20000,
    );

    expect(order.paidAmount, 0);
    expect(order.earnedPoints, 0);

    final points = await container.read(pointsRepositoryProvider).load();
    expect(points.balance, 30000 - 20000);
  });

  test('잔액을 초과한 포인트 사용은 실패하고 주문이 생성되지 않는다', () async {
    final container = createContainer();
    final controller = container.read(pickupOrdersControllerProvider.notifier);

    await expectLater(
      controller.placeOrder(
        cartItems: _cartItems(),
        store: _store,
        usedPoints: 1000,
      ),
      throwsStateError,
    );

    final orders = await container.read(pickupOrdersControllerProvider.future);
    expect(orders, isEmpty);
  });

  test('결제 금액을 초과한 포인트 지정은 거부된다', () async {
    final container = createContainer();
    final controller = container.read(pickupOrdersControllerProvider.notifier);

    await expectLater(
      controller.placeOrder(
        cartItems: _cartItems(),
        store: _store,
        usedPoints: 20001,
      ),
      throwsArgumentError,
    );
  });

  test('빈 장바구니로는 주문할 수 없다', () async {
    final container = createContainer();
    final controller = container.read(pickupOrdersControllerProvider.notifier);

    await expectLater(
      controller.placeOrder(cartItems: const [], store: _store),
      throwsStateError,
    );
  });

  Future<Coupon> loadCoupon(ProviderContainer container, String id) async {
    final coupons = await container.read(couponsControllerProvider.future);
    return coupons.firstWhere((coupon) => coupon.id == id);
  }

  test('정률 쿠폰 적용 시 할인되고 쿠폰이 사용 처리된다', () async {
    final container = createContainer();
    final coupon = await loadCoupon(container, 'bean-order-10p');
    final controller = container.read(pickupOrdersControllerProvider.notifier);

    final order = await controller.placeOrder(
      cartItems: _cartItems(),
      store: _store,
      coupons: [coupon],
    );

    expect(order.couponId, 'bean-order-10p');
    expect(order.couponTitle, coupon.title);
    expect(order.couponDiscount, 2000);
    expect(order.paidAmount, 18000);
    expect(order.earnedPoints, 1800);

    final coupons = await container.read(couponsControllerProvider.future);
    expect(
      coupons.firstWhere((c) => c.id == 'bean-order-10p').isUsed,
      isTrue,
    );

    final points = await container.read(pointsRepositoryProvider).load();
    expect(points.balance, 1800);
    expect(points.history.first.paymentAmount, 18000);
  });

  test('쿠폰과 포인트를 함께 사용하면 할인 후 금액에서 차감된다', () async {
    final container = createContainer();
    await container
        .read(pointsRepositoryProvider)
        .recordPayment(paymentAmount: 50000);
    final coupon = await loadCoupon(container, 'bean-order-10p');
    final controller = container.read(pickupOrdersControllerProvider.notifier);

    final order = await controller.placeOrder(
      cartItems: _cartItems(),
      store: _store,
      usedPoints: 5000,
      coupons: [coupon],
    );

    expect(order.couponDiscount, 2000);
    expect(order.usedPoints, 5000);
    expect(order.paidAmount, 13000);
    expect(order.earnedPoints, 1300);
  });

  test('할인 후 금액을 초과한 포인트 지정은 거부된다', () async {
    final container = createContainer();
    final coupon = await loadCoupon(container, 'bean-order-10p');
    final controller = container.read(pickupOrdersControllerProvider.notifier);

    await expectLater(
      controller.placeOrder(
        cartItems: _cartItems(),
        store: _store,
        usedPoints: 18001,
        coupons: [coupon],
      ),
      throwsArgumentError,
    );
  });

  test('최소 주문 금액 미달 쿠폰은 거부되고 주문이 생성되지 않는다', () async {
    final container = createContainer();
    final coupon = await loadCoupon(container, 'bean-order-3000');
    final controller = container.read(pickupOrdersControllerProvider.notifier);
    final smallCart = [
      PickupCartItem(menuItem: _menuItem('a'), option: 'HOT', quantity: 1),
    ];

    await expectLater(
      controller.placeOrder(
        cartItems: smallCart,
        store: _store,
        coupons: [coupon],
      ),
      throwsStateError,
    );

    final orders = await container.read(pickupOrdersControllerProvider.future);
    expect(orders, isEmpty);
    final coupons = await container.read(couponsControllerProvider.future);
    expect(
      coupons.firstWhere((c) => c.id == 'bean-order-3000').isUsed,
      isFalse,
    );
  });

  test('결제 승인 정보가 주문에 기록된다', () async {
    final container = createContainer();
    final controller = container.read(pickupOrdersControllerProvider.notifier);

    final order = await controller.placeOrder(
      cartItems: _cartItems(),
      store: _store,
      payment: const PaymentApproval(
        paymentKey: 'pk-123',
        orderId: 'pickup-123456',
        amount: 20000,
        method: '카드',
      ),
    );

    expect(order.paymentKey, 'pk-123');
    expect(order.paymentMethod, '카드');
    expect(order.paidAmount, 20000);

    final orders = await container.read(pickupOrdersControllerProvider.future);
    expect(orders.first.paymentKey, 'pk-123');
    expect(orders.first.paymentMethod, '카드');
  });

  test('결제 승인 금액이 주문 금액과 다르면 거부된다', () async {
    final container = createContainer();
    final coupon = await loadCoupon(container, 'bean-order-10p');
    final controller = container.read(pickupOrdersControllerProvider.notifier);

    await expectLater(
      controller.placeOrder(
        cartItems: _cartItems(),
        store: _store,
        coupons: [coupon],
        payment: const PaymentApproval(
          paymentKey: 'pk-123',
          orderId: 'pickup-123456',
          amount: 20000,
          method: '카드',
        ),
      ),
      throwsStateError,
    );

    final orders = await container.read(pickupOrdersControllerProvider.future);
    expect(orders, isEmpty);
    final coupons = await container.read(couponsControllerProvider.future);
    expect(
      coupons.firstWhere((c) => c.id == 'bean-order-10p').isUsed,
      isFalse,
    );
  });

  test('이미 사용된 쿠폰은 적용할 수 없다', () async {
    final container = createContainer();
    final coupon = await loadCoupon(container, 'bean-order-10p');
    final controller = container.read(pickupOrdersControllerProvider.notifier);

    await expectLater(
      controller.placeOrder(
        cartItems: _cartItems(),
        store: _store,
        coupons: [coupon.copyWith(isUsed: true)],
      ),
      throwsStateError,
    );
  });

  test('중복 사용 쿠폰은 일반 쿠폰과 함께 적용되고 모두 사용 처리된다', () async {
    final container = createContainer();
    final regular = await loadCoupon(container, 'bean-order-10p');
    final stackable = await loadCoupon(container, 'stack-extra-1000');
    final controller = container.read(pickupOrdersControllerProvider.notifier);

    final order = await controller.placeOrder(
      cartItems: _cartItems(),
      store: _store,
      coupons: [regular, stackable],
    );

    expect(order.couponId, 'bean-order-10p,stack-extra-1000');
    expect(order.couponTitle, '${regular.title} + ${stackable.title}');
    expect(order.couponDiscount, 3000);
    expect(order.paidAmount, 17000);
    expect(order.earnedPoints, 1700);

    final coupons = await container.read(couponsControllerProvider.future);
    expect(
      coupons.firstWhere((c) => c.id == 'bean-order-10p').isUsed,
      isTrue,
    );
    expect(
      coupons.firstWhere((c) => c.id == 'stack-extra-1000').isUsed,
      isTrue,
    );
  });

  test('일반 쿠폰 2장은 함께 적용할 수 없다', () async {
    final container = createContainer();
    final first = await loadCoupon(container, 'bean-order-10p');
    final second = await loadCoupon(container, 'bean-order-3000');
    final controller = container.read(pickupOrdersControllerProvider.notifier);

    await expectLater(
      controller.placeOrder(
        cartItems: _cartItems(),
        store: _store,
        coupons: [first, second],
      ),
      throwsStateError,
    );

    final orders = await container.read(pickupOrdersControllerProvider.future);
    expect(orders, isEmpty);
    final coupons = await container.read(couponsControllerProvider.future);
    expect(coupons.any((c) => c.isUsed && c.id != 'used-latte-free'), isFalse);
  });
}
