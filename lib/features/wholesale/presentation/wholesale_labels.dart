import '../../../l10n/app_localizations.dart';
import '../domain/wholesale_models.dart';

extension WholesaleLabels on AppLocalizations {
  String wholesaleStatusLabel(WholesaleQuoteStatus status) => switch (status) {
    WholesaleQuoteStatus.requested => wholesaleStatusRequested,
    WholesaleQuoteStatus.quoted => wholesaleStatusQuoted,
    WholesaleQuoteStatus.confirmed => wholesaleStatusConfirmed,
  };
}
