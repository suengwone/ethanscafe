import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../services/points_lock_providers.dart';
import '../services/points_lock_service.dart';

/// 포인트를 쓰는 주문 앞에서 본인 확인을 받는다.
///
/// 포인트를 쓰지 않는 주문은 묻지 않고 지나간다. 막히면 까닭을 알려 주고
/// false를 돌려주므로, 부르는 쪽은 그때 주문을 시작하지 않으면 된다.
Future<bool> confirmPointsLock(
  BuildContext context,
  WidgetRef ref,
  int usedPoints,
) async {
  if (usedPoints <= 0) {
    return true;
  }
  final l10n = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);
  final result = await ref
      .read(pointsLockProvider)
      .confirm(l10n.pointsLockReason);
  if (passesPointsLock(result)) {
    return true;
  }
  messenger.showSnackBar(
    SnackBar(
      content: Text(
        result == DeviceAuthResult.lockedOut
            ? l10n.pointsLockLockedOut
            : l10n.pointsLockRefused,
      ),
    ),
  );
  return false;
}
