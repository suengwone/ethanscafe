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
        businessNumber: ' 2208162517 ',
        managerName: '김사장',
        phone: '010-1234-5678',
      ),
    );

    expect(profile.isBusiness, isTrue);
    expect(profile.business?.companyName, '카페 어라운드');
    expect(profile.business?.businessNumber, '220-81-62517');

    final reloaded = await LocalAccountRepository().load();
    expect(reloaded.type, AccountType.business);
    expect(reloaded.business?.companyName, '카페 어라운드');
  });

  test('상호명이 없으면 사업자 등록에 실패한다', () async {
    expect(
      () => repository.registerBusiness(
        const BusinessProfile(
          companyName: '  ',
          businessNumber: '220-81-62517',
        ),
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

  test('체크섬이 틀린 사업자등록번호는 등록에 실패한다', () async {
    expect(
      () => repository.registerBusiness(
        const BusinessProfile(
          companyName: '카페',
          businessNumber: '123-45-67890',
        ),
      ),
      throwsArgumentError,
    );
  });

  test('일반 고객으로 전환해도 사업자 정보는 보존된다', () async {
    await repository.registerBusiness(
      const BusinessProfile(
        companyName: '카페',
        businessNumber: '220-81-62517',
      ),
    );

    final profile = await repository.switchToCustomer();

    expect(profile.type, AccountType.customer);
    expect(profile.business?.companyName, '카페');

    final reloaded = await LocalAccountRepository().load();
    expect(reloaded.isBusiness, isFalse);
    expect(reloaded.business?.businessNumber, '220-81-62517');
  });

  test('저장된 사업자 정보로 재입력 없이 다시 전환할 수 있다', () async {
    await repository.registerBusiness(
      const BusinessProfile(
        companyName: '카페',
        businessNumber: '220-81-62517',
      ),
    );
    await repository.switchToCustomer();

    final profile = await repository.switchToBusiness();

    expect(profile.type, AccountType.business);
    expect(profile.business?.businessNumber, '220-81-62517');

    final reloaded = await LocalAccountRepository().load();
    expect(reloaded.isBusiness, isTrue);
  });

  test('저장된 사업자 정보가 없으면 사업자 전환에 실패한다', () async {
    expect(repository.switchToBusiness, throwsStateError);
  });

  test('생일을 저장하면 시간이 제거된 날짜로 영속화된다', () async {
    final profile =
        await repository.saveBirthDate(DateTime(1994, 8, 14, 10, 30));

    expect(profile.birthDate, DateTime(1994, 8, 14));

    final reloaded = await LocalAccountRepository().load();
    expect(reloaded.birthDate, DateTime(1994, 8, 14));
  });

  test('사업자 등록·전환 후에도 생일은 유지된다', () async {
    await repository.saveBirthDate(DateTime(1994, 8, 14));

    final registered = await repository.registerBusiness(
      const BusinessProfile(
        companyName: '카페',
        businessNumber: '220-81-62517',
      ),
    );
    expect(registered.birthDate, DateTime(1994, 8, 14));

    final switched = await repository.switchToCustomer();
    expect(switched.birthDate, DateTime(1994, 8, 14));

    final reloaded = await LocalAccountRepository().load();
    expect(reloaded.birthDate, DateTime(1994, 8, 14));
  });
}
