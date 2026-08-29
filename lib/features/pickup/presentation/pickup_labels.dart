import '../../../l10n/app_localizations.dart';
import '../domain/pickup_order_models.dart';

extension PickupLabels on AppLocalizations {
  String pickupStatusLabel(PickupOrderStatus status) => switch (status) {
    PickupOrderStatus.received => pickupStatusReceived,
    PickupOrderStatus.preparing => pickupStatusPreparing,
    PickupOrderStatus.ready => pickupStatusReady,
    PickupOrderStatus.pickedUp => pickupStatusPickedUp,
    PickupOrderStatus.cancelled => pickupStatusCancelled,
  };
}
