import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_models.freezed.dart';
part 'account_models.g.dart';

enum AccountType {
  customer('일반 고객'),
  business('사업자');

  const AccountType(this.label);

  final String label;
}

@freezed
abstract class BusinessProfile with _$BusinessProfile {
  const factory BusinessProfile({
    required String companyName,
    required String businessNumber,
    @Default('') String managerName,
    @Default('') String phone,
  }) = _BusinessProfile;

  factory BusinessProfile.fromJson(Map<String, dynamic> json) =>
      _$BusinessProfileFromJson(json);
}

@freezed
abstract class AccountProfile with _$AccountProfile {
  const AccountProfile._();

  const factory AccountProfile({
    @Default(AccountType.customer) AccountType type,
    BusinessProfile? business,
  }) = _AccountProfile;

  factory AccountProfile.fromJson(Map<String, dynamic> json) =>
      _$AccountProfileFromJson(json);

  bool get isBusiness => type == AccountType.business;
}
