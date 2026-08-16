import 'package:cloud_functions/cloud_functions.dart';

import '../../payment/domain/payment_models.dart';
import '../../payment/domain/payments_repository.dart';

class CloudFunctionsPointsChargeRepository implements PaymentsRepository {
  CloudFunctionsPointsChargeRepository({FirebaseFunctions? functions})
      : _functions =
            functions ?? FirebaseFunctions.instanceFor(region: _region);

  static const _region = 'asia-northeast3';
  static const chargeCallableName = 'chargePoints';

  final FirebaseFunctions _functions;

  @override
  Future<PaymentApproval> confirmPayment({
    required String paymentKey,
    required String orderId,
    required int amount,
  }) async {
    final result = await _functions.httpsCallable(chargeCallableName).call({
      'paymentKey': paymentKey,
      'orderId': orderId,
      'amount': amount,
    });
    final data = Map<String, dynamic>.from(result.data as Map);
    return PaymentApproval(
      paymentKey: data['paymentKey'] as String? ?? paymentKey,
      orderId: data['orderId'] as String? ?? orderId,
      amount: (data['amount'] as num? ?? amount).toInt(),
      method: data['method'] as String? ?? '카드',
    );
  }
}
