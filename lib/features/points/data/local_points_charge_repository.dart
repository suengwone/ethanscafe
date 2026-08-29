import '../../payment/domain/payment_models.dart';
import '../../payment/domain/payments_repository.dart';
import '../domain/charge_plans.dart';
import 'local_points_repository.dart';

class LocalPointsChargeRepository implements PaymentsRepository {
  LocalPointsChargeRepository({LocalPointsRepository? pointsRepository})
    : _pointsRepository = pointsRepository ?? LocalPointsRepository();

  static const simulatedMethod = '카드';

  final LocalPointsRepository _pointsRepository;

  @override
  Future<PaymentApproval> confirmPayment({
    required String paymentKey,
    required String orderId,
    required int amount,
  }) async {
    final plan = chargePlanOf(amount);
    if (plan == null) {
      throw ArgumentError.value(amount, 'amount', '충전 금액이 올바르지 않습니다.');
    }
    await _pointsRepository.charge(
      paymentAmount: plan.amount,
      bonus: plan.bonus,
      paymentKey: paymentKey,
    );
    return PaymentApproval(
      paymentKey: paymentKey,
      orderId: orderId,
      amount: amount,
      method: simulatedMethod,
    );
  }
}
