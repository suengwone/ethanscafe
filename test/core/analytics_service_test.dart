import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cafe_app/core/services/analytics_service.dart';
import 'package:cafe_app/features/order/presentation/order_failure_message.dart';

void main() {
  group('실패 사유 분류', () {
    FirebaseFunctionsException error(String code, String message) =>
        FirebaseFunctionsException(code: code, message: message);

    test('결제 뒤 서버가 거절한 까닭을 세어 볼 수 있게 줄인다', () {
      // 문구가 바뀌어도 같은 지표로 남게, 사람이 읽는 문장 대신 값으로 묶는다.
      expect(
        analyticsReason(
          error(
            'aborted',
            '주문에 실패해 결제를 자동 취소(환불)했습니다. '
                '(품절된 상품이 포함되어 있습니다.)',
          ),
        ),
        'sold_out',
      );
      expect(
        analyticsReason(error('aborted', '(상품 가격이 변경되었습니다.)')),
        'price_changed',
      );
      expect(analyticsReason(error('aborted', '(적용할 수 없는 쿠폰입니다.)')), 'coupon');
      expect(
        analyticsReason(error('aborted', '(사용 포인트가 결제 금액을 벗어났습니다.)')),
        'points',
      );
    });

    test('분류에 없으면 오류 코드로 남긴다', () {
      expect(
        analyticsReason(error('unavailable', '서버에 닿지 못했습니다.')),
        'unavailable',
      );
      expect(analyticsReason(StateError('소켓 끊김')), 'unknown');
    });
  });

  group('Firebase가 없는 자리', () {
    test('아무것도 남기지 않고 조용히 지나간다', () async {
      // 테스트와 초기화 실패 상황이다. 여기서 던지면 주문이 멈춘다.
      const analytics = NoopAnalyticsService();

      await analytics.addToCart(itemId: 'bean-1', amount: 12000);
      await analytics.beginCheckout(amount: 12000, itemCount: 2);
      await analytics.purchase(orderType: 'bean', amount: 12000, itemCount: 2);
      await analytics.orderFailed(orderType: 'bean', reason: 'sold_out');
    });

    test('Firebase가 뜨지 않았으면 아무 일도 하지 않는 구현을 고른다', () {
      expect(createAnalyticsService(), isA<NoopAnalyticsService>());
    });
  });
}
