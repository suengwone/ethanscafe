import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/text_utils.dart';
import '../../../core/widgets/order_cancel_dialog.dart';
import '../../pickup/domain/pickup_order_models.dart';
import '../../pickup/presentation/pickup_order_providers.dart';
import '../../points/domain/points_models.dart';
import '../../points/presentation/points_providers.dart';
import '../../review/domain/review_models.dart';
import '../../review/presentation/review_providers.dart';
import '../../review/presentation/review_sheet.dart';
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

class PickupOrderRecord implements OrderRecord {
  const PickupOrderRecord(this.order);

  final PickupOrder order;

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
  final pickupOrders = await ref.watch(pickupOrdersControllerProvider.future);
  return <OrderRecord>[
    ...orders.map(BeanOrderRecord.new),
    ...pickupOrders.map(PickupOrderRecord.new),
    ...pointsData.history
        .where(
          (entry) =>
              entry.paymentAmount != null &&
              entry.description != beanOrderPaymentDescription &&
              entry.description != pickupOrderPaymentDescription,
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
          return RefreshIndicator(
            onRefresh: () => ref.refresh(orderHistoryProvider.future),
            child: ListView.builder(
              padding: foxtrotListPadding,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: records.length,
              itemBuilder: (context, index) => switch (records[index]) {
                BeanOrderRecord(:final order) => _BeanOrderCard(order: order),
                PickupOrderRecord(:final order) =>
                  _PickupOrderCard(order: order),
                StorePaymentRecord(:final entry) => _OrderCard(entry: entry),
              },
            ),
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
          Text('주문 내역이 없어요', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            '매장 결제나 픽업 · 원두 주문을 하면 내역이 쌓여요.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _BeanOrderCard extends ConsumerWidget {
  const _BeanOrderCard({required this.order});

  final BeanOrder order;

  bool get _reviewable =>
      order.status == BeanOrderStatus.delivered ||
      order.status == BeanOrderStatus.pickedUp;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final pointsSummary = [
      if (order.couponDiscount > 0)
        '쿠폰 -${_amountFormat.format(order.couponDiscount)}원',
      if (order.usedPoints > 0)
        '-${_amountFormat.format(order.usedPoints)}P 사용',
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
                    [
                      '원두 주문',
                      order.fulfillmentMethod == BeanFulfillmentMethod.pickup &&
                              order.storeName != null
                          ? '${order.fulfillmentMethod.label} · ${order.storeName}'
                          : order.fulfillmentMethod.label,
                      if (order.paymentMethod != null) order.paymentMethod!,
                      '총 ${order.itemCount}개',
                    ].join(' · ').keepWord,
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
                        style: textTheme.bodySmall?.copyWith(
                          color: foxtrotGold,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            if (order.isCancellable) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 36,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: foxtrotMuted,
                    textStyle: textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () => _cancelOrder(context, ref),
                  child: const Text('주문 취소'),
                ),
              ),
            ],
            if (_reviewable) ...[
              const SizedBox(height: 12),
              Container(height: 1, color: foxtrotBorder.withValues(alpha: 0.5)),
              for (final item in order.items)
                _ReviewItemRow(
                  orderId: order.id,
                  productId: item.beanId,
                  productType: ReviewProductType.bean,
                  productName: item.beanName,
                  optionLabel: item.optionLabel,
                ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _cancelOrder(BuildContext context, WidgetRef ref) async {
    final confirmed = await showOrderCancelDialog(
      context,
      title: '원두 주문을 취소할까요?',
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
      await ref.read(beanOrdersControllerProvider.notifier).cancelOrder(
            order.id,
          );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('주문이 취소되었어요. 사용한 쿠폰과 포인트는 복구됩니다.')),
        );
      }
    } on StateError catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.message)));
      }
    }
  }
}

class _PickupOrderCard extends ConsumerWidget {
  const _PickupOrderCard({required this.order});

  final PickupOrder order;

  bool get _reviewable => order.status == PickupOrderStatus.pickedUp;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final pointsSummary = [
      if (order.couponDiscount > 0)
        '쿠폰 -${_amountFormat.format(order.couponDiscount)}원',
      if (order.usedPoints > 0)
        '-${_amountFormat.format(order.usedPoints)}P 사용',
      if (order.earnedPoints > 0)
        '+${_amountFormat.format(order.earnedPoints)}P 적립',
    ].join(' · ');

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/profile/orders/track/${order.id}'),
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
                      LucideIcons.coffee,
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
                          order.summary.keepWord,
                          style: textTheme.labelLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _dateFormat.format(order.createdAt),
                          style: textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  _PickupStatusChip(status: order.status),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      '픽업 주문 · ${order.storeName} · 주문번호 ${order.pickupNumber}번 · 총 ${order.itemCount}개'
                          .keepWord,
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
                          style: textTheme.bodySmall?.copyWith(
                            color: foxtrotGold,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              if (order.status != PickupOrderStatus.pickedUp &&
                  !order.isCancelled) ...[
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '주문 현황 보기',
                      style: textTheme.bodySmall?.copyWith(
                        color: foxtrotGold,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Icon(
                      LucideIcons.chevronRight,
                      size: 14,
                      color: foxtrotGold,
                    ),
                  ],
                ),
              ],
              if (_reviewable) ...[
                const SizedBox(height: 12),
                Container(
                  height: 1,
                  color: foxtrotBorder.withValues(alpha: 0.5),
                ),
                for (final item in order.items)
                  _ReviewItemRow(
                    orderId: order.id,
                    productId: item.menuId,
                    productType: ReviewProductType.menu,
                    productName: item.menuName,
                    optionLabel: item.option,
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ReviewItemRow extends ConsumerWidget {
  const _ReviewItemRow({
    required this.orderId,
    required this.productId,
    required this.productType,
    required this.productName,
    this.optionLabel,
  });

  final String orderId;
  final String productId;
  final ReviewProductType productType;
  final String productName;
  final String? optionLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    ref.watch(myReviewsControllerProvider);
    final review = ref
        .read(myReviewsControllerProvider.notifier)
        .findReview(orderId: orderId, productId: productId);

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(productName.keepWord, style: textTheme.bodySmall),
                if (review != null && review.comment.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    '“${review.comment}”'.keepWord,
                    style: textTheme.bodySmall?.copyWith(color: foxtrotMuted),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 10),
          if (review != null)
            ReviewRatingStars(rating: review.rating)
          else
            SizedBox(
              height: 30,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  textStyle: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () => showReviewSheet(
                  context,
                  productId: productId,
                  productType: productType,
                  productName: optionLabel == null
                      ? productName
                      : '$productName ($optionLabel)',
                  orderId: orderId,
                ),
                icon: const Icon(LucideIcons.star, size: 13),
                label: const Text('리뷰 쓰기'),
              ),
            ),
        ],
      ),
    );
  }
}

class _PickupStatusChip extends StatelessWidget {
  const _PickupStatusChip({required this.status});

  final PickupOrderStatus status;

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
          color: status == PickupOrderStatus.cancelled
              ? foxtrotMuted
              : foxtrotGoldLight,
          fontWeight: FontWeight.w600,
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
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: status == BeanOrderStatus.cancelled
              ? foxtrotMuted
              : foxtrotGoldLight,
          fontWeight: FontWeight.w600,
        ),
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
