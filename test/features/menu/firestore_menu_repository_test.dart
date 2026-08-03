import 'package:cafe_app/features/menu/data/firestore_menu_repository.dart';
import 'package:cafe_app/features/menu/domain/menu_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('menuItemFromFirestore', () {
    test('Firestore 문서 데이터를 MenuItem으로 변환한다', () {
      final item = menuItemFromFirestore('menu-1', {
        'name': '플랫 화이트',
        'description': 'Flat White',
        'category': 'espresso',
        'price': 5500,
        'badge': 'hit',
        'servingOptions': ['HOT', 'ICED'],
        'detail': '리스트레토 샷에 마이크로폼을 더했습니다.',
        'isRecommended': true,
      });

      expect(item.id, 'menu-1');
      expect(item.name, '플랫 화이트');
      expect(item.category, MenuCategory.espresso);
      expect(item.price, 5500);
      expect(item.badge, MenuBadge.hit);
      expect(item.servingOptions, ['HOT', 'ICED']);
      expect(item.isRecommended, isTrue);
    });

    test('누락된 필드는 기본값으로 채운다', () {
      final item = menuItemFromFirestore('menu-2', {
        'name': '아메리카노',
        'category': 'espresso',
        'price': 5000,
      });

      expect(item.badge, MenuBadge.none);
      expect(item.priceFrom, isFalse);
      expect(item.servingOptions, isEmpty);
      expect(item.detail, isNull);
      expect(item.isRecommended, isFalse);
    });
  });
}
