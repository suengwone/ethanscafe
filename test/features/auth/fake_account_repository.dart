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
    profile = AccountProfile(birthDate: profile.birthDate);
    return profile;
  }

  @override
  Future<AccountProfile> saveBirthDate(DateTime birthDate) async {
    profile = profile.copyWith(birthDate: normalizeBirthDate(birthDate));
    return profile;
  }
}
