import '../../l10n/app_localizations.dart';

/// 주문·선물·견적 목록이 다 같은 모양으로 줄인다: 대표 상품 하나에 "외 N건".
extension SummaryLabels on AppLocalizations {
  String itemsSummary(String firstName, int itemCount) =>
      itemCount <= 1 ? firstName : orderItemsSummary(firstName, itemCount - 1);
}
