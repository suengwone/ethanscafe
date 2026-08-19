import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../beans/domain/bean_models.dart';
import '../../beans/presentation/beans_providers.dart';
import '../../home/domain/banner_models.dart';
import '../../home/presentation/home_providers.dart';
import '../../menu/domain/menu_models.dart';
import '../../menu/presentation/menu_providers.dart';
import '../../notice/domain/notice_models.dart';
import '../../notice/presentation/notices_providers.dart';
import '../../store/domain/store_models.dart';
import '../../store/presentation/stores_providers.dart';
import '../data/firestore_catalog_admin_repository.dart';
import '../domain/catalog_admin_repository.dart';

final catalogAdminRepositoryProvider = Provider<CatalogAdminRepository?>((ref) {
  try {
    if (Firebase.apps.isNotEmpty) {
      return FirestoreCatalogAdminRepository();
    }
  } catch (_) {}
  return null;
});

/// 판매 상태를 바꾸고 카탈로그를 다시 읽는다.
class CatalogAdminController {
  const CatalogAdminController(this._ref);

  final Ref _ref;

  Future<void> saveMenuItem(MenuItem item) async {
    await _repository.saveMenuItem(item);
    _ref.invalidate(menuItemsProvider);
  }

  Future<void> deleteMenuItem(String menuId) async {
    await _repository.deleteMenuItem(menuId);
    _ref.invalidate(menuItemsProvider);
  }

  Future<void> saveBean(Bean bean) async {
    await _repository.saveBean(bean);
    _ref.invalidate(beansProvider);
  }

  Future<void> deleteBean(String beanId) async {
    await _repository.deleteBean(beanId);
    _ref.invalidate(beansProvider);
  }

  Future<void> saveBanner(EventBanner banner) async {
    await _repository.saveBanner(banner);
    _ref.invalidate(bannersProvider);
  }

  Future<void> deleteBanner(String bannerId) async {
    await _repository.deleteBanner(bannerId);
    _ref.invalidate(bannersProvider);
  }

  Future<void> saveStore(CafeStore store) async {
    await _repository.saveStore(store);
    _ref.invalidate(storesProvider);
  }

  Future<void> deleteStore(String storeId) async {
    await _repository.deleteStore(storeId);
    _ref.invalidate(storesProvider);
  }

  Future<void> saveNotice(Notice notice) async {
    await _repository.saveNotice(notice);
    _ref.invalidate(noticesProvider);
  }

  Future<void> deleteNotice(String noticeId) async {
    await _repository.deleteNotice(noticeId);
    _ref.invalidate(noticesProvider);
  }

  Future<void> setMenuSoldOut(String menuId, bool soldOut) async {
    await _repository.setMenuSoldOut(menuId: menuId, soldOut: soldOut);
    _ref.invalidate(menuItemsProvider);
  }

  Future<void> setBeanSoldOut(String beanId, bool soldOut) async {
    await _repository.setBeanSoldOut(beanId: beanId, soldOut: soldOut);
    _ref.invalidate(beansProvider);
  }

  CatalogAdminRepository get _repository {
    final repository = _ref.read(catalogAdminRepositoryProvider);
    if (repository == null) {
      throw StateError('관리자 기능을 사용할 수 없습니다.');
    }
    return repository;
  }
}

final catalogAdminControllerProvider = Provider<CatalogAdminController>((ref) {
  return CatalogAdminController(ref);
});
