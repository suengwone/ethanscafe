import 'account_models.dart';

abstract class AccountRepository {
  Future<AccountProfile> load();

  Future<AccountProfile> registerBusiness(BusinessProfile business);

  Future<AccountProfile> switchToCustomer();
}

void validateBusinessProfile(BusinessProfile business) {
  if (business.companyName.trim().isEmpty) {
    throw ArgumentError.value(
      business.companyName,
      'companyName',
      '상호명이 비어 있습니다.',
    );
  }
  if (business.businessNumber.trim().isEmpty) {
    throw ArgumentError.value(
      business.businessNumber,
      'businessNumber',
      '사업자등록번호가 비어 있습니다.',
    );
  }
}

BusinessProfile normalizeBusinessProfile(BusinessProfile business) {
  return BusinessProfile(
    companyName: business.companyName.trim(),
    businessNumber: business.businessNumber.trim(),
    managerName: business.managerName.trim(),
    phone: business.phone.trim(),
  );
}
