import 'package:cafe_app/features/auth/domain/account_models.dart';
import 'package:cafe_app/features/auth/domain/account_repository.dart';

class FakeAccountRepository implements AccountRepository {
  AccountProfile profile;

  FakeAccountRepository({this.profile = const AccountProfile()});

  @override
  Future<AccountProfile> load() async => profile;

  @override
  Future<AccountProfile> registerBusiness(BusinessProfile business) async {
    validateBusinessProfile(business);
    profile = profile.copyWith(
      type: AccountType.business,
      business: normalizeBusinessProfile(business),
    );
    return profile;
  }

  @override
  Future<AccountProfile> switchToCustomer() async {
    profile = profile.copyWith(type: AccountType.customer);
    return profile;
  }

  @override
  Future<AccountProfile> switchToBusiness() async {
    if (profile.business == null) {
      throw StateError('저장된 사업자 정보가 없습니다.');
    }
    profile = profile.copyWith(type: AccountType.business);
    return profile;
  }

  @override
  Future<AccountProfile> saveBirthDate(DateTime birthDate) async {
    profile = profile.copyWith(birthDate: normalizeBirthDate(birthDate));
    return profile;
  }
}
