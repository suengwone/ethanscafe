import 'package:flutter_test/flutter_test.dart';

import 'package:cafe_app/features/beans/domain/bean_models.dart';
import 'package:cafe_app/features/order/domain/admin_order_models.dart';
import 'package:cafe_app/features/order/domain/order_models.dart';
import 'package:cafe_app/features/pickup/domain/pickup_order_models.dart';

PickupOrder _pickup({
  PickupOrderStatus status = PickupOrderStatus.received,
  List<PickupOrderItem> items = const [],
}) {
  return PickupOrder(
    id: 'p1',
    storeId: 's1',
    storeName: '폭스트롯 마천점',
    pickupNumber: 12,
    items: items,
    totalAmount: 5000,
    status: status,
    createdAt: DateTime(2026, 8, 18, 10),
  );
}

BeanOrder _bean({
  BeanOrderStatus status = BeanOrderStatus.received,
  BeanFulfillmentMethod method = BeanFulfillmentMethod.delivery,
  List<BeanOrderItem> items = const [],
}) {
  return BeanOrder(
    id: 'b1',
    items: items,
    totalAmount: 30000,
    fulfillmentMethod: method,
    status: status,
    createdAt: DateTime(2026, 8, 18, 10),
  );
}

void main() {
  group('픽업 주문 상태 흐름', () {
    test('접수 → 제조 → 픽업대기 → 픽업완료 순서로 진행한다', () {
      expect(
        nextPickupStatus(PickupOrderStatus.received),
        PickupOrderStatus.preparing,
      );
      expect(
        nextPickupStatus(PickupOrderStatus.preparing),
        PickupOrderStatus.ready,
      );
      expect(
        nextPickupStatus(PickupOrderStatus.ready),
        PickupOrderStatus.pickedUp,
      );
    });

    test('마지막 단계와 취소는 다음 단계가 없다', () {
      expect(nextPickupStatus(PickupOrderStatus.pickedUp), isNull);
      expect(nextPickupStatus(PickupOrderStatus.cancelled), isNull);
    });
  });

  group('원두 주문 상태 흐름', () {
    test('배송 주문은 로스팅 → 발송 → 배송완료로 간다', () {
      expect(
        nextBeanStatus(
          BeanOrderStatus.received,
          BeanFulfillmentMethod.delivery,
        ),
        BeanOrderStatus.roasting,
      );
      expect(
        nextBeanStatus(
          BeanOrderStatus.roasting,
          BeanFulfillmentMethod.delivery,
        ),
        BeanOrderStatus.shipped,
      );
      expect(
        nextBeanStatus(BeanOrderStatus.shipped, BeanFulfillmentMethod.delivery),
        BeanOrderStatus.delivered,
      );
    });

    test('픽업 주문은 로스팅 → 픽업대기 → 픽업완료로 간다', () {
      expect(
        nextBeanStatus(BeanOrderStatus.roasting, BeanFulfillmentMethod.pickup),
        BeanOrderStatus.ready,
      );
      expect(
        nextBeanStatus(BeanOrderStatus.ready, BeanFulfillmentMethod.pickup),
        BeanOrderStatus.pickedUp,
      );
    });

    test('수령 방법이 다르면 흐름에 없는 상태는 진행되지 않는다', () {
      // 배송 흐름에 픽업대기는 없다
      expect(
        nextBeanStatus(BeanOrderStatus.ready, BeanFulfillmentMethod.delivery),
        isNull,
      );
      // 픽업 흐름에 발송완료는 없다
      expect(
        nextBeanStatus(BeanOrderStatus.shipped, BeanFulfillmentMethod.pickup),
        isNull,
      );
    });
  });

  group('처리 완료 판정', () {
    test('픽업 완료·취소는 목록에서 제외한다', () {
      expect(isPickupOrderClosed(_pickup(status: PickupOrderStatus.pickedUp)),
          isTrue);
      expect(isPickupOrderClosed(_pickup(status: PickupOrderStatus.cancelled)),
          isTrue);
      expect(isPickupOrderClosed(_pickup(status: PickupOrderStatus.preparing)),
          isFalse);
    });

    test('배송 완료·픽업 완료·취소한 원두 주문은 제외한다', () {
      expect(isBeanOrderClosed(_bean(status: BeanOrderStatus.delivered)), isTrue);
      expect(isBeanOrderClosed(_bean(status: BeanOrderStatus.pickedUp)), isTrue);
      expect(isBeanOrderClosed(_bean(status: BeanOrderStatus.cancelled)), isTrue);
      expect(isBeanOrderClosed(_bean(status: BeanOrderStatus.roasting)), isFalse);
    });
  });

  group('매장 취소 가능 여부', () {
    test('진행 중인 픽업 주문은 매장이 취소할 수 있다', () {
      expect(
        isPickupOrderCancellable(_pickup(status: PickupOrderStatus.received)),
        isTrue,
      );
      expect(
        isPickupOrderCancellable(_pickup(status: PickupOrderStatus.preparing)),
        isTrue,
      );
      expect(
        isPickupOrderCancellable(_pickup(status: PickupOrderStatus.ready)),
        isTrue,
      );
    });

    test('픽업이 끝났거나 이미 취소된 주문은 취소할 수 없다', () {
      expect(
        isPickupOrderCancellable(_pickup(status: PickupOrderStatus.pickedUp)),
        isFalse,
      );
      expect(
        isPickupOrderCancellable(_pickup(status: PickupOrderStatus.cancelled)),
        isFalse,
      );
    });

    test('발송한 원두 주문은 취소할 수 없다', () {
      expect(
        isBeanOrderCancellable(_bean(status: BeanOrderStatus.roasting)),
        isTrue,
      );
      expect(
        isBeanOrderCancellable(_bean(status: BeanOrderStatus.shipped)),
        isFalse,
      );
      expect(
        isBeanOrderCancellable(_bean(status: BeanOrderStatus.delivered)),
        isFalse,
      );
    });
  });

  group('주문 요약', () {
    test('상품이 하나면 이름만, 여럿이면 나머지 건수를 붙인다', () {
      expect(
        pickupOrderSummary(_pickup(items: const [
          PickupOrderItem(menuId: 'm1', menuName: '바닐라 라떼', quantity: 1, unitPrice: 5800),
        ])),
        '바닐라 라떼',
      );
      expect(
        pickupOrderSummary(_pickup(items: const [
          PickupOrderItem(menuId: 'm1', menuName: '바닐라 라떼', quantity: 1, unitPrice: 5800),
          PickupOrderItem(menuId: 'm2', menuName: '플레인 베이글', quantity: 1, unitPrice: 3800),
        ])),
        '바닐라 라떼 외 1건',
      );
    });

    test('상품이 없으면 기본 문구를 쓴다', () {
      expect(pickupOrderSummary(_pickup()), '주문');
      expect(beanOrderSummary(_bean()), '주문');
    });

    test('원두는 원두명으로 요약한다', () {
      expect(
        beanOrderSummary(_bean(items: const [
          BeanOrderItem(
            beanId: 'b1',
            beanName: '에티오피아 예가체프',
            weight: BeanWeight.g200,
            grind: GrindOption.wholeBean,
            quantity: 1,
            unitPrice: 15000,
          ),
        ])),
        '에티오피아 예가체프',
      );
    });
  });
}
