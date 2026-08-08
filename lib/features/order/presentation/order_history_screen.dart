import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/text_utils.dart';
import '../../points/domain/points_models.dart';
import '../../points/presentation/points_providers.dart';
import '../domain/order_models.dart';
import 'order_providers.dart';

final _amountFormat = NumberFormat('#,###');
final _dateFormat = DateFormat('yyyy.MM.dd HH:mm');

sealed class OrderRecord {
  DateTime get createdAt;
}

class BeanOrderRecord implements OrderRecord {
  const BeanOrderRecord(this.order);

  final BeanOrder order;

  @override
  DateTime get createdAt => order.createdAt;
}

class StorePaymentRecord implements OrderRecord {
  const StorePaymentRecord(this.entry);

  final PointHistoryEntry entry;

  @override
  DateTime get createdAt => entry.createdAt;
}

final orderHistoryProvider = FutureProvider<List<OrderRecord>>((ref) async {
  final pointsData = await ref.watch(pointsControllerProvider.future);
  final orders = await ref.watch(beanOrdersControllerProvider.future);
  return <OrderRecord>[
    ...orders.map(BeanOrderRecord.new),
    ...pointsData.history
        .where(
          (entry) =>
              entry.paymentAmount != null &&
              entry.description != beanOrderPaymentDescription,
        )
        .map(StorePaymentRecord.new),
  ]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
});

class OrderHistoryScreen extends ConsumerWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersState = ref.watch(orderHistoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('주문 내역')),
      body: ordersState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('주문 내역을 불러오지 못했습니다.'),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.invalidate(orderHistoryProvider),
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
        data: (records) {
          if (records.isEmpty) {
            return const _EmptyOrders();
          }
          return ListView.builder(
            padding: foxtrotListPadding,
            itemCount: records.length,
            itemBuilder: (context, index) => switch (records[index]) {
              BeanOrderRecord(:final order) => _BeanOrderCard(order: order),
              StorePaymentRecord(:final entry) => _OrderCard(entry: entry),
            },
          );
        },
      ),
    );
  }
}

class _EmptyOrders extends StatelessWidget {
  const _EmptyOrders();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(LucideIcons.receiptText, size: 48, color: foxtrotMuted),
          const SizedBox(height: 16),
          Text(
            '주문 내역이 없어요',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '매장 결제나 원두 주문을 하면 내역이 쌓여요.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _BeanOrderCard extends StatelessWidget {
  const _BeanOrderCard({required this.order});

  final BeanOrder order;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final pointsSummary = [
      if (order.couponDiscount > 0)
        '쿠폰 -${_amountFormat.format(order.couponDiscount)}원',
      if (order.usedPoints > 0) '-${_amountFormat.format(order.usedPoints)}P 사용',
      if (order.earnedPoints > 0)
        '+${_amountFormat.format(order.earnedPoints)}P 적립',
    ].join(' · ');

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
                    LucideIcons.bean,
                    color: foxtrotGold,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(order.summary.keepWord, style: textTheme.labelLarge),
                      const SizedBox(height: 4),
                      Text(
                        _dateFormat.format(order.createdAt),
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                _StatusChip(status: order.status),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    order.paymentMethod != null
                        ? '원두 주문 · ${order.paymentMethod} · 총 ${order.itemCount}개'
                        : '원두 주문 · 총 ${order.itemCount}개',
                    style: textTheme.bodySmall,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${_amountFormat.format(order.paidAmount)}원',
                      style: textTheme.labelLarge,
                    ),
                    if (pointsSummary.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        pointsSummary,
                        style:
                            textTheme.bodySmall?.copyWith(color: foxtrotGold),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final BeanOrderStatus status;

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
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(color: foxtrotGoldLight, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.entry});

  final PointHistoryEntry entry;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final paymentAmount = entry.paymentAmount ?? 0;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
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
                LucideIcons.receiptText,
                color: foxtrotGold,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(entry.description, style: textTheme.labelLarge),
                  const SizedBox(height: 4),
                  Text(
                    _dateFormat.format(entry.createdAt),
                    style: textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${_amountFormat.format(paymentAmount)}원',
                  style: textTheme.labelLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  '+${_amountFormat.format(entry.amount)}P 적립',
                  style: textTheme.bodySmall?.copyWith(color: foxtrotGold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
