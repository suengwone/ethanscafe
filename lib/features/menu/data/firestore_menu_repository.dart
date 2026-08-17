import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/menu_models.dart';
import '../domain/menu_repository.dart';

class FirestoreMenuRepository implements MenuRepository {
  FirestoreMenuRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static const collectionPath = 'menus';

  @override
  Future<List<MenuItem>> loadMenuItems() async {
    final snapshot = await _firestore
        .collection(collectionPath)
        .orderBy('sortOrder')
        .get();
    return snapshot.docs
        .map((doc) => menuItemFromFirestore(doc.id, doc.data()))
        .toList();
  }
}

MenuItem menuItemFromFirestore(String id, Map<String, dynamic> data) {
  return MenuItem(
    id: id,
    name: data['name'] as String? ?? '',
    description: data['description'] as String? ?? '',
    category: MenuCategory.values.asNameMap()[data['category']] ??
        MenuCategory.beverage,
    price: (data['price'] as num? ?? 0).toInt(),
    priceFrom: data['priceFrom'] as bool? ?? false,
    badge: MenuBadge.values.asNameMap()[data['badge']] ?? MenuBadge.none,
    servingOptions:
        (data['servingOptions'] as List<dynamic>? ?? const []).cast<String>(),
    detail: data['detail'] as String?,
    isRecommended: data['isRecommended'] as bool? ?? false,
    soldOut: data['soldOut'] as bool? ?? false,
  );
}
