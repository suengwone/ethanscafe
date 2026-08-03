abstract class FavoritesRepository {
  Future<Set<String>> loadFavorites();

  Future<Set<String>> toggleFavorite(String menuId);
}
