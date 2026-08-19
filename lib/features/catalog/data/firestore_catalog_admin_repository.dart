import 'package:cloud_firestore/cloud_firestore.dart';

import '../../beans/data/firestore_beans_repository.dart';
import '../../beans/domain/bean_models.dart';
import '../../home/data/firestore_banners_repository.dart';
import '../../home/domain/banner_models.dart';
import '../../menu/data/firestore_menu_repository.dart';
import '../../menu/domain/menu_models.dart';
import '../../store/data/firestore_stores_repository.dart';
import '../../store/domain/store_models.dart';
import '../domain/catalog_admin_repository.dart';

class FirestoreCatalogAdminRepository implements CatalogAdminRepository {
  FirestoreCatalogAdminRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  @override
  Future<void> saveMenuItem(MenuItem item) {
    return _save(
      FirestoreMenuRepository.collectionPath,
      item.id,
      menuItemToFirestore(item),
    );
  }

  @override
  Future<void> deleteMenuItem(String menuId) {
    return _delete(FirestoreMenuRepository.collectionPath, menuId);
  }

  @override
  Future<void> saveBean(Bean bean) {
    return _save(
      FirestoreBeansRepository.collectionPath,
      bean.id,
      beanToFirestore(bean),
    );
  }

  @override
  Future<void> deleteBean(String beanId) {
    return _delete(FirestoreBeansRepository.collectionPath, beanId);
  }

  @override
  Future<void> saveBanner(EventBanner banner) {
    return _save(
      FirestoreBannersRepository.collectionPath,
      banner.id,
      bannerToFirestore(banner),
    );
  }

  @override
  Future<void> deleteBanner(String bannerId) {
    return _delete(FirestoreBannersRepository.collectionPath, bannerId);
  }

  @override
  Future<void> saveStore(CafeStore store) {
    return _save(
      FirestoreStoresRepository.collectionPath,
      store.id,
      storeToFirestore(store),
    );
  }

  @override
  Future<void> deleteStore(String storeId) {
    return _delete(FirestoreStoresRepository.collectionPath, storeId);
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

  /// `id`가 비어 있으면 새 문서를 만든다. 기존 문서는 병합해 덮어써서
  /// 앱이 아직 모르는 필드는 그대로 둔다.
  Future<void> _save(String collection, String id, Map<String, dynamic> data) {
    final documents = _firestore.collection(collection);
    final doc = id.isEmpty ? documents.doc() : documents.doc(id);
    return doc.set(data, SetOptions(merge: true));
  }

  Future<void> _delete(String collection, String id) {
    return _firestore.collection(collection).doc(id).delete();
  }

  Future<void> _setSoldOut(String collection, String id, bool soldOut) {
    return _firestore
        .collection(collection)
        .doc(id)
        .set({'soldOut': soldOut}, SetOptions(merge: true));
  }
}
