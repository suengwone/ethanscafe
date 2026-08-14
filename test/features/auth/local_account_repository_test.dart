import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cafe_app/features/auth/data/local_account_repository.dart';
import 'package:cafe_app/features/auth/domain/account_models.dart';

void main() {
  late LocalAccountRepository repository;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repository = LocalAccountRepository();
  });

  test('최초 로드 시 일반 고객 계정을 반환한다', () async {
    final profile = await repository.load();

    expect(profile.type, AccountType.customer);
    expect(profile.isBusiness, isFalse);
    expect(profile.business, isNull);
  });

  test('사업자 등록 시 사업자 계정으로 전환되고 영속화된다', () async {
    final profile = await repository.registerBusiness(
      const BusinessProfile(
        companyName: ' 카페 어라운드 ',
        businessNumber: ' 123-45-67890 ',
        managerName: '김사장',
        phone: '010-1234-5678',
      ),
    );

    expect(profile.isBusiness, isTrue);
    expect(profile.business?.companyName, '카페 어라운드');
    expect(profile.business?.businessNumber, '123-45-67890');

    final reloaded = await LocalAccountRepository().load();
    expect(reloaded.type, AccountType.business);
    expect(reloaded.business?.companyName, '카페 어라운드');
  });

  test('상호명이 없으면 사업자 등록에 실패한다', () async {
    expect(
      () => repository.registerBusiness(
        const BusinessProfile(companyName: '  ', businessNumber: '123'),
      ),
      throwsArgumentError,
    );
  });

  test('사업자등록번호가 없으면 사업자 등록에 실패한다', () async {
    expect(
      () => repository.registerBusiness(
        const BusinessProfile(companyName: '카페', businessNumber: ''),
      ),
      throwsArgumentError,
    );
  });

  test('일반 고객으로 다시 전환할 수 있다', () async {
    await repository.registerBusiness(
      const BusinessProfile(companyName: '카페', businessNumber: '123'),
    );

    final profile = await repository.switchToCustomer();

    expect(profile.type, AccountType.customer);
    expect(profile.business, isNull);

    final reloaded = await LocalAccountRepository().load();
    expect(reloaded.isBusiness, isFalse);
  });
}
