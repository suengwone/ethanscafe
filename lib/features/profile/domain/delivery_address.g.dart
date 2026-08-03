// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DeliveryAddress _$DeliveryAddressFromJson(Map<String, dynamic> json) =>
    _DeliveryAddress(
      id: json['id'] as String,
      label: json['label'] as String,
      recipient: json['recipient'] as String,
      phone: json['phone'] as String,
      address1: json['address1'] as String,
      address2: json['address2'] as String? ?? '',
      isDefault: json['isDefault'] as bool? ?? false,
    );

Map<String, dynamic> _$DeliveryAddressToJson(_DeliveryAddress instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'recipient': instance.recipient,
      'phone': instance.phone,
      'address1': instance.address1,
      'address2': instance.address2,
      'isDefault': instance.isDefault,
    };
