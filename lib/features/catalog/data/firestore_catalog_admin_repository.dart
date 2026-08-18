import 'package:cloud_firestore/cloud_firestore.dart';

import '../../beans/data/firestore_beans_repository.dart';
import '../../beans/domain/bean_models.dart';
import '../../menu/data/firestore_menu_repository.dart';
import '../../menu/domain/menu_models.dart';
import '../domain/catalog_admin_repository.dart';

class FirestoreCatalogAdminRepository implements CatalogAdminRepository {
  FirestoreCatalogAdminRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  @override
  Future<void> saveMenuItem(MenuItem item) async {
    final menus = _firestore.collection(FirestoreMenuRepository.collectionPath);
    final doc = item.id.isEmpty ? menus.doc() : menus.doc(item.id);
    await doc.set(menuItemToFirestore(item), SetOptions(merge: true));
  }

  @override
  Future<void> deleteMenuItem(String menuId) {
    return _firestore
        .collection(FirestoreMenuRepository.collectionPath)
        .doc(menuId)
        .delete();
  }

  @override
  Future<void> saveBean(Bean bean) async {
    final beans = _firestore.collection(FirestoreBeansRepository.collectionPath);
    final doc = bean.id.isEmpty ? beans.doc() : beans.doc(bean.id);
    await doc.set(beanToFirestore(bean), SetOptions(merge: true));
  }

  @override
  Future<void> deleteBean(String beanId) {
    return _firestore
        .collection(FirestoreBeansRepository.collectionPath)
        .doc(beanId)
        .delete();
  }

  @override
  Future<void> setMenuSoldOut({
    required String menuId,
    required bool soldOut,
  }) {
    return _setSoldOut(
      FirestoreMenuRepository.collectionPath,
      menuId,
      soldOut,
    );
  }

  @override
  Future<void> setBeanSoldOut({
    required String beanId,
    required bool soldOut,
  }) {
    return _setSoldOut(
      FirestoreBeansRepository.collectionPath,
      beanId,
      soldOut,
    );
  }

  Future<void> _setSoldOut(String collection, String id, bool soldOut) {
    return _firestore
        .collection(collection)
        .doc(id)
        .set({'soldOut': soldOut}, SetOptions(merge: true));
  }
}
