import 'account_models.dart';

abstract class AccountRepository {
  Future<AccountProfile> load();

  Future<AccountProfile> registerBusiness(BusinessProfile business);

  Future<AccountProfile> switchToCustomer();

  Future<AccountProfile> switchToBusiness();

  Future<AccountProfile> saveBirthDate(DateTime birthDate);
}

DateTime normalizeBirthDate(DateTime birthDate) {
  return DateTime(birthDate.year, birthDate.month, birthDate.day);
}

bool isValidBusinessNumber(String value) {
  final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.length != 10) {
    return false;
  }
  const weights = [1, 3, 7, 1, 3, 7, 1, 3, 5];
  var sum = 0;
  for (var i = 0; i < 9; i++) {
    sum += int.parse(digits[i]) * weights[i];
  }
  sum += (int.parse(digits[8]) * 5) ~/ 10;
  return (10 - sum % 10) % 10 == int.parse(digits[9]);
}

String formatBusinessNumber(String value) {
  final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.length != 10) {
    return value.trim();
  }
  return '${digits.substring(0, 3)}-'
      '${digits.substring(3, 5)}-'
      '${digits.substring(5)}';
}

void validateBusinessProfile(BusinessProfile business) {
  if (business.companyName.trim().isEmpty) {
    throw ArgumentError.value(
      business.companyName,
      'companyName',
      'The company name is empty.',
    );
  }
  if (business.businessNumber.trim().isEmpty) {
    throw ArgumentError.value(
      business.businessNumber,
      'businessNumber',
      'The business number is empty.',
    );
  }
  if (!isValidBusinessNumber(business.businessNumber)) {
    throw ArgumentError.value(
      business.businessNumber,
      'businessNumber',
      'The business number is not valid.',
    );
  }
}

BusinessProfile normalizeBusinessProfile(BusinessProfile business) {
  return BusinessProfile(
    companyName: business.companyName.trim(),
    businessNumber: formatBusinessNumber(business.businessNumber),
    managerName: business.managerName.trim(),
    phone: business.phone.trim(),
  );
}
