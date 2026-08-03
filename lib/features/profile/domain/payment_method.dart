import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_method.freezed.dart';
part 'payment_method.g.dart';

@freezed
abstract class PaymentMethod with _$PaymentMethod {
  const factory PaymentMethod({
    required String id,
    required String brand,
    required String last4,
    @Default(false) bool isDefault,
  }) = _PaymentMethod;

  factory PaymentMethod.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodFromJson(json);
}

abstract class PaymentMethodsRepository {
  Future<List<PaymentMethod>> load();

  Future<List<PaymentMethod>> addCard({
    required String brand,
    required String last4,
  });

  Future<List<PaymentMethod>> removeCard(String id);

  Future<List<PaymentMethod>> setDefaultCard(String id);
}
