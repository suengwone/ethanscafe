import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cafe_app/features/beans/domain/bean_models.dart';
import 'package:cafe_app/features/order/data/firestore_bean_orders_repository.dart';
import 'package:cafe_app/features/order/domain/order_models.dart';

void main() {
  group('beanOrdersFromFirestore', () {
    test('Timestamp를 포함한 문서를 변환한다', () {
      final createdAt = DateTime(2026, 8, 5, 11, 20);
      final orders = beanOrdersFromFirestore({
        'orders': [
          {
            'id': 'order-1',
            'items': [
              {
                'beanId': 'ethiopia-yirgacheffe-aricha',
                'beanName': '에티오피아 예가체프 아리차 에이미 G1',
                'weight': 'g200',
                'grind': 'handDrip',
                'quantity': 2,
                'unitPrice': 18000,
              },
            ],
            'totalAmount': 36000,
            'usedPoints': 1000,
            'earnedPoints': 3500,
            'status': 'roasting',
            'createdAt': Timestamp.fromDate(createdAt),
          },
        ],
      });

      expect(orders, hasLength(1));
      final order = orders.first;
      expect(order.id, 'order-1');
      expect(order.items.first.weight, BeanWeight.g200);
      expect(order.items.first.grind, GrindOption.handDrip);
      expect(order.totalAmount, 36000);
      expect(order.usedPoints, 1000);
      expect(order.earnedPoints, 3500);
      expect(order.status, BeanOrderStatus.roasting);
      expect(order.createdAt, createdAt);
    });

    test('누락된 필드는 기본값으로 채운다', () {
      final orders = beanOrdersFromFirestore({
        'orders': [
          {
            'id': 'order-2',
            'createdAt': '2026-08-01T09:00:00.000',
          },
        ],
      });

      final order = orders.first;
      expect(order.items, isEmpty);
      expect(order.totalAmount, 0);
      expect(order.usedPoints, 0);
      expect(order.earnedPoints, 0);
      expect(order.couponId, isNull);
      expect(order.couponTitle, isNull);
      expect(order.couponDiscount, 0);
      expect(order.status, BeanOrderStatus.received);
      expect(order.fulfillmentMethod, BeanFulfillmentMethod.delivery);
      expect(order.storeId, isNull);
      expect(order.storeName, isNull);
      expect(order.recipient, isNull);
      expect(order.recipientPhone, isNull);
      expect(order.shippingAddress, isNull);
    });

    test('orders 필드가 없으면 빈 목록을 반환한다', () {
      expect(beanOrdersFromFirestore({}), isEmpty);
    });
  });

  group('beanOrdersToFirestore', () {
    test('createdAt을 Timestamp로 직렬화한다', () {
      final createdAt = DateTime(2026, 8, 5, 11, 20);
      final map = beanOrdersToFirestore([
        BeanOrder(
          id: 'order-1',
          items: const [
            BeanOrderItem(
              beanId: 'brazil-monte-belo-yellow-bourbon',
              beanName: '브라질 몬테 벨로 옐로우버본',
              weight: BeanWeight.g500,
              grind: GrindOption.wholeBean,
              quantity: 1,
              unitPrice: 32000,
            ),
          ],
          totalAmount: 32000,
          createdAt: createdAt,
        ),
      ]);

      final order = (map['orders'] as List<dynamic>).first as Map<String, dynamic>;
      expect(order['status'], 'received');
      expect(order['createdAt'], Timestamp.fromDate(createdAt));
      final item = (order['items'] as List<dynamic>).first as Map<String, dynamic>;
      expect(item['weight'], 'g500');
      expect(item['grind'], 'wholeBean');
    });

    test('round trip 시 데이터가 보존된다', () {
      final original = BeanOrder(
        id: 'order-3',
        items: const [
          BeanOrderItem(
            beanId: 'ethiopia-yirgacheffe-aricha',
            beanName: '에티오피아 예가체프 아리차 에이미 G1',
            weight: BeanWeight.g200,
            grind: GrindOption.espresso,
            quantity: 3,
            unitPrice: 18000,
          ),
        ],
        totalAmount: 54000,
        usedPoints: 4000,
        earnedPoints: 5000,
        couponId: 'bean-order-3000',
        couponTitle: '원두 주문 3,000원 할인',
        couponDiscount: 3000,
        status: BeanOrderStatus.shipped,
        createdAt: DateTime(2026, 8, 6, 15, 30),
      );

      final restored = beanOrdersFromFirestore(
        beanOrdersToFirestore([original]),
      ).first;

      expect(restored, original);
    });

    test('택배 배송 정보가 round trip 시 보존된다', () {
      final original = BeanOrder(
        id: 'order-4',
        items: const [
          BeanOrderItem(
            beanId: 'ethiopia-yirgacheffe-aricha',
            beanName: '에티오피아 예가체프 아리차 에이미 G1',
            weight: BeanWeight.g200,
            grind: GrindOption.handDrip,
            quantity: 1,
            unitPrice: 18000,
          ),
        ],
        totalAmount: 18000,
        recipient: '이단',
        recipientPhone: '010-1234-5678',
        shippingAddress: '서울 성동구 연무장길 47 101동 1001호',
        createdAt: DateTime(2026, 8, 7, 10),
      );

      final restored = beanOrdersFromFirestore(
        beanOrdersToFirestore([original]),
      ).first;

      expect(restored, original);
      expect(restored.fulfillmentMethod, BeanFulfillmentMethod.delivery);
    });

    test('매장 픽업 정보가 round trip 시 보존된다', () {
      final original = BeanOrder(
        id: 'order-5',
        items: const [
          BeanOrderItem(
            beanId: 'brazil-monte-belo-yellow-bourbon',
            beanName: '브라질 몬테 벨로 옌로우버본',
            weight: BeanWeight.g500,
            grind: GrindOption.wholeBean,
            quantity: 2,
            unitPrice: 32000,
          ),
        ],
        totalAmount: 64000,
        fulfillmentMethod: BeanFulfillmentMethod.pickup,
        storeId: 'macheon',
        storeName: '폭스트롯 마천점',
        status: BeanOrderStatus.ready,
        createdAt: DateTime(2026, 8, 8, 14),
      );

      final restored = beanOrdersFromFirestore(
        beanOrdersToFirestore([original]),
      ).first;

      expect(restored, original);
      expect(restored.storeName, '폭스트롯 마천점');
      expect(restored.status, BeanOrderStatus.ready);
    });
  });
}
