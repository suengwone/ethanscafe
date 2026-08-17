import 'package:flutter_test/flutter_test.dart';

import 'package:cafe_app/features/order/domain/admin_order_models.dart';
import 'package:cafe_app/features/order/domain/order_models.dart';
import 'package:cafe_app/features/pickup/domain/pickup_order_models.dart';

ActiveBeanOrder _bean({
  BeanOrderStatus status = BeanOrderStatus.received,
  BeanFulfillmentMethod method = BeanFulfillmentMethod.delivery,
  String? recipient,
  String? storeName,
}) {
  return ActiveBeanOrder(
    uid: 'u1',
    orderId: 'b1',
    summary: '에티오피아 예가체프',
    status: status,
    fulfillmentMethod: method,
    recipient: recipient,
    storeName: storeName,
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

  group('매장 취소 가능 여부', () {
    test('진행 중인 픽업 주문은 매장이 취소할 수 있다', () {
      expect(isPickupStatusCancellable(PickupOrderStatus.received), isTrue);
      expect(isPickupStatusCancellable(PickupOrderStatus.preparing), isTrue);
      expect(isPickupStatusCancellable(PickupOrderStatus.ready), isTrue);
    });

    test('픽업이 끝났거나 이미 취소된 주문은 취소할 수 없다', () {
      expect(isPickupStatusCancellable(PickupOrderStatus.pickedUp), isFalse);
      expect(isPickupStatusCancellable(PickupOrderStatus.cancelled), isFalse);
    });

    test('발송한 원두 주문은 취소할 수 없다', () {
      expect(isBeanStatusCancellable(BeanOrderStatus.roasting), isTrue);
      expect(isBeanStatusCancellable(BeanOrderStatus.shipped), isFalse);
      expect(isBeanStatusCancellable(BeanOrderStatus.delivered), isFalse);
    });
  });

  group('원두 주문 수령지 표기', () {
    test('배송 주문은 수령인을 보여준다', () {
      expect(_bean(recipient: '이단').destinationLabel, '이단');
      expect(_bean().destinationLabel, '수령인 미지정');
    });

    test('픽업 주문은 매장을 보여준다', () {
      expect(
        _bean(
          method: BeanFulfillmentMethod.pickup,
          storeName: '폭스트롯 마천점',
        ).destinationLabel,
        '폭스트롯 마천점',
      );
      expect(
        _bean(method: BeanFulfillmentMethod.pickup).destinationLabel,
        '매장 미지정',
      );
    });
  });
}
