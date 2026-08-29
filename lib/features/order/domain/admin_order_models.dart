import '../../pickup/domain/pickup_order_models.dart';
import 'order_models.dart';

/// 매장이 처리해야 할 주문 한 건.
///
/// 주문 원본은 회원별 문서에 배열로 쌓여 있어 그대로 읽으면 회원 수만큼 문서를
/// 읽어야 한다. 그래서 서버가 진행 중인 주문만 `active_orders`에 떼어 두고,
/// 매장 화면은 목록에 필요한 값만 담긴 이 투영을 읽는다.
class ActivePickupOrder {
  const ActivePickupOrder({
    required this.uid,
    required this.orderId,
    required this.summary,
    required this.status,
    required this.pickupNumber,
    required this.storeName,
    required this.createdAt,
  });

  final String uid;
  final String orderId;
  final String summary;
  final PickupOrderStatus status;
  final int pickupNumber;
  final String storeName;
  final DateTime createdAt;
}

class ActiveBeanOrder {
  const ActiveBeanOrder({
    required this.uid,
    required this.orderId,
    required this.summary,
    required this.status,
    required this.fulfillmentMethod,
    required this.createdAt,
    this.recipient,
    this.storeName,
  });

  final String uid;
  final String orderId;
  final String summary;
  final BeanOrderStatus status;
  final BeanFulfillmentMethod fulfillmentMethod;
  final DateTime createdAt;
  final String? recipient;
  final String? storeName;

  /// 배송이면 수령인을, 픽업이면 매장을 보여준다. 둘 다 비어 있을 때 쓸 문구는
  /// 언어를 타므로 화면이 고른다.
  String? get destination => fulfillmentMethod == BeanFulfillmentMethod.delivery
      ? recipient
      : storeName;
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

/// 매장이 취소할 수 있는 주문인지. 서버(`functions/order_cancel.js`)의
/// `ADMIN_CANCELLABLE`과 같은 기준이며, 고객에게 넘어간 뒤에는 취소할 수 없다.
bool isPickupStatusCancellable(PickupOrderStatus status) =>
    status == PickupOrderStatus.received ||
    status == PickupOrderStatus.preparing ||
    status == PickupOrderStatus.ready;

bool isBeanStatusCancellable(BeanOrderStatus status) =>
    status == BeanOrderStatus.received ||
    status == BeanOrderStatus.roasting ||
    status == BeanOrderStatus.ready;
