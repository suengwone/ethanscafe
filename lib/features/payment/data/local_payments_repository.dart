import '../domain/payment_models.dart';
import '../domain/payments_repository.dart';

class LocalPaymentsRepository implements PaymentsRepository {
  static const simulatedMethod = '카드';

  @override
  Future<PaymentApproval> confirmPayment({
    required String paymentKey,
    required String orderId,
    required int amount,
  }) async {
    if (amount <= 0) {
      throw ArgumentError.value(amount, 'amount', '결제 금액이 올바르지 않습니다.');
    }
    return PaymentApproval(
      paymentKey: paymentKey,
      orderId: orderId,
      amount: amount,
      method: simulatedMethod,
    );
  }
}
