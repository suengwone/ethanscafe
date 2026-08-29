import 'package:cloud_functions/cloud_functions.dart';

import '../domain/payment_models.dart';
import '../domain/payments_repository.dart';

class CloudFunctionsPaymentsRepository implements PaymentsRepository {
  CloudFunctionsPaymentsRepository({FirebaseFunctions? functions})
    : _functions = functions ?? FirebaseFunctions.instanceFor(region: _region);

  static const _region = 'asia-northeast3';
  static const confirmCallableName = 'confirmTossPayment';

  final FirebaseFunctions _functions;

  @override
  Future<PaymentApproval> confirmPayment({
    required String paymentKey,
    required String orderId,
    required int amount,
  }) async {
    final result = await _functions.httpsCallable(confirmCallableName).call({
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
