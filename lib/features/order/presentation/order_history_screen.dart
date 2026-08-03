import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../points/domain/points_models.dart';
import '../../points/presentation/points_providers.dart';

final _amountFormat = NumberFormat('#,###');
final _dateFormat = DateFormat('yyyy.MM.dd HH:mm');

final orderHistoryProvider = FutureProvider<List<PointHistoryEntry>>((
  ref,
) async {
  final data = await ref.watch(pointsControllerProvider.future);
  return data.history
      .where((entry) => entry.paymentAmount != null)
      .toList()
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
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
        data: (orders) {
          if (orders.isEmpty) {
            return const _EmptyOrders();
          }
          return ListView.builder(
            padding: foxtrotListPadding,
            itemCount: orders.length,
            itemBuilder: (context, index) =>
                _OrderCard(entry: orders[index]),
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
            '매장에서 결제하면 주문 내역이 쌓여요.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
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
