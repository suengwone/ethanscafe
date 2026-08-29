import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cafe_app/features/menu/data/local_favorites_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('처음에는 즐겨찾기가 비어있다', () async {
    final repository = LocalFavoritesRepository();

    expect(await repository.loadFavorites(), isEmpty);
  });

  test('토글하면 즐겨찾기에 추가된다', () async {
    final repository = LocalFavoritesRepository();

    final favorites = await repository.toggleFavorite('espresso-americano');

    expect(favorites, {'espresso-americano'});
    expect(await repository.loadFavorites(), {'espresso-americano'});
  });

  test('이미 즐겨찾기된 메뉴를 토글하면 해제된다', () async {
    final repository = LocalFavoritesRepository();
    await repository.toggleFavorite('espresso-americano');

    final favorites = await repository.toggleFavorite('espresso-americano');

    expect(favorites, isEmpty);
    expect(await repository.loadFavorites(), isEmpty);
  });

  test('여러 메뉴를 즐겨찾기하면 모두 저장된다', () async {
    final repository = LocalFavoritesRepository();

    await repository.toggleFavorite('espresso-americano');
    await repository.toggleFavorite('tea-chamomile');

    expect(await repository.loadFavorites(), {
      'espresso-americano',
      'tea-chamomile',
    });
  });
}
