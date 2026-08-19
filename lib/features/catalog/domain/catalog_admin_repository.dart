import '../../beans/domain/bean_models.dart';
import '../../home/domain/banner_models.dart';
import '../../menu/domain/menu_models.dart';
import '../../notice/domain/notice_models.dart';
import '../../store/domain/store_models.dart';

/// 매장이 상품을 등록·수정하고 판매 상태를 바꾸는 통로.
///
/// 카탈로그 문서는 보안 규칙에서 admin 커스텀 클레임을 가진 계정만 쓸 수 있고,
/// 주문 시점에는 서버가 `soldOut`을 한 번 더 확인해 품절 상품을 막는다.
abstract class CatalogAdminRepository {
  /// 메뉴를 새로 만들거나 고친다. `id`가 비어 있으면 새 문서를 만든다.
  Future<void> saveMenuItem(MenuItem item);

  /// 메뉴를 내린다. 지난 주문은 그대로 두고 카탈로그에서만 사라진다.
  Future<void> deleteMenuItem(String menuId);

  /// 원두를 새로 만들거나 고친다. `id`가 비어 있으면 새 문서를 만든다.
  Future<void> saveBean(Bean bean);

  /// 원두를 내린다. 지난 주문은 그대로 두고 카탈로그에서만 사라진다.
  Future<void> deleteBean(String beanId);

  /// 홈 이벤트 배너를 새로 만들거나 고친다. `id`가 비어 있으면 새 문서를 만든다.
  Future<void> saveBanner(EventBanner banner);

  /// 배너를 홈에서 내린다.
  Future<void> deleteBanner(String bannerId);

  /// 매장을 새로 만들거나 고친다. `id`가 비어 있으면 새 문서를 만든다.
  Future<void> saveStore(CafeStore store);

  /// 매장을 매장 찾기에서 내린다.
  Future<void> deleteStore(String storeId);

  /// 공지를 새로 만들거나 고친다. `id`가 비어 있으면 새 문서를 만든다.
  Future<void> saveNotice(Notice notice);

  /// 공지를 알림 목록에서 내린다.
  Future<void> deleteNotice(String noticeId);

  Future<void> setMenuSoldOut({required String menuId, required bool soldOut});

  Future<void> setBeanSoldOut({required String beanId, required bool soldOut});
}
