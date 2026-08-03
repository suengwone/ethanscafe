import 'package:shared_preferences/shared_preferences.dart';

import '../domain/favorites_repository.dart';

class LocalFavoritesRepository implements FavoritesRepository {
  static const _storageKey = 'favorite_menu_ids';

  @override
  Future<Set<String>> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_storageKey) ?? const []).toSet();
  }

  @override
  Future<Set<String>> toggleFavorite(String menuId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = (prefs.getStringList(_storageKey) ?? const []).toSet();
    if (!favorites.remove(menuId)) {
      favorites.add(menuId);
    }
    await prefs.setStringList(_storageKey, favorites.toList()..sort());
    return favorites;
  }
}
