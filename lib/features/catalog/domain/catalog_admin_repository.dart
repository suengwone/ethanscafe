/// 매장이 판매 상태를 바꾸는 통로.
///
/// 카탈로그 문서는 보안 규칙에서 admin 커스텀 클레임을 가진 계정만 쓸 수 있고,
/// 주문 시점에는 서버가 `soldOut`을 한 번 더 확인해 품절 상품을 막는다.
abstract class CatalogAdminRepository {
  Future<void> setMenuSoldOut({required String menuId, required bool soldOut});

  Future<void> setBeanSoldOut({required String beanId, required bool soldOut});
}
