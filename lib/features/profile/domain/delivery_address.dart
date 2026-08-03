import 'package:freezed_annotation/freezed_annotation.dart';

part 'delivery_address.freezed.dart';
part 'delivery_address.g.dart';

@freezed
abstract class DeliveryAddress with _$DeliveryAddress {
  const factory DeliveryAddress({
    required String id,
    required String label,
    required String recipient,
    required String phone,
    required String address1,
    @Default('') String address2,
    @Default(false) bool isDefault,
  }) = _DeliveryAddress;

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) =>
      _$DeliveryAddressFromJson(json);
}

abstract class DeliveryAddressesRepository {
  Future<List<DeliveryAddress>> load();

  Future<List<DeliveryAddress>> addAddress({
    required String label,
    required String recipient,
    required String phone,
    required String address1,
    String address2 = '',
  });

  Future<List<DeliveryAddress>> removeAddress(String id);

  Future<List<DeliveryAddress>> setDefaultAddress(String id);
}
