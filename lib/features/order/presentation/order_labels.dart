import '../../../l10n/app_localizations.dart';
import '../domain/order_models.dart';
import '../domain/refund_status.dart';

extension OrderLabels on AppLocalizations {
  String beanOrderStatusLabel(BeanOrderStatus status) => switch (status) {
    BeanOrderStatus.received => beanOrderStatusReceived,
    BeanOrderStatus.roasting => beanOrderStatusRoasting,
    BeanOrderStatus.shipped => beanOrderStatusShipped,
    BeanOrderStatus.delivered => beanOrderStatusDelivered,
    BeanOrderStatus.ready => beanOrderStatusReady,
    BeanOrderStatus.pickedUp => beanOrderStatusPickedUp,
    BeanOrderStatus.cancelled => beanOrderStatusCancelled,
  };

  String fulfillmentLabel(BeanFulfillmentMethod method) => switch (method) {
    BeanFulfillmentMethod.delivery => fulfillmentDelivery,
    BeanFulfillmentMethod.pickup => fulfillmentPickup,
  };

  String refundStatusLabel(RefundStatus status) => switch (status) {
    RefundStatus.pending => refundStatusPending,
    RefundStatus.done => refundStatusDone,
    RefundStatus.failed => refundStatusFailed,
  };
}
