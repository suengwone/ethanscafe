import '../../../l10n/app_localizations.dart';
import '../domain/review_models.dart';

extension ReviewLabels on AppLocalizations {
  String reviewProductTypeLabel(ReviewProductType type) => switch (type) {
    ReviewProductType.menu => reviewProductTypeMenu,
    ReviewProductType.bean => reviewProductTypeBean,
  };
}
