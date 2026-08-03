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
        reason: '${category.label} 카테고리가 비어있습니다.',
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
    final americano =
        items.firstWhere((item) => item.id == 'espresso-americano');
    final affogato =
        items.firstWhere((item) => item.id == 'espresso-haagen-dazs-affogato');

    expect(americano.priceLabel, '5,000원');
    expect(affogato.priceLabel, '6,800원~');
  });
}
