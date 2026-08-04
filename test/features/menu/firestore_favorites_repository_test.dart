import 'package:cafe_app/features/menu/data/firestore_favorites_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('favoritesFromFirestore', () {
    test('menuIds 배열을 Set으로 변환한다', () {
      final favorites = favoritesFromFirestore({
        'menuIds': ['americano', 'latte'],
      });

      expect(favorites, {'americano', 'latte'});
    });

    test('데이터가 없으면 빈 Set을 반환한다', () {
      expect(favoritesFromFirestore(null), isEmpty);
      expect(favoritesFromFirestore({}), isEmpty);
    });
  });

  group('favoritesToFirestore', () {
    test('menuIds를 정렬된 배열로 직렬화한다', () {
      final map = favoritesToFirestore({'latte', 'americano'});

      expect(map['menuIds'], ['americano', 'latte']);
    });

    test('round trip 시 데이터가 보존된다', () {
      final original = {'americano', 'latte', 'mocha'};

      final restored =
          favoritesFromFirestore(favoritesToFirestore(original));

      expect(restored, original);
    });
  });
}
