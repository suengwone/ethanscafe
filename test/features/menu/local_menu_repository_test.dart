import 'package:flutter_test/flutter_test.dart';

import 'package:cafe_app/features/menu/data/local_menu_repository.dart';
import 'package:cafe_app/features/menu/domain/menu_models.dart';

void main() {
  final repository = LocalMenuRepository();

  test('모든 카테고리에 메뉴가 존재한다', () async {
    final items = await repository.loadMenuItems();

    for (final category in MenuCategory.values) {
      expect(
        items.where((item) => item.category == category),
        isNotEmpty,
        reason: '${category.name} 카테고리가 비어있습니다.',
      );
    }
  });

  test('메뉴 id는 중복되지 않는다', () async {
    final items = await repository.loadMenuItems();
    final ids = items.map((item) => item.id).toSet();

    expect(ids.length, items.length);
  });

  test('가격 라벨이 천 단위 구분과 원 단위를 포함한다', () async {
    final items = await repository.loadMenuItems();
    final americano = items.firstWhere(
      (item) => item.id == 'espresso-americano',
    );
    final affogato = items.firstWhere(
      (item) => item.id == 'espresso-haagen-dazs-affogato',
    );

    // 통화 표기는 화면이 붙인다. 모델은 숫자 서식까지만 책임진다.
    expect(americano.formattedPrice, '5,000');
    expect(affogato.formattedPrice, '6,800');
    expect(affogato.priceFrom, isTrue);
  });
}
