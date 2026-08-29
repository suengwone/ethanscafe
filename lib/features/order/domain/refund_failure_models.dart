/// 취소는 됐지만 결제 환불만 실패한 주문.
/// 고객 돈이 묶여 있는 상태라 매장이 확인하고 다시 시도해야 한다.
class RefundFailure {
  const RefundFailure({
    required this.orderType,
    required this.uid,
    required this.orderId,
    required this.summary,
    required this.amount,
    required this.failedAt,
  });

  /// `'pickup'` 또는 `'bean'`. 서버 콜러블에 그대로 넘긴다.
  final String orderType;
  final String uid;
  final String orderId;
  final String summary;
  final int amount;
  final DateTime failedAt;
}
