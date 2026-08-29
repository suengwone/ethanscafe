import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../utils/text_utils.dart';

/// 되돌릴 수 없는 삭제 전에 한 번 확인받는다.
/// 팝업 메뉴에서 바로 지워지면 잘못 눌렀을 때 복구할 방법이 없다.
Future<bool> confirmDelete(
  BuildContext context, {
  required String title,
  required String message,
  String? confirmLabel,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title.keepWord),
      content: Text(message.keepWord),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(AppLocalizations.of(context).commonCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: FilledButton.styleFrom(
            backgroundColor: context.palette.danger,
            foregroundColor: context.palette.onAccent,
          ),
          child: Text(confirmLabel ?? AppLocalizations.of(context).commonDelete),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}
