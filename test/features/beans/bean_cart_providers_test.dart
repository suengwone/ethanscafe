import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cafe_app/features/beans/domain/bean_models.dart';
import 'package:cafe_app/features/beans/presentation/bean_cart_providers.dart';

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

void main() {
  ProviderContainer createContainer() {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    return container;
  }

  test('원두를 장바구니에 담는다', () {
    final container = createContainer();
    final notifier = container.read(beanCartProvider.notifier);

    notifier.add(
      bean: _bean('a'),
      weight: BeanWeight.g200,
      grind: GrindOption.wholeBean,
    );

    final items = container.read(beanCartProvider);
    expect(items, hasLength(1));
    expect(items.first.quantity, 1);
    expect(items.first.totalPrice, 15000);
  });

  test('같은 원두·같은 옵션은 수량이 합쳐진다', () {
    final container = createContainer();
    final notifier = container.read(beanCartProvider.notifier);

    notifier.add(
      bean: _bean('a'),
      weight: BeanWeight.g200,
      grind: GrindOption.wholeBean,
      quantity: 2,
    );
    notifier.add(
      bean: _bean('a'),
      weight: BeanWeight.g200,
      grind: GrindOption.wholeBean,
      quantity: 3,
    );

    final items = container.read(beanCartProvider);
    expect(items, hasLength(1));
    expect(items.first.quantity, 5);
  });

  test('수량 합산은 최대 수량을 넘지 않는다', () {
    final container = createContainer();
    final notifier = container.read(beanCartProvider.notifier);

    notifier.add(
      bean: _bean('a'),
      weight: BeanWeight.g200,
      grind: GrindOption.wholeBean,
      quantity: 8,
    );
    notifier.add(
      bean: _bean('a'),
      weight: BeanWeight.g200,
      grind: GrindOption.wholeBean,
      quantity: 5,
    );

    expect(container.read(beanCartProvider).first.quantity, beanCartMaxQuantity);
  });

  test('같은 원두라도 옵션이 다르면 따로 담긴다', () {
    final container = createContainer();
    final notifier = container.read(beanCartProvider.notifier);

    notifier.add(
      bean: _bean('a'),
      weight: BeanWeight.g200,
      grind: GrindOption.wholeBean,
    );
    notifier.add(
      bean: _bean('a'),
      weight: BeanWeight.g500,
      grind: GrindOption.wholeBean,
    );
    notifier.add(
      bean: _bean('a'),
      weight: BeanWeight.g200,
      grind: GrindOption.handDrip,
    );

    expect(container.read(beanCartProvider), hasLength(3));
  });

  test('수량을 변경한다', () {
    final container = createContainer();
    final notifier = container.read(beanCartProvider.notifier);
    notifier.add(
      bean: _bean('a'),
      weight: BeanWeight.g200,
      grind: GrindOption.wholeBean,
    );

    notifier.changeQuantity(0, 4);
    expect(container.read(beanCartProvider).first.quantity, 4);

    notifier.changeQuantity(0, 0);
    expect(container.read(beanCartProvider).first.quantity, 4);

    notifier.changeQuantity(0, beanCartMaxQuantity + 1);
    expect(container.read(beanCartProvider).first.quantity, 4);

    notifier.changeQuantity(5, 2);
    expect(container.read(beanCartProvider).first.quantity, 4);
  });

  test('항목을 삭제한다', () {
    final container = createContainer();
    final notifier = container.read(beanCartProvider.notifier);
    notifier.add(
      bean: _bean('a'),
      weight: BeanWeight.g200,
      grind: GrindOption.wholeBean,
    );
    notifier.add(
      bean: _bean('b'),
      weight: BeanWeight.g500,
      grind: GrindOption.espresso,
    );

    notifier.removeAt(0);

    final items = container.read(beanCartProvider);
    expect(items, hasLength(1));
    expect(items.first.bean.id, 'b');
  });

  test('장바구니를 비운다', () {
    final container = createContainer();
    final notifier = container.read(beanCartProvider.notifier);
    notifier.add(
      bean: _bean('a'),
      weight: BeanWeight.g200,
      grind: GrindOption.wholeBean,
    );

    notifier.clear();

    expect(container.read(beanCartProvider), isEmpty);
  });

  test('총 수량과 총 금액을 계산한다', () {
    final container = createContainer();
    final notifier = container.read(beanCartProvider.notifier);
    notifier.add(
      bean: _bean('a', price200: 15000),
      weight: BeanWeight.g200,
      grind: GrindOption.wholeBean,
      quantity: 2,
    );
    notifier.add(
      bean: _bean('b', price500: 32000),
      weight: BeanWeight.g500,
      grind: GrindOption.handDrip,
    );

    expect(container.read(beanCartCountProvider), 3);
    expect(container.read(beanCartTotalProvider), 15000 * 2 + 32000);
  });

  test('지운 항목을 원래 자리에 되돌린다', () {
    final container = createContainer();
    final notifier = container.read(beanCartProvider.notifier);
    notifier.add(
      bean: _bean('a'),
      weight: BeanWeight.g200,
      grind: GrindOption.wholeBean,
    );
    notifier.add(
      bean: _bean('b'),
      weight: BeanWeight.g500,
      grind: GrindOption.handDrip,
    );

    final removed = container.read(beanCartProvider).first;
    notifier.removeAt(0);
    expect(container.read(beanCartProvider), hasLength(1));

    notifier.insertAt(0, removed);

    final items = container.read(beanCartProvider);
    expect(items, hasLength(2));
    expect(items.first.bean.id, 'a');
    expect(items.first.weight, BeanWeight.g200);
  });
}
