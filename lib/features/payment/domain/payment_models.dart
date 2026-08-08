import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_models.freezed.dart';

@freezed
abstract class PaymentRequest with _$PaymentRequest {
  const factory PaymentRequest({
    required String orderId,
    required String orderName,
    required int amount,
  }) = _PaymentRequest;
}

@freezed
abstract class PaymentApproval with _$PaymentApproval {
  const factory PaymentApproval({
    required String paymentKey,
    required String orderId,
    required int amount,
    required String method,
  }) = _PaymentApproval;
}

String generatePaymentOrderId() =>
    'bean-${DateTime.now().millisecondsSinceEpoch}-'
    '${Random().nextInt(0xFFFF).toRadixString(16).padLeft(4, '0')}';
