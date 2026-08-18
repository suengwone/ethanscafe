import '../../menu/domain/menu_models.dart';

/// 매장이 상품을 등록·수정하고 판매 상태를 바꾸는 통로.
///
/// 카탈로그 문서는 보안 규칙에서 admin 커스텀 클레임을 가진 계정만 쓸 수 있고,
/// 주문 시점에는 서버가 `soldOut`을 한 번 더 확인해 품절 상품을 막는다.
abstract class CatalogAdminRepository {
  /// 메뉴를 새로 만들거나 고친다. `id`가 비어 있으면 새 문서를 만든다.
  Future<void> saveMenuItem(MenuItem item);

  /// 메뉴를 내린다. 지난 주문은 그대로 두고 카탈로그에서만 사라진다.
  Future<void> deleteMenuItem(String menuId);

  Future<void> setMenuSoldOut({required String menuId, required bool soldOut});

  Future<void> setBeanSoldOut({required String beanId, required bool soldOut});
}
