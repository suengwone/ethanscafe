import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/text_utils.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/notification_models.dart';
import 'notification_feed_providers.dart';
import 'notification_labels.dart';

enum _NotificationMenuAction { notices, settings, clearAll }

class NotificationCenterScreen extends ConsumerWidget {
  const NotificationCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final feedState = ref.watch(notificationFeedProvider);
    final notifications = feedState.value ?? const <AppNotification>[];
    final unreadCount = ref.watch(unreadNotificationCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notificationCenterTitle),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: () => unawaited(
                ref.read(notificationFeedRepositoryProvider).markAllRead(),
              ),
              child: Text(l10n.notificationMarkAllRead),
            ),
          PopupMenuButton<_NotificationMenuAction>(
            onSelected: (action) => _onMenuSelected(context, ref, action),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: _NotificationMenuAction.notices,
                child: Text(l10n.notificationOpenNotices),
              ),
              PopupMenuItem(
                value: _NotificationMenuAction.settings,
                child: Text(l10n.notificationSettingsTitle),
              ),
              PopupMenuItem(
                value: _NotificationMenuAction.clearAll,
                enabled: notifications.isNotEmpty,
                child: Text(l10n.notificationClearAll),
              ),
            ],
          ),
        ],
      ),
      body: feedState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _FeedError(
          onRetry: () => ref.invalidate(notificationFeedProvider),
        ),
        data: (notifications) {
          if (notifications.isEmpty) {
            return const _EmptyFeed();
          }
          final now = ref.watch(notificationClockProvider)();
          return ListView.builder(
            padding: foxtrotListPadding,
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return Dismissible(
                key: ValueKey(notification.id),
                direction: DismissDirection.endToStart,
                background: _DismissBackground(
                  label: l10n.notificationRemoveOne,
                ),
                // 지우는 일은 저장소에 맡기고 목록에서 빼는 일은 스트림이 한다.
                // 여기서 true를 돌려주면 위젯이 먼저 사라지는데, 저장소가 새 목록을
                // 흘려보내기 전에 화면이 다시 그려지면 이미 없앤 Dismissible이
                // 트리에 남아 터진다. 그래서 항상 false를 돌려준다.
                confirmDismiss: (_) async {
                  await ref
                      .read(notificationFeedRepositoryProvider)
                      .remove(notification.id);
                  return false;
                },
                child: _NotificationCard(notification: notification, now: now),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _onMenuSelected(
    BuildContext context,
    WidgetRef ref,
    _NotificationMenuAction action,
  ) async {
    switch (action) {
      case _NotificationMenuAction.notices:
        context.push('/notices');
      case _NotificationMenuAction.settings:
        context.push('/profile/notifications');
      case _NotificationMenuAction.clearAll:
        final l10n = AppLocalizations.of(context);
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.notificationClearAllTitle),
            content: Text(l10n.notificationClearAllBody),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(l10n.commonCancel),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(l10n.notificationClearAll),
              ),
            ],
          ),
        );
        if (confirmed ?? false) {
          await ref.read(notificationFeedRepositoryProvider).clear();
        }
    }
  }
}

class _NotificationCard extends ConsumerWidget {
  const _NotificationCard({required this.notification, required this.now});

  final AppNotification notification;
  final DateTime now;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final isUnread = !notification.isRead;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
        onTap: () => _open(context, ref),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CategoryIcon(category: notification.category),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title.keepWord,
                            style: textTheme.labelLarge?.copyWith(
                              fontWeight: isUnread
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                        if (isUnread) ...[
                          const SizedBox(width: 8),
                          _UnreadDot(semanticLabel: l10n.notificationUnread),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notification.body.keepWord,
                      style: textTheme.bodyMedium?.copyWith(height: 1.5),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          l10n.notificationCategoryLabel(notification.category),
                          style: textTheme.bodySmall?.copyWith(
                            color: context.palette.accentSoft,
                          ),
                        ),
                        Text(
                          ' · ',
                          style: textTheme.bodySmall,
                        ),
                        Text(
                          l10n.notificationTimeLabel(
                            notification.createdAt,
                            now,
                          ),
                          style: textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 알림을 누르면 먼저 읽음으로 표시하고, 갈 곳이 적혀 있으면 그리로 옮긴다.
  void _open(BuildContext context, WidgetRef ref) {
    if (!notification.isRead) {
      unawaited(
        ref.read(notificationFeedRepositoryProvider).markRead(notification.id),
      );
    }
    final route = notification.route;
    if (route != null) {
      context.push(route);
    }
  }
}

class _CategoryIcon extends StatelessWidget {
  const _CategoryIcon({required this.category});

  final AppNotificationCategory category;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: context.palette.accent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(foxtrotRadiusSmall),
      ),
      child: Icon(_iconOf(category), size: 18, color: context.palette.accent),
    );
  }

  IconData _iconOf(AppNotificationCategory category) => switch (category) {
    AppNotificationCategory.order => LucideIcons.receiptText,
    AppNotificationCategory.points => LucideIcons.coins,
    AppNotificationCategory.gift => LucideIcons.gift,
    AppNotificationCategory.event => LucideIcons.megaphone,
  };
}

class _UnreadDot extends StatelessWidget {
  const _UnreadDot({required this.semanticLabel});

  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: context.palette.accent,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _DismissBackground extends StatelessWidget {
  const _DismissBackground({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
        color: context.palette.danger,
        borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
      ),
      child: Text(
        label,
        style: TextStyle(color: context.palette.onAccent),
      ),
    );
  }
}

class _EmptyFeed extends StatelessWidget {
  const _EmptyFeed();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.bellOff, size: 48, color: context.palette.muted),
          const SizedBox(height: 16),
          Text(
            l10n.notificationCenterEmpty,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.notificationCenterEmptyDetail,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _FeedError extends StatelessWidget {
  const _FeedError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.notificationCenterLoadFailed),
          const SizedBox(height: 8),
          TextButton(onPressed: onRetry, child: Text(l10n.retry)),
        ],
      ),
    );
  }
}
