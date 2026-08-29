import 'package:flutter_test/flutter_test.dart';

import 'package:cafe_app/features/order/domain/refund_status.dart';

void main() {
  group('환불 상태 파싱', () {
    test('서버가 쓰는 문자열을 그대로 읽는다', () {
      expect(RefundStatus.parse('pending'), RefundStatus.pending);
      expect(RefundStatus.parse('done'), RefundStatus.done);
      expect(RefundStatus.parse('failed'), RefundStatus.failed);
    });

    test('값이 없거나 모르는 값이면 비워둔다', () {
      expect(RefundStatus.parse(null), isNull);
      expect(RefundStatus.parse(''), isNull);
      expect(RefundStatus.parse('refunded'), isNull);
      expect(RefundStatus.parse(3), isNull);
    });
  });

  group('취소 주문 문구', () {
    test('환불이 끝났거나 환불할 결제가 없으면 취소 문구를 쓴다', () {
      expect(refundLabelFor('주문 취소', null, _label), '주문 취소');
      expect(refundLabelFor('주문 취소', RefundStatus.done, _label), '주문 취소');
    });

    test('환불이 남아 있으면 진행 상태를 대신 보여준다', () {
      expect(
        refundLabelFor('주문 취소', RefundStatus.pending, _label),
        '환불 처리 중',
      );
      expect(
        refundLabelFor('주문 취소', RefundStatus.failed, _label),
        '환불 확인 중',
      );
    });
  });
}

/// 화면이 l10n에서 꺼내 주는 것과 같은 한국어 문구. 여기서는 규칙만 본다.
String _label(RefundStatus status) => switch (status) {
  RefundStatus.pending => '환불 처리 중',
  RefundStatus.done => '환불 완료',
  RefundStatus.failed => '환불 확인 중',
};
