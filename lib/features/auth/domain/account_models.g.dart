// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BusinessProfile _$BusinessProfileFromJson(Map<String, dynamic> json) =>
    _BusinessProfile(
      companyName: json['companyName'] as String,
      businessNumber: json['businessNumber'] as String,
      managerName: json['managerName'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
    );

Map<String, dynamic> _$BusinessProfileToJson(_BusinessProfile instance) =>
    <String, dynamic>{
      'companyName': instance.companyName,
      'businessNumber': instance.businessNumber,
      'managerName': instance.managerName,
      'phone': instance.phone,
    };

_AccountProfile _$AccountProfileFromJson(Map<String, dynamic> json) =>
    _AccountProfile(
      type:
          $enumDecodeNullable(_$AccountTypeEnumMap, json['type']) ??
          AccountType.customer,
      business: json['business'] == null
          ? null
          : BusinessProfile.fromJson(json['business'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AccountProfileToJson(_AccountProfile instance) =>
    <String, dynamic>{
      'type': _$AccountTypeEnumMap[instance.type]!,
      'business': instance.business,
    };

const _$AccountTypeEnumMap = {
  AccountType.customer: 'customer',
  AccountType.business: 'business',
};
