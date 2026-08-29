import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';
import '../utils/text_utils.dart';

final _amountFormat = NumberFormat('#,###');

String orderCancelRefundSummary(
  AppLocalizations l10n, {
  int usedPoints = 0,
  int earnedPoints = 0,
  String? couponTitle,
}) {
  final lines = [
    if (couponTitle != null && couponTitle.isNotEmpty)
      l10n.orderCancelRestoreCoupon(couponTitle),
    if (usedPoints > 0)
      l10n.orderCancelRefundPoints(_amountFormat.format(usedPoints)),
    if (earnedPoints > 0)
      l10n.orderCancelTakeBackPoints(_amountFormat.format(earnedPoints)),
  ];
  return lines.join(' · ');
}

Future<bool?> showOrderCancelDialog(
  BuildContext context, {
  required String title,
  String refundSummary = '',
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title.keepWord),
      content: Text(
        refundSummary.isEmpty
            ? AppLocalizations.of(context).orderCancelIrreversible.keepWord
            : AppLocalizations.of(
                context,
              ).orderCancelWithSummary(refundSummary).keepWord,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(AppLocalizations.of(context).orderCancelGoBack),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(AppLocalizations.of(context).orderCancel),
        ),
      ],
    ),
  );
}
