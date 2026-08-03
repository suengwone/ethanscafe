import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cafe_app/features/profile/data/local_delivery_addresses_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('저장된 값이 없으면 기본 배송지를 시드한다', () async {
    final repository = LocalDeliveryAddressesRepository();

    final addresses = await repository.load();

    expect(addresses, hasLength(1));
    expect(addresses.first.label, '집');
    expect(addresses.first.isDefault, isTrue);
  });

  test('배송지를 추가하면 목록 끝에 저장된다', () async {
    final repository = LocalDeliveryAddressesRepository();

    final updated = await repository.addAddress(
      label: '회사',
      recipient: '이단',
      phone: '010-9876-5432',
      address1: '서울 강남구 테헤란로 123',
      address2: '10층',
    );

    expect(updated, hasLength(2));
    expect(updated.last.label, '회사');
    expect(updated.last.isDefault, isFalse);

    final reloaded = await repository.load();
    expect(reloaded, hasLength(2));
  });

  test('기본 배송지를 삭제하면 남은 첫 배송지가 기본이 된다', () async {
    final repository = LocalDeliveryAddressesRepository();
    await repository.addAddress(
      label: '회사',
      recipient: '이단',
      phone: '010-9876-5432',
      address1: '서울 강남구 테헤란로 123',
    );
    final addresses = await repository.load();
    final defaultAddress = addresses.firstWhere((a) => a.isDefault);

    final updated = await repository.removeAddress(defaultAddress.id);

    expect(updated, hasLength(1));
    expect(updated.first.isDefault, isTrue);
    expect(updated.first.label, '회사');
  });

  test('기본 배송지를 변경할 수 있다', () async {
    final repository = LocalDeliveryAddressesRepository();
    final updated = await repository.addAddress(
      label: '회사',
      recipient: '이단',
      phone: '010-9876-5432',
      address1: '서울 강남구 테헤란로 123',
    );
    final added = updated.last;

    final result = await repository.setDefaultAddress(added.id);

    expect(
      result.firstWhere((address) => address.id == added.id).isDefault,
      isTrue,
    );
    expect(result.where((address) => address.isDefault), hasLength(1));
  });
}
