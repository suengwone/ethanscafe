import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cafe_app/features/beans/domain/bean_models.dart';
import 'package:cafe_app/features/order/data/local_bean_orders_repository.dart';
import 'package:cafe_app/features/order/domain/order_models.dart';

const _items = [
  BeanOrderItem(
    beanId: 'ethiopia-yirgacheffe-aricha',
    beanName: '에티오피아 예가체프 아리차 에이미 G1',
    weight: BeanWeight.g200,
    grind: GrindOption.handDrip,
    quantity: 2,
    unitPrice: 18000,
  ),
  BeanOrderItem(
    beanId: 'brazil-monte-belo-yellow-bourbon',
    beanName: '브라질 몬테 벨로 옐로우버본',
    weight: BeanWeight.g500,
    grind: GrindOption.wholeBean,
    quantity: 1,
    unitPrice: 32000,
  ),
];

void main() {
  late LocalBeanOrdersRepository repository;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repository = LocalBeanOrdersRepository();
  });

  test('최초 로드 시 빈 주문 목록을 반환한다', () async {
    final orders = await repository.load();

    expect(orders, isEmpty);
  });

  test('주문 생성 시 합계와 상태가 기록된다', () async {
    final order = await repository.placeOrder(
      items: _items,
      usedPoints: 1000,
      earnedPoints: 6700,
    );

    expect(order.id, isNotEmpty);
    expect(order.items, hasLength(2));
    expect(order.totalAmount, 68000);
    expect(order.usedPoints, 1000);
    expect(order.earnedPoints, 6700);
    expect(order.paidAmount, 67000);
    expect(order.itemCount, 3);
    expect(order.status, BeanOrderStatus.received);
  });

  test('빈 상품 목록으로는 주문할 수 없다', () async {
    expect(() => repository.placeOrder(items: const []), throwsArgumentError);
  });

  test('주문이 로컬에 영속화되고 최신순으로 쌓인다', () async {
    await repository.placeOrder(items: [_items.first]);
    final second = await repository.placeOrder(items: [_items.last]);

    final reloaded = await LocalBeanOrdersRepository().load();

    expect(reloaded, hasLength(2));
    expect(reloaded.first.id, second.id);
    expect(reloaded.first.items.first.beanId, _items.last.beanId);
  });

  test('주문 요약과 옵션 라벨을 제공한다', () async {
    final order = await repository.placeOrder(items: _items);

    expect(order.summary, '에티오피아 예가체프 아리차 에이미 G1 외 1건');
    expect(order.items.first.optionLabel, '200g · 핸드드립');
  });
}
