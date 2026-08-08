import 'payment_models.dart';

abstract class PaymentsRepository {
  Future<PaymentApproval> confirmPayment({
    required String paymentKey,
    required String orderId,
    required int amount,
  });
}
