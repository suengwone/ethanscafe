import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/widgets/circle_icon_button.dart';
import '../../../l10n/app_localizations.dart';
import 'notification_feed_providers.dart';

/// 안 읽은 알림 수를 뱃지로 얹은 종 버튼. 고객 홈과 사업자 홈이 함께 쓴다.
class NotificationBellButton extends ConsumerWidget {
  const NotificationBellButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final unreadCount = ref.watch(unreadNotificationCountProvider);
    final button = CircleIconButton(
      icon: LucideIcons.bell,
      tooltip: l10n.homeNotifications,
      onPressed: () => context.push('/notifications'),
    );
    if (unreadCount == 0) {
      return button;
    }
    return Semantics(
      label: l10n.notificationUnreadCount(unreadCount),
      child: Badge.count(count: unreadCount, child: button),
    );
  }
}
