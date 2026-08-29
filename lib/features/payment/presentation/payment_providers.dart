import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/presentation/auth_providers.dart';
import '../data/cloud_functions_payments_repository.dart';
import '../data/local_payments_repository.dart';
import '../domain/payment_models.dart';
import '../domain/payments_repository.dart';
import 'toss_payment_screen.dart';

abstract class PaymentGateway {
  Future<PaymentApproval?> pay(BuildContext context, PaymentRequest request);
}

class TossPaymentGateway implements PaymentGateway {
  TossPaymentGateway({required this.repository});

  final PaymentsRepository repository;

  @override
  Future<PaymentApproval?> pay(BuildContext context, PaymentRequest request) {
    return Navigator.of(context, rootNavigator: true).push<PaymentApproval>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) =>
            TossPaymentScreen(request: request, repository: repository),
      ),
    );
  }
}

class LocalPaymentGateway implements PaymentGateway {
  LocalPaymentGateway({PaymentsRepository? repository})
    : repository = repository ?? LocalPaymentsRepository();

  final PaymentsRepository repository;

  @override
  Future<PaymentApproval?> pay(BuildContext context, PaymentRequest request) {
    return repository.confirmPayment(
      paymentKey: 'local-${request.orderId}',
      orderId: request.orderId,
      amount: request.amount,
    );
  }
}

final paymentsRepositoryProvider = Provider<PaymentsRepository>((ref) {
  try {
    if (Firebase.apps.isNotEmpty &&
        ref.watch(authStateProvider).value != null) {
      return CloudFunctionsPaymentsRepository();
    }
  } catch (_) {}
  return LocalPaymentsRepository();
});

final paymentGatewayProvider = Provider<PaymentGateway>((ref) {
  final repository = ref.watch(paymentsRepositoryProvider);
  if (repository is CloudFunctionsPaymentsRepository) {
    return TossPaymentGateway(repository: repository);
  }
  return LocalPaymentGateway(repository: repository);
});
