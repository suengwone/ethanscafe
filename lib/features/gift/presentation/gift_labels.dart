import '../../../l10n/app_localizations.dart';
import '../domain/gift_models.dart';

extension GiftLabels on AppLocalizations {
  String giftStatusLabel(BeanGiftStatus status) => switch (status) {
    BeanGiftStatus.sent => giftStatusSent,
    BeanGiftStatus.redeemed => giftStatusRedeemed,
  };
}
