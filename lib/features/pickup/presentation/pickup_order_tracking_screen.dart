import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/l10n/summary_labels.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/text_utils.dart';
import '../../../core/widgets/order_cancel_dialog.dart';
import '../../../features/pickup/presentation/pickup_labels.dart';
import '../../../l10n/app_localizations.dart';
import '../../order/domain/refund_status.dart';
import '../domain/pickup_order_models.dart';
import 'pickup_order_providers.dart';

final _amountFormat = NumberFormat('#,###');
final _timeFormat = DateFormat('yyyy.MM.dd HH:mm');

class PickupOrderTrackingScreen extends ConsumerWidget {
  const PickupOrderTrackingScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderState = ref.watch(pickupOrderTrackingProvider(orderId));

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).pickupTrackingTitle),
      ),
      body: orderState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(AppLocalizations.of(context).pickupTrackingLoadFailed),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () =>
                    ref.invalidate(pickupOrderTrackingProvider(orderId)),
                child: Text(AppLocalizations.of(context).retry),
              ),
            ],
          ),
        ),
        data: (order) {
          if (order == null) {
            return const _OrderNotFound();
          }
          return ListView(
            padding: foxtrotListPadding,
            children: [
              _OrderSummaryCard(order: order),
              const SizedBox(height: 12),
              if (order.isCancelled)
                _CancelledCard(refund: order.refundStatus)
              else
                _StatusTimelineCard(status: order.status),
              const SizedBox(height: 12),
              _OrderItemsCard(order: order),
              if (order.isCancellable) ...[
                const SizedBox(height: 12),
                _CancelOrderButton(order: order),
              ],
              const SizedBox(height: 16),
              if (!order.isCancelled)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      LucideIcons.refreshCw,
                      size: 12,
                      color: context.palette.muted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      AppLocalizations.of(context).pickupTrackingLiveNotice,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}

class _OrderNotFound extends StatelessWidget {
  const _OrderNotFound();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.receiptText, size: 48, color: context.palette.muted),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context).pickupTrackingNotFound,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context).pickupTrackingNotFoundDetail,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _OrderSummaryCard extends StatelessWidget {
  const _OrderSummaryCard({required this.order});

  final PickupOrder order;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(order.storeName, style: textTheme.titleSmall),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(
                context,
              ).pickupOrderNumber(order.pickupNumber),
              style: textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)
                  .itemsSummary(order.firstItemName, order.items.length)
                  .keepWord,
              style: textTheme.labelLarge,
            ),
            const SizedBox(height: 4),
            Text(
              AppLocalizations.of(
                context,
              ).pickupOrderedAt(_timeFormat.format(order.createdAt)),
              style: textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusTimelineCard extends StatelessWidget {
  const _StatusTimelineCard({required this.status});

  final PickupOrderStatus status;

  static const _stepIcons = {
    PickupOrderStatus.received: LucideIcons.receiptText,
    PickupOrderStatus.preparing: LucideIcons.coffee,
    PickupOrderStatus.ready: LucideIcons.bellRing,
    PickupOrderStatus.pickedUp: LucideIcons.circleCheck,
  };

  static String _stepDescription(AppLocalizations l10n, PickupOrderStatus s) =>
      switch (s) {
        PickupOrderStatus.received => l10n.pickupStepReceived,
        PickupOrderStatus.preparing => l10n.pickupStepPreparing,
        PickupOrderStatus.ready => l10n.pickupStepReady,
        PickupOrderStatus.pickedUp => l10n.pickupStepPickedUp,
        PickupOrderStatus.cancelled => l10n.pickupStatusCancelled,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    const steps = pickupOrderProgressSteps;
    final currentIndex = steps.indexOf(status);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final (index, step) in steps.indexed)
              _StatusStep(
                icon: _stepIcons[step]!,
                label: l10n.pickupStatusLabel(step),
                description: _stepDescription(l10n, step),
                state: index < currentIndex
                    ? _StepState.done
                    : index == currentIndex
                    ? _StepState.current
                    : _StepState.upcoming,
                isLast: index == steps.length - 1,
              ),
          ],
        ),
      ),
    );
  }
}

enum _StepState { done, current, upcoming }

class _StatusStep extends StatelessWidget {
  const _StatusStep({
    required this.icon,
    required this.label,
    required this.description,
    required this.state,
    required this.isLast,
  });

  final IconData icon;
  final String label;
  final String description;
  final _StepState state;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isCurrent = state == _StepState.current;
    final isDone = state == _StepState.done;
    final accent = isCurrent
        ? context.palette.accent
        : isDone
        ? context.palette.accentSoft
        : context.palette.muted;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isCurrent
                      ? context.palette.accent.withValues(alpha: 0.18)
                      : context.palette.surface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isCurrent || isDone
                        ? context.palette.accent
                        : context.palette.border,
                  ),
                ),
                child: Icon(
                  isDone ? LucideIcons.check : icon,
                  size: 18,
                  color: accent,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: isDone
                        ? context.palette.accent
                        : context.palette.border,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 2, bottom: isLast ? 8 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        label,
                        style: textTheme.labelLarge?.copyWith(
                          color: isCurrent ? context.palette.accent : null,
                          fontWeight: isCurrent
                              ? FontWeight.w700
                              : FontWeight.w600,
                        ),
                      ),
                      if (isCurrent) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: context.palette.accent.withValues(
                              alpha: 0.18,
                            ),
                            borderRadius: BorderRadius.circular(
                              foxtrotRadiusSmall,
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context).pickupInProgress,
                            style: textTheme.bodySmall?.copyWith(
                              color: context.palette.accent,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(description.keepWord, style: textTheme.bodySmall),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CancelledCard extends StatelessWidget {
  const _CancelledCard({this.refund});

  final RefundStatus? refund;

  /// 환불이 밀린 건은 다 끝난 것처럼 말하지 않는다.
  String _message(AppLocalizations l10n) {
    switch (refund) {
      case RefundStatus.pending:
      case RefundStatus.failed:
        return l10n.pickupRefundChecking;
      case RefundStatus.done:
      case null:
        return l10n.pickupRefundNormal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(LucideIcons.circleX, size: 40, color: context.palette.muted),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context).pickupCancelledTitle,
              style: textTheme.titleSmall,
            ),
            const SizedBox(height: 6),
            Text(
              _message(AppLocalizations.of(context)).keepWord,
              style: textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _CancelOrderButton extends ConsumerWidget {
  const _CancelOrderButton({required this.order});

  final PickupOrder order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: double.infinity,
      height: 44,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: context.palette.muted,
          textStyle: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        onPressed: () => _cancelOrder(context, ref),
        child: Text(AppLocalizations.of(context).pickupCancelAction),
      ),
    );
  }

  Future<void> _cancelOrder(BuildContext context, WidgetRef ref) async {
    final confirmed = await showOrderCancelDialog(
      context,
      title: AppLocalizations.of(context).pickupCancelTitle,
      refundSummary: orderCancelRefundSummary(
        usedPoints: order.usedPoints,
        earnedPoints: order.earnedPoints,
        couponTitle: order.couponTitle,
      ),
    );
    if (confirmed != true || !context.mounted) {
      return;
    }
    try {
      await ref
          .read(pickupOrdersControllerProvider.notifier)
          .cancelOrder(order.id);
      ref.invalidate(pickupOrderTrackingProvider(order.id));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).orderCancelledNotice),
          ),
        );
      }
    } on StateError catch (error) {
      ref.invalidate(pickupOrderTrackingProvider(order.id));
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
      }
    }
  }
}

class _OrderItemsCard extends StatelessWidget {
  const _OrderItemsCard({required this.order});

  final PickupOrder order;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).pickupSectionItems,
              style: textTheme.titleSmall,
            ),
            const SizedBox(height: 12),
            for (final item in order.items)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.nameWithOption.keepWord,
                        style: textTheme.bodyMedium,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      AppLocalizations.of(
                        context,
                      ).pickupItemQuantity(item.quantity),
                      style: textTheme.bodySmall,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      AppLocalizations.of(
                        context,
                      ).priceWon(_amountFormat.format(item.totalPrice)),
                      style: textTheme.labelLarge,
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 4),
            Container(
              height: 1,
              color: context.palette.border.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    AppLocalizations.of(context).pickupPaidAmount,
                    style: textTheme.labelLarge,
                  ),
                ),
                Text(
                  AppLocalizations.of(
                    context,
                  ).priceWon(_amountFormat.format(order.paidAmount)),
                  style: textTheme.titleMedium?.copyWith(
                    color: context.palette.accent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
