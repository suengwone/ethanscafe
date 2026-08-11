import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cafe_app/features/menu/domain/menu_models.dart';
import 'package:cafe_app/features/pickup/presentation/pickup_cart_providers.dart';

MenuItem _menuItem(
  String id, {
  int price = 6000,
  List<String> servingOptions = const ['HOT', 'ICED'],
}) {
  return MenuItem(
    id: id,
    name: '테스트 메뉴 $id',
    description: '테스트 설명',
    category: MenuCategory.espresso,
    price: price,
    servingOptions: servingOptions,
  );
}

void main() {
  ProviderContainer createContainer() {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    return container;
  }

  test('메뉴를 장바구니에 담는다', () {
    final container = createContainer();
    final notifier = container.read(pickupCartProvider.notifier);

    notifier.add(menuItem: _menuItem('a'), option: 'HOT');

    final items = container.read(pickupCartProvider);
    expect(items, hasLength(1));
    expect(items.first.quantity, 1);
    expect(items.first.totalPrice, 6000);
  });

  test('같은 메뉴·같은 옵션은 수량이 합쳐진다', () {
    final container = createContainer();
    final notifier = container.read(pickupCartProvider.notifier);

    notifier.add(menuItem: _menuItem('a'), option: 'HOT', quantity: 2);
    notifier.add(menuItem: _menuItem('a'), option: 'HOT', quantity: 3);

    final items = container.read(pickupCartProvider);
    expect(items, hasLength(1));
    expect(items.first.quantity, 5);
  });

  test('수량 합산은 최대 수량을 넘지 않는다', () {
    final container = createContainer();
    final notifier = container.read(pickupCartProvider.notifier);

    notifier.add(menuItem: _menuItem('a'), option: 'HOT', quantity: 8);
    notifier.add(menuItem: _menuItem('a'), option: 'HOT', quantity: 5);

    expect(
      container.read(pickupCartProvider).first.quantity,
      pickupCartMaxQuantity,
    );
  });

  test('같은 메뉴라도 옵션이 다르면 따로 담긴다', () {
    final container = createContainer();
    final notifier = container.read(pickupCartProvider.notifier);

    notifier.add(menuItem: _menuItem('a'), option: 'HOT');
    notifier.add(menuItem: _menuItem('a'), option: 'ICED');

    expect(container.read(pickupCartProvider), hasLength(2));
  });

  test('옵션이 없는 메뉴도 담긴다', () {
    final container = createContainer();
    final notifier = container.read(pickupCartProvider.notifier);

    notifier.add(menuItem: _menuItem('a', servingOptions: const []));
    notifier.add(menuItem: _menuItem('a', servingOptions: const []));

    final items = container.read(pickupCartProvider);
    expect(items, hasLength(1));
    expect(items.first.option, isNull);
    expect(items.first.quantity, 2);
  });

  test('수량을 변경한다', () {
    final container = createContainer();
    final notifier = container.read(pickupCartProvider.notifier);
    notifier.add(menuItem: _menuItem('a'), option: 'HOT');

    notifier.changeQuantity(0, 4);
    expect(container.read(pickupCartProvider).first.quantity, 4);

    notifier.changeQuantity(0, 0);
    expect(container.read(pickupCartProvider).first.quantity, 4);

    notifier.changeQuantity(0, pickupCartMaxQuantity + 1);
    expect(container.read(pickupCartProvider).first.quantity, 4);

    notifier.changeQuantity(5, 2);
    expect(container.read(pickupCartProvider).first.quantity, 4);
  });

  test('항목을 삭제한다', () {
    final container = createContainer();
    final notifier = container.read(pickupCartProvider.notifier);
    notifier.add(menuItem: _menuItem('a'), option: 'HOT');
    notifier.add(menuItem: _menuItem('b'), option: 'ICED');

    notifier.removeAt(0);

    final items = container.read(pickupCartProvider);
    expect(items, hasLength(1));
    expect(items.first.menuItem.id, 'b');
  });

  test('장바구니를 비운다', () {
    final container = createContainer();
    final notifier = container.read(pickupCartProvider.notifier);
    notifier.add(menuItem: _menuItem('a'), option: 'HOT');

    notifier.clear();

    expect(container.read(pickupCartProvider), isEmpty);
  });

  test('총 수량과 총 금액을 계산한다', () {
    final container = createContainer();
    final notifier = container.read(pickupCartProvider.notifier);
    notifier.add(
      menuItem: _menuItem('a', price: 6000),
      option: 'HOT',
      quantity: 2,
    );
    notifier.add(menuItem: _menuItem('b', price: 8000), option: 'ICED');

    expect(container.read(pickupCartCountProvider), 3);
    expect(container.read(pickupCartTotalProvider), 6000 * 2 + 8000);
  });
}
