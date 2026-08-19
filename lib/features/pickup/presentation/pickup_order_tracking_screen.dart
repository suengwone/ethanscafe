import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/text_utils.dart';
import '../../../core/widgets/order_cancel_dialog.dart';
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
      appBar: AppBar(title: const Text('주문 현황')),
      body: orderState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('주문 현황을 불러오지 못했습니다.'),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () =>
                    ref.invalidate(pickupOrderTrackingProvider(orderId)),
                child: const Text('다시 시도'),
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
                      '주문 상태가 바뀌면 실시간으로 반영돼요.',
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
          Text('주문을 찾을 수 없어요', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            '주문 내역에서 다시 확인해 주세요.',
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
              '주문번호 ${order.pickupNumber}번',
              style: textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(order.summary.keepWord, style: textTheme.labelLarge),
            const SizedBox(height: 4),
            Text(
              '${_timeFormat.format(order.createdAt)} 주문',
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

  static const _stepDescriptions = {
    PickupOrderStatus.received: '매장에서 주문을 확인하고 있어요.',
    PickupOrderStatus.preparing: '바리스타가 정성껏 만들고 있어요.',
    PickupOrderStatus.ready: '픽업대에서 주문을 찾아가세요.',
    PickupOrderStatus.pickedUp: '맛있게 즐기세요. 감사합니다!',
  };

  @override
  Widget build(BuildContext context) {
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
                label: step.label,
                description: _stepDescriptions[step]!,
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
                    color: isCurrent || isDone ? context.palette.accent : context.palette.border,
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
                    color: isDone ? context.palette.accent : context.palette.border,
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
                            color: context.palette.accent.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(
                              foxtrotRadiusSmall,
                            ),
                          ),
                          child: Text(
                            '진행 중',
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
  String get _message {
    switch (refund) {
      case RefundStatus.pending:
      case RefundStatus.failed:
        return '사용한 쿠폰과 포인트는 복구되었어요. 결제 환불은 확인 중이며, '
            '오래 걸리면 고객센터로 문의해 주세요.';
      case RefundStatus.done:
      case null:
        return '사용한 쿠폰과 포인트는 복구되었어요. 결제 환불은 수단에 따라 3~5일 소요될 수 있어요.';
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
            Text('주문이 취소되었어요', style: textTheme.titleSmall),
            const SizedBox(height: 6),
            Text(
              _message.keepWord,
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
        child: const Text('주문 취소하기'),
      ),
    );
  }

  Future<void> _cancelOrder(BuildContext context, WidgetRef ref) async {
    final confirmed = await showOrderCancelDialog(
      context,
      title: '픽업 주문을 취소할까요?',
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
          const SnackBar(content: Text('주문이 취소되었어요. 사용한 쿠폰과 포인트는 복구됩니다.')),
        );
      }
    } on StateError catch (error) {
      ref.invalidate(pickupOrderTrackingProvider(order.id));
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.message)));
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
            Text('주문 상품', style: textTheme.titleSmall),
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
                    Text('${item.quantity}개', style: textTheme.bodySmall),
                    const SizedBox(width: 12),
                    Text(
                      '${_amountFormat.format(item.totalPrice)}원',
                      style: textTheme.labelLarge,
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 4),
            Container(height: 1, color: context.palette.border.withValues(alpha: 0.5)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: Text('결제 금액', style: textTheme.labelLarge)),
                Text(
                  '${_amountFormat.format(order.paidAmount)}원',
                  style: textTheme.titleMedium?.copyWith(color: context.palette.accent),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
