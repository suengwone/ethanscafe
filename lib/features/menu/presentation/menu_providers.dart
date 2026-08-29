import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/presentation/auth_providers.dart';
import '../data/firestore_favorites_repository.dart';
import '../data/firestore_menu_repository.dart';
import '../data/local_favorites_repository.dart';
import '../data/local_menu_repository.dart';
import '../domain/favorites_repository.dart';
import '../domain/menu_models.dart';
import '../domain/menu_repository.dart';

final menuRepositoryProvider = Provider<MenuRepository>((ref) {
  try {
    if (Firebase.apps.isNotEmpty) {
      return FirestoreMenuRepository();
    }
  } catch (_) {}
  return LocalMenuRepository();
});

final menuItemsProvider = FutureProvider<List<MenuItem>>((ref) {
  return ref.watch(menuRepositoryProvider).loadMenuItems();
});

final menuItemsByCategoryProvider =
    FutureProvider.family<List<MenuItem>, MenuCategory>((ref, category) async {
      final items = await ref.watch(menuItemsProvider.future);
      return items.where((item) => item.category == category).toList();
    });

final menuItemProvider = FutureProvider.family<MenuItem, String>((
  ref,
  menuId,
) async {
  final items = await ref.watch(menuItemsProvider.future);
  return items.firstWhere(
    (item) => item.id == menuId,
    orElse: () => throw StateError('Menu item not found: $menuId'),
  );
});

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  try {
    if (Firebase.apps.isNotEmpty) {
      final user = ref.watch(authStateProvider).value;
      if (user != null) {
        return FirestoreFavoritesRepository(uid: user.uid);
      }
    }
  } catch (_) {}
  return LocalFavoritesRepository();
});

final favoritesProvider =
    AsyncNotifierProvider<FavoritesController, Set<String>>(
      FavoritesController.new,
    );

class FavoritesController extends AsyncNotifier<Set<String>> {
  @override
  Future<Set<String>> build() {
    return ref.watch(favoritesRepositoryProvider).loadFavorites();
  }

  Future<void> toggle(String menuId) async {
    final repository = ref.read(favoritesRepositoryProvider);
    state = await AsyncValue.guard(() => repository.toggleFavorite(menuId));
  }
}

final favoriteMenuItemsProvider = FutureProvider<List<MenuItem>>((ref) async {
  final items = await ref.watch(menuItemsProvider.future);
  final favorites = await ref.watch(favoritesProvider.future);
  return items.where((item) => favorites.contains(item.id)).toList();
});
