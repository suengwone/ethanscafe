import '../../pickup/domain/pickup_order_models.dart';
import 'admin_order_models.dart';
import 'order_models.dart';

/// 매장 관리자용 주문 조회/상태 변경.
/// 상태 변경은 서버 콜러블만 수행하며, 클라이언트 직접 쓰기는 보안 규칙에서 막힌다.
abstract class AdminOrdersRepository {
  /// 아직 매장이 처리해야 하는 주문(완료·취소 제외)만 돌려준다.
  Future<List<ActivePickupOrder>> loadActivePickupOrders();

  Future<List<ActiveBeanOrder>> loadActiveBeanOrders();

  Future<void> advancePickupStatus({
    required String uid,
    required String orderId,
    required PickupOrderStatus status,
  });

  Future<void> advanceBeanStatus({
    required String uid,
    required String orderId,
    required BeanOrderStatus status,
  });

  /// 품절·설비 고장처럼 매장 사정으로 주문을 취소한다.
  /// 서버가 포인트·쿠폰을 되돌리고 카드 결제분을 환불한다.
  Future<void> cancelOrder({
    required String orderType,
    required String uid,
    required String orderId,
  });
}
