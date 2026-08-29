import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/text_utils.dart';
import '../../../features/beans/presentation/bean_labels.dart';
import '../../../features/subscription/presentation/subscription_labels.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/subscription_models.dart';
import 'subscription_providers.dart';

final _priceFormat = NumberFormat('#,###');
final _dateFormat = DateFormat('yyyy.MM.dd');

class SubscriptionListScreen extends ConsumerWidget {
  const SubscriptionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionsState = ref.watch(beanSubscriptionsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).subscriptionListTitle),
      ),
      body: subscriptionsState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(AppLocalizations.of(context).subscriptionLoadFailed),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () =>
                    ref.invalidate(beanSubscriptionsControllerProvider),
                child: Text(AppLocalizations.of(context).retry),
              ),
            ],
          ),
        ),
        data: (subscriptions) {
          if (subscriptions.isEmpty) {
            return const _EmptySubscriptions();
          }
          return ListView.builder(
            padding: foxtrotListPadding,
            itemCount: subscriptions.length,
            itemBuilder: (context, index) =>
                _SubscriptionCard(subscription: subscriptions[index]),
          );
        },
      ),
    );
  }
}

class _EmptySubscriptions extends StatelessWidget {
  const _EmptySubscriptions();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.repeat, size: 48, color: context.palette.muted),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context).subscriptionEmptyTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context).subscriptionEmptyDetail,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => context.go('/menu'),
            icon: const Icon(LucideIcons.bean, size: 18),
            label: Text(AppLocalizations.of(context).subscriptionBrowse),
          ),
        ],
      ),
    );
  }
}

class _SubscriptionCard extends ConsumerWidget {
  const _SubscriptionCard({required this.subscription});

  final BeanSubscription subscription;

  Future<void> _cancel(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).subscriptionCancelTitle),
        content: Text(
          AppLocalizations.of(
            context,
          ).subscriptionCancelConfirm(subscription.beanName),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context).commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(AppLocalizations.of(context).subscriptionCancelAction),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) {
      return;
    }
    await ref
        .read(beanSubscriptionsControllerProvider.notifier)
        .cancel(subscription.id);
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(
            context,
          ).subscriptionCancelled(subscription.beanName),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final notifier = ref.read(beanSubscriptionsControllerProvider.notifier);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: context.palette.surface,
                    borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
                    border: Border.all(color: context.palette.border),
                  ),
                  child: Icon(
                    LucideIcons.repeat,
                    color: context.palette.accent,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subscription.beanName.keepWord,
                        style: textTheme.labelLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${AppLocalizations.of(context).beanOption(subscription.weight, subscription.grind)} · '
                        '${AppLocalizations.of(context).subscriptionCycleQuantity(AppLocalizations.of(context).subscriptionCycleLabel(subscription.cycle), subscription.quantity)}',
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                _SubscriptionStatusChip(status: subscription.status),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    subscription.isCancelled
                        ? AppLocalizations.of(context).subscriptionStartedOn(
                            _dateFormat.format(subscription.createdAt),
                          )
                        : AppLocalizations.of(context).subscriptionNextDelivery(
                            _dateFormat.format(subscription.nextDeliveryDate),
                          ),
                    style: textTheme.bodySmall,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  AppLocalizations.of(context).subscriptionPricePerDelivery(
                    _priceFormat.format(subscription.pricePerDelivery),
                  ),
                  style: textTheme.labelLarge,
                ),
              ],
            ),
            if (!subscription.isCancelled) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => subscription.isPaused
                          ? notifier.resume(subscription.id)
                          : notifier.pause(subscription.id),
                      icon: Icon(
                        subscription.isPaused
                            ? LucideIcons.play
                            : LucideIcons.pause,
                        size: 15,
                      ),
                      label: Text(
                        subscription.isPaused
                            ? AppLocalizations.of(context).subscriptionResume
                            : AppLocalizations.of(context).subscriptionPause,
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: context.palette.accent),
                        foregroundColor: context.palette.accentSoft,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _cancel(context, ref),
                      icon: const Icon(LucideIcons.x, size: 15),
                      label: Text(
                        AppLocalizations.of(context).subscriptionCancelAction,
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SubscriptionStatusChip extends StatelessWidget {
  const _SubscriptionStatusChip({required this.status});

  final SubscriptionStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
        border: Border.all(color: context.palette.border),
      ),
      child: Text(
        AppLocalizations.of(context).subscriptionStatusLabel(status),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: status == SubscriptionStatus.cancelled
              ? context.palette.muted
              : context.palette.accentSoft,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
