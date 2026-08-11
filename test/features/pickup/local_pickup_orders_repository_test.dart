import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cafe_app/features/pickup/data/local_pickup_orders_repository.dart';
import 'package:cafe_app/features/pickup/domain/pickup_order_models.dart';

const _items = [
  PickupOrderItem(
    menuId: 'espresso-vanilla-latte',
    menuName: '바닐라 라떼',
    option: 'ICED',
    quantity: 2,
    unitPrice: 6000,
  ),
  PickupOrderItem(
    menuId: 'dessert-croissant',
    menuName: '크루아상',
    quantity: 1,
    unitPrice: 4500,
  ),
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('저장된 주문이 없으면 빈 목록을 반환한다', () async {
    final repository = LocalPickupOrdersRepository();
    expect(await repository.load(), isEmpty);
  });

  test('주문을 생성하면 저장되고 다시 불러올 수 있다', () async {
    final repository = LocalPickupOrdersRepository();

    final order = await repository.placeOrder(
      items: _items,
      storeId: 'macheon',
      storeName: '폭스트롯 마천점',
      usedPoints: 1000,
      earnedPoints: 1550,
      couponId: 'bean-order-10p',
      couponTitle: '10% 할인',
      couponDiscount: 1650,
      paymentKey: 'pk-1',
      paymentMethod: '카드',
    );

    expect(order.totalAmount, 16500);
    expect(order.paidAmount, 16500 - 1650 - 1000);
    expect(order.pickupNumber, 1);
    expect(order.status, PickupOrderStatus.received);
    expect(order.itemCount, 3);
    expect(order.summary, '바닐라 라떼 외 1건');
    expect(order.items.first.nameWithOption, '바닐라 라떼 (ICED)');
    expect(order.items.last.nameWithOption, '크루아상');

    final loaded = await LocalPickupOrdersRepository().load();
    expect(loaded, hasLength(1));
    expect(loaded.first.id, order.id);
    expect(loaded.first.storeName, '폭스트롯 마천점');
    expect(loaded.first.paymentKey, 'pk-1');
  });

  test('같은 날 주문마다 주문번호가 1씩 증가한다', () async {
    final repository = LocalPickupOrdersRepository();

    final first = await repository.placeOrder(
      items: _items,
      storeId: 'macheon',
      storeName: '폭스트롯 마천점',
    );
    final second = await repository.placeOrder(
      items: _items,
      storeId: 'macheon',
      storeName: '폭스트롯 마천점',
    );

    expect(first.pickupNumber, 1);
    expect(second.pickupNumber, 2);
  });

  test('빈 상품 목록으로는 주문할 수 없다', () async {
    final repository = LocalPickupOrdersRepository();

    await expectLater(
      repository.placeOrder(
        items: const [],
        storeId: 'macheon',
        storeName: '폭스트롯 마천점',
      ),
      throwsArgumentError,
    );
  });

  test('주문번호는 당일 주문 수 기준으로 계산된다', () {
    final now = DateTime(2026, 8, 11, 14);
    final orders = [
      PickupOrder(
        id: '1',
        storeId: 'macheon',
        storeName: '폭스트롯 마천점',
        pickupNumber: 1,
        items: _items,
        totalAmount: 16500,
        createdAt: DateTime(2026, 8, 11, 9),
      ),
      PickupOrder(
        id: '2',
        storeId: 'macheon',
        storeName: '폭스트롯 마천점',
        pickupNumber: 7,
        items: _items,
        totalAmount: 16500,
        createdAt: DateTime(2026, 8, 10, 18),
      ),
    ];

    expect(nextPickupNumber(orders, now), 2);
    expect(nextPickupNumber(const [], now), 1);
  });
}
