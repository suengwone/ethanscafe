import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/favorites_repository.dart';

class FirestoreFavoritesRepository implements FavoritesRepository {
  FirestoreFavoritesRepository({
    required this.uid,
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final String uid;
  final FirebaseFirestore _firestore;

  static const collectionPath = 'favorites';

  DocumentReference<Map<String, dynamic>> get _doc =>
      _firestore.collection(collectionPath).doc(uid);

  @override
  Future<Set<String>> loadFavorites() async {
    final snapshot = await _doc.get();
    return favoritesFromFirestore(snapshot.data());
  }

  @override
  Future<Set<String>> toggleFavorite(String menuId) {
    return _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(_doc);
      final favorites = favoritesFromFirestore(snapshot.data());
      if (!favorites.remove(menuId)) {
        favorites.add(menuId);
      }
      transaction.set(_doc, favoritesToFirestore(favorites));
      return favorites;
    });
  }
}

Set<String> favoritesFromFirestore(Map<String, dynamic>? data) {
  return ((data?['menuIds'] as List<dynamic>?) ?? const [])
      .map((id) => id as String)
      .toSet();
}

Map<String, dynamic> favoritesToFirestore(Set<String> favorites) {
  return {'menuIds': favorites.toList()..sort()};
}
