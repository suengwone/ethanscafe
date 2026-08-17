import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../beans/presentation/beans_providers.dart';
import '../../menu/presentation/menu_providers.dart';
import '../data/firestore_catalog_admin_repository.dart';
import '../domain/catalog_admin_repository.dart';

final catalogAdminRepositoryProvider =
    Provider<CatalogAdminRepository?>((ref) {
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

final catalogAdminControllerProvider =
    Provider<CatalogAdminController>((ref) {
  return CatalogAdminController(ref);
});
