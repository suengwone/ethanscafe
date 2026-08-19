import 'package:cafe_app/features/beans/domain/bean_models.dart';
import 'package:cafe_app/features/catalog/domain/catalog_admin_repository.dart';
import 'package:cafe_app/features/home/domain/banner_models.dart';
import 'package:cafe_app/features/menu/domain/menu_models.dart';
import 'package:cafe_app/features/store/domain/store_models.dart';

/// 관리자 화면이 저장·삭제로 무엇을 넘겼는지만 붙잡아 두는 대역.
class FakeCatalogAdminRepository implements CatalogAdminRepository {
  MenuItem? savedMenuItem;
  Bean? savedBean;
  EventBanner? savedBanner;
  CafeStore? savedStore;
  String? deletedBannerId;
  String? deletedStoreId;

  @override
  Future<void> saveMenuItem(MenuItem item) async => savedMenuItem = item;

  @override
  Future<void> deleteMenuItem(String menuId) async {}

  @override
  Future<void> saveBean(Bean bean) async => savedBean = bean;

  @override
  Future<void> deleteBean(String beanId) async {}

  @override
  Future<void> saveBanner(EventBanner banner) async => savedBanner = banner;

  @override
  Future<void> deleteBanner(String bannerId) async =>
      deletedBannerId = bannerId;

  @override
  Future<void> saveStore(CafeStore store) async => savedStore = store;

  @override
  Future<void> deleteStore(String storeId) async => deletedStoreId = storeId;

  @override
  Future<void> setMenuSoldOut({
    required String menuId,
    required bool soldOut,
  }) async {}

  @override
  Future<void> setBeanSoldOut({
    required String beanId,
    required bool soldOut,
  }) async {}
}
