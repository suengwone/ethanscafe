/// 취소된 주문의 결제 환불 진행 상태. 서버(`functions/order_cancel.js`)가 기록한다.
///
/// 포인트·쿠폰으로만 치른 주문은 환불할 결제가 없어 값이 비어 있다.
enum RefundStatus {
  /// 환불을 걸었고 결과를 아직 확인하지 못했다.
  pending('환불 처리 중'),

  /// 환불이 끝났다.
  done('환불 완료'),

  /// 환불이 실패해 매장이 다시 시도해야 한다.
  failed('환불 확인 중');

  const RefundStatus(this.label);

  final String label;

  static RefundStatus? parse(Object? value) =>
      RefundStatus.values.asNameMap()[value];
}

/// 취소된 주문에 붙일 문구. 환불이 아직 끝나지 않았으면 그 상태를 대신 보여준다.
///
/// 결제 없이 포인트·쿠폰으로만 치른 주문은 환불 상태가 없어 그대로 '주문 취소'다.
String refundLabelFor(String cancelledLabel, RefundStatus? refund) {
  if (refund == null || refund == RefundStatus.done) {
    return cancelledLabel;
  }
  return refund.label;
}
