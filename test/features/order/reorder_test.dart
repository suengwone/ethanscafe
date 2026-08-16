import 'package:flutter_test/flutter_test.dart';

import 'package:cafe_app/features/beans/domain/bean_models.dart';
import 'package:cafe_app/features/menu/domain/menu_models.dart';
import 'package:cafe_app/features/order/domain/order_models.dart';
import 'package:cafe_app/features/order/domain/reorder.dart';
import 'package:cafe_app/features/pickup/domain/pickup_order_models.dart';

Bean _bean(String id) {
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
    price200: 15000,
    price500: 32000,
  );
}

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

BeanOrder _beanOrder(List<BeanOrderItem> items) {
  return BeanOrder(
    id: 'order-1',
    items: items,
    totalAmount: items.fold(0, (sum, item) => sum + item.totalPrice),
    createdAt: DateTime(2026, 8, 1),
  );
}

PickupOrder _pickupOrder(List<PickupOrderItem> items) {
  return PickupOrder(
    id: 'order-1',
    storeId: 'store-1',
    storeName: '테스트 매장',
    pickupNumber: 1,
    items: items,
    totalAmount: items.fold(0, (sum, item) => sum + item.totalPrice),
    createdAt: DateTime(2026, 8, 1),
  );
}

void main() {
  group('buildBeanReorder', () {
    test('주문 항목을 동일 구성의 장바구니 아이템으로 변환한다', () {
      final order = _beanOrder([
        const BeanOrderItem(
          beanId: 'a',
          beanName: '테스트 원두 a',
          weight: BeanWeight.g200,
          grind: GrindOption.wholeBean,
          quantity: 2,
          unitPrice: 15000,
        ),
        const BeanOrderItem(
          beanId: 'b',
          beanName: '테스트 원두 b',
          weight: BeanWeight.g500,
          grind: GrindOption.handDrip,
          quantity: 1,
          unitPrice: 32000,
        ),
      ]);

      final result = buildBeanReorder(
        order: order,
        beans: [_bean('a'), _bean('b')],
      );

      expect(result.hasMissing, isFalse);
      expect(result.items, hasLength(2));
      expect(result.items.first.bean.id, 'a');
      expect(result.items.first.weight, BeanWeight.g200);
      expect(result.items.first.grind, GrindOption.wholeBean);
      expect(result.items.first.quantity, 2);
      expect(result.items[1].bean.id, 'b');
      expect(result.items[1].weight, BeanWeight.g500);
    });

    test('판매 종료된 원두는 제외하고 이름을 알려준다', () {
      final order = _beanOrder([
        const BeanOrderItem(
          beanId: 'a',
          beanName: '테스트 원두 a',
          weight: BeanWeight.g200,
          grind: GrindOption.wholeBean,
          quantity: 1,
          unitPrice: 15000,
        ),
        const BeanOrderItem(
          beanId: 'gone',
          beanName: '단종 원두',
          weight: BeanWeight.g200,
          grind: GrindOption.espresso,
          quantity: 1,
          unitPrice: 18000,
        ),
      ]);

      final result = buildBeanReorder(order: order, beans: [_bean('a')]);

      expect(result.items, hasLength(1));
      expect(result.items.first.bean.id, 'a');
      expect(result.missingNames, ['단종 원두']);
      expect(result.hasMissing, isTrue);
      expect(result.hasItems, isTrue);
    });

    test('모든 원두가 판매 종료면 담을 아이템이 없다', () {
      final order = _beanOrder([
        const BeanOrderItem(
          beanId: 'gone',
          beanName: '단종 원두',
          weight: BeanWeight.g200,
          grind: GrindOption.wholeBean,
          quantity: 1,
          unitPrice: 15000,
        ),
      ]);

      final result = buildBeanReorder(order: order, beans: [_bean('a')]);

      expect(result.hasItems, isFalse);
      expect(result.missingNames, ['단종 원두']);
    });
  });

  group('buildPickupReorder', () {
    test('주문 항목을 동일 구성의 장바구니 아이템으로 변환한다', () {
      final order = _pickupOrder([
        const PickupOrderItem(
          menuId: 'a',
          menuName: '테스트 메뉴 a',
          option: 'ICED',
          quantity: 2,
          unitPrice: 6000,
        ),
        const PickupOrderItem(
          menuId: 'b',
          menuName: '테스트 메뉴 b',
          quantity: 1,
          unitPrice: 7000,
        ),
      ]);

      final result = buildPickupReorder(
        order: order,
        menuItems: [_menuItem('a'), _menuItem('b', price: 7000)],
      );

      expect(result.hasMissing, isFalse);
      expect(result.items, hasLength(2));
      expect(result.items.first.menuItem.id, 'a');
      expect(result.items.first.option, 'ICED');
      expect(result.items.first.quantity, 2);
      expect(result.items[1].menuItem.id, 'b');
      expect(result.items[1].option, isNull);
    });

    test('판매 종료된 메뉴는 제외하고 이름을 알려준다', () {
      final order = _pickupOrder([
        const PickupOrderItem(
          menuId: 'gone',
          menuName: '단종 메뉴',
          option: 'HOT',
          quantity: 1,
          unitPrice: 6000,
        ),
        const PickupOrderItem(
          menuId: 'a',
          menuName: '테스트 메뉴 a',
          option: 'HOT',
          quantity: 1,
          unitPrice: 6000,
        ),
      ]);

      final result = buildPickupReorder(
        order: order,
        menuItems: [_menuItem('a')],
      );

      expect(result.items, hasLength(1));
      expect(result.items.first.menuItem.id, 'a');
      expect(result.missingNames, ['단종 메뉴']);
    });
  });
}
