import '../../pickup/domain/pickup_order_models.dart';
import 'order_models.dart';

/// 매장이 처리해야 할 주문 한 건. 주문 문서가 회원별로 묶여 있어
/// 관리자 화면에서는 회원 uid를 함께 들고 다닌다.
class AdminPickupOrder {
  const AdminPickupOrder({required this.uid, required this.order});

  final String uid;
  final PickupOrder order;
}

class AdminBeanOrder {
  const AdminBeanOrder({required this.uid, required this.order});

  final String uid;
  final BeanOrder order;
}

/// 상태 전환 흐름. 서버(`functions/order_transitions.js`)와 같은 순서를 쓴다.
/// 여기서는 버튼 노출·비활성 판단에만 쓰고, 실제 검증은 서버가 한다.
const pickupStatusFlow = <PickupOrderStatus>[
  PickupOrderStatus.received,
  PickupOrderStatus.preparing,
  PickupOrderStatus.ready,
  PickupOrderStatus.pickedUp,
];

const beanDeliveryStatusFlow = <BeanOrderStatus>[
  BeanOrderStatus.received,
  BeanOrderStatus.roasting,
  BeanOrderStatus.shipped,
  BeanOrderStatus.delivered,
];

const beanPickupStatusFlow = <BeanOrderStatus>[
  BeanOrderStatus.received,
  BeanOrderStatus.roasting,
  BeanOrderStatus.ready,
  BeanOrderStatus.pickedUp,
];

PickupOrderStatus? nextPickupStatus(PickupOrderStatus status) {
  final index = pickupStatusFlow.indexOf(status);
  if (index == -1 || index == pickupStatusFlow.length - 1) {
    return null;
  }
  return pickupStatusFlow[index + 1];
}

List<BeanOrderStatus> beanStatusFlowOf(BeanFulfillmentMethod method) {
  return method == BeanFulfillmentMethod.pickup
      ? beanPickupStatusFlow
      : beanDeliveryStatusFlow;
}

BeanOrderStatus? nextBeanStatus(
  BeanOrderStatus status,
  BeanFulfillmentMethod method,
) {
  final flow = beanStatusFlowOf(method);
  final index = flow.indexOf(status);
  if (index == -1 || index == flow.length - 1) {
    return null;
  }
  return flow[index + 1];
}

/// 매장이 더 손댈 필요가 없는 주문인지. 완료·취소는 목록에서 감춘다.
bool isPickupOrderClosed(PickupOrder order) =>
    order.status == PickupOrderStatus.pickedUp ||
    order.status == PickupOrderStatus.cancelled;

bool isBeanOrderClosed(BeanOrder order) =>
    order.status == BeanOrderStatus.delivered ||
    order.status == BeanOrderStatus.pickedUp ||
    order.status == BeanOrderStatus.cancelled;

String pickupOrderSummary(PickupOrder order) => _summary(
      order.items.map((item) => item.menuName).toList(),
    );

String beanOrderSummary(BeanOrder order) => _summary(
      order.items.map((item) => item.beanName).toList(),
    );

String _summary(List<String> names) {
  if (names.isEmpty) {
    return '주문';
  }
  final first = names.first.isEmpty ? '주문' : names.first;
  return names.length == 1 ? first : '$first 외 ${names.length - 1}건';
}
