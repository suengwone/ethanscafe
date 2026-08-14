import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/text_utils.dart';
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
      appBar: AppBar(title: const Text('원두 정기구독')),
      body: subscriptionsState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('구독 정보를 불러오지 못했습니다.'),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () =>
                    ref.invalidate(beanSubscriptionsControllerProvider),
                child: const Text('다시 시도'),
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
          const Icon(LucideIcons.repeat, size: 48, color: foxtrotMuted),
          const SizedBox(height: 16),
          Text(
            '구독 중인 원두가 없어요',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '원두 상세에서 정기구독을 시작하면 주기마다 배송해 드려요.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => context.go('/menu'),
            icon: const Icon(LucideIcons.bean, size: 18),
            label: const Text('원두 보러 가기'),
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
        title: const Text('구독 해지'),
        content: Text(
          '${subscription.beanName} 정기구독을 해지할까요?\n해지 후에는 배송이 중단됩니다.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('해지하기'),
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
      SnackBar(content: Text('${subscription.beanName} 구독이 해지되었습니다.')),
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
                    color: foxtrotSurface,
                    borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
                    border: Border.all(color: foxtrotBorder),
                  ),
                  child: const Icon(
                    LucideIcons.repeat,
                    color: foxtrotGold,
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
                        '${subscription.optionLabel} · ${subscription.cycleLabel}',
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
                        ? '구독 시작 ${_dateFormat.format(subscription.createdAt)}'
                        : '다음 배송 ${_dateFormat.format(subscription.nextDeliveryDate)}',
                    style: textTheme.bodySmall,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '회당 ${_priceFormat.format(subscription.pricePerDelivery)}원',
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
                      label: Text(subscription.isPaused ? '구독 재개' : '일시정지'),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: foxtrotGold),
                        foregroundColor: foxtrotGoldLight,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _cancel(context, ref),
                      icon: const Icon(LucideIcons.x, size: 15),
                      label: const Text('해지하기'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor:
                            Theme.of(context).colorScheme.error,
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
        color: foxtrotSurface,
        borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
        border: Border.all(color: foxtrotBorder),
      ),
      child: Text(
        status.label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: status == SubscriptionStatus.cancelled
                  ? foxtrotMuted
                  : foxtrotGoldLight,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
