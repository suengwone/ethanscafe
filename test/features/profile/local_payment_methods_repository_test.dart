import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cafe_app/features/profile/data/local_payment_methods_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('저장된 값이 없으면 기본 카드 목록을 시드한다', () async {
    final repository = LocalPaymentMethodsRepository();

    final cards = await repository.load();

    expect(cards, hasLength(2));
    expect(cards.first.isDefault, isTrue);
    expect(cards.where((card) => card.isDefault), hasLength(1));
  });

  test('카드를 추가하면 목록 끝에 저장된다', () async {
    final repository = LocalPaymentMethodsRepository();

    final updated = await repository.addCard(brand: '국민카드', last4: '9012');

    expect(updated, hasLength(3));
    expect(updated.last.brand, '국민카드');
    expect(updated.last.last4, '9012');
    expect(updated.last.isDefault, isFalse);

    final reloaded = await repository.load();
    expect(reloaded, hasLength(3));
  });

  test('기본 카드를 삭제하면 남은 첫 카드가 기본이 된다', () async {
    final repository = LocalPaymentMethodsRepository();
    final cards = await repository.load();
    final defaultCard = cards.firstWhere((card) => card.isDefault);

    final updated = await repository.removeCard(defaultCard.id);

    expect(updated, hasLength(1));
    expect(updated.first.isDefault, isTrue);
  });

  test('기본 카드를 변경할 수 있다', () async {
    final repository = LocalPaymentMethodsRepository();
    final cards = await repository.load();
    final nonDefault = cards.firstWhere((card) => !card.isDefault);

    final updated = await repository.setDefaultCard(nonDefault.id);

    expect(
      updated.firstWhere((card) => card.id == nonDefault.id).isDefault,
      isTrue,
    );
    expect(updated.where((card) => card.isDefault), hasLength(1));
  });

  test('모든 카드를 삭제하면 빈 목록이 유지된다', () async {
    final repository = LocalPaymentMethodsRepository();
    final cards = await repository.load();

    for (final card in cards) {
      await repository.removeCard(card.id);
    }

    final reloaded = await repository.load();
    expect(reloaded, isEmpty);
  });
}
