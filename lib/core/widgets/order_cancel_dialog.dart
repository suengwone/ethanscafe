import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/text_utils.dart';

final _amountFormat = NumberFormat('#,###');

String orderCancelRefundSummary({
  int usedPoints = 0,
  int earnedPoints = 0,
  String? couponTitle,
}) {
  final lines = [
    if (couponTitle != null && couponTitle.isNotEmpty) '쿠폰($couponTitle) 복구',
    if (usedPoints > 0) '사용 포인트 ${_amountFormat.format(usedPoints)}P 환급',
    if (earnedPoints > 0) '적립 포인트 ${_amountFormat.format(earnedPoints)}P 회수',
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
            ? '취소 후에는 되돌릴 수 없어요.'.keepWord
            : '취소 후에는 되돌릴 수 없어요.\n$refundSummary 처리가 함께 진행돼요.'.keepWord,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('돌아가기'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('주문 취소'),
        ),
      ],
    ),
  );
}
