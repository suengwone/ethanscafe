import '../../../l10n/app_localizations.dart';
import '../domain/store_models.dart';

extension StoreLabels on AppLocalizations {
  String congestionLabel(StoreCongestion congestion) => switch (congestion) {
    StoreCongestion.unknown => congestionUnknown,
    StoreCongestion.relaxed => congestionRelaxed,
    StoreCongestion.normal => congestionNormal,
    StoreCongestion.busy => congestionBusy,
  };
}
