import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/l10n/summary_labels.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/text_utils.dart';
import '../../../core/widgets/order_cancel_dialog.dart';
import '../../../features/beans/presentation/bean_labels.dart';
import '../../../features/order/presentation/order_labels.dart';
import '../../../features/pickup/presentation/pickup_labels.dart';
import '../../../l10n/app_localizations.dart';
import '../../beans/presentation/bean_cart_providers.dart';
import '../../beans/presentation/beans_providers.dart';
import '../../menu/presentation/menu_providers.dart';
import '../../pickup/domain/pickup_order_models.dart';
import '../../pickup/presentation/pickup_cart_providers.dart';
import '../../pickup/presentation/pickup_order_providers.dart';
import '../../points/domain/points_models.dart';
import '../../points/presentation/points_providers.dart';
import '../../review/domain/review_models.dart';
import '../../review/presentation/review_providers.dart';
import '../../review/presentation/review_sheet.dart';
import '../domain/order_models.dart';
import '../domain/refund_status.dart';
import '../domain/reorder.dart';
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
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).orderHistoryTitle),
      ),
      body: ordersState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(AppLocalizations.of(context).orderHistoryLoadFailed),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.invalidate(orderHistoryProvider),
                child: Text(AppLocalizations.of(context).retry),
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
                PickupOrderRecord(:final order) => _PickupOrderCard(
                  order: order,
                ),
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
          Icon(LucideIcons.receiptText, size: 48, color: context.palette.muted),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context).orderHistoryEmptyTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context).orderHistoryEmptyDetail,
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
        AppLocalizations.of(
          context,
        ).orderCouponDiscount(_amountFormat.format(order.couponDiscount)),
      if (order.usedPoints > 0)
        AppLocalizations.of(
          context,
        ).orderPointsUsed(_amountFormat.format(order.usedPoints)),
      if (order.earnedPoints > 0)
        AppLocalizations.of(
          context,
        ).orderPointsEarned(_amountFormat.format(order.earnedPoints)),
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
                    color: context.palette.surface,
                    borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
                    border: Border.all(color: context.palette.border),
                  ),
                  child: Icon(
                    LucideIcons.bean,
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
                        AppLocalizations.of(context)
                            .itemsSummary(
                              order.firstItemName,
                              order.items.length,
                            )
                            .keepWord,
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
                _StatusChip(status: order.status, refund: order.refundStatus),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    [
                      AppLocalizations.of(context).orderBeanLabel,
                      order.fulfillmentMethod == BeanFulfillmentMethod.pickup &&
                              order.storeName != null
                          ? '${AppLocalizations.of(context).fulfillmentLabel(order.fulfillmentMethod)} · '
                                '${order.storeName}'
                          : AppLocalizations.of(
                              context,
                            ).fulfillmentLabel(order.fulfillmentMethod),
                      if (order.paymentMethod != null) order.paymentMethod!,
                      AppLocalizations.of(
                        context,
                      ).orderItemCount(order.itemCount),
                    ].join(' · ').keepWord,
                    style: textTheme.bodySmall,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      AppLocalizations.of(
                        context,
                      ).priceWon(_amountFormat.format(order.paidAmount)),
                      style: textTheme.labelLarge,
                    ),
                    if (pointsSummary.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        pointsSummary,
                        style: textTheme.bodySmall?.copyWith(
                          color: context.palette.accent,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 36,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: context.palette.accentSoft,
                  textStyle: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () => _reorder(context, ref),
                icon: const Icon(LucideIcons.rotateCcw, size: 13),
                label: Text(AppLocalizations.of(context).orderReorder),
              ),
            ),
            if (order.isCancellable) ...[
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 36,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: context.palette.muted,
                    textStyle: textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () => _cancelOrder(context, ref),
                  child: Text(AppLocalizations.of(context).orderCancel),
                ),
              ),
            ],
            if (_reviewable) ...[
              const SizedBox(height: 12),
              Container(
                height: 1,
                color: context.palette.border.withValues(alpha: 0.5),
              ),
              for (final item in order.items)
                _ReviewItemRow(
                  orderId: order.id,
                  productId: item.beanId,
                  productType: ReviewProductType.bean,
                  productName: item.beanName,
                  optionLabel: AppLocalizations.of(
                    context,
                  ).beanOption(item.weight, item.grind),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _reorder(BuildContext context, WidgetRef ref) async {
    final beans = await ref.read(beansProvider.future);
    if (!context.mounted) {
      return;
    }
    final result = buildBeanReorder(order: order, beans: beans);
    if (!result.hasItems) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).orderReorderUnavailableBeans,
          ),
        ),
      );
      return;
    }
    final notifier = ref.read(beanCartProvider.notifier);
    for (final item in result.items) {
      notifier.add(
        bean: item.bean,
        weight: item.weight,
        grind: item.grind,
        quantity: item.quantity,
      );
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result.hasMissing
              ? AppLocalizations.of(
                  context,
                ).orderReorderPartialBeans(result.missingNames.join(', '))
              : AppLocalizations.of(context).orderReorderDone,
        ),
      ),
    );
    context.go('/menu/beans-cart');
  }

  Future<void> _cancelOrder(BuildContext context, WidgetRef ref) async {
    final confirmed = await showOrderCancelDialog(
      context,
      title: AppLocalizations.of(context).orderCancelBeanTitle,
      refundSummary: orderCancelRefundSummary(
        AppLocalizations.of(context),
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
          .read(beanOrdersControllerProvider.notifier)
          .cancelOrder(order.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).orderCancelledNotice),
          ),
        );
      }
    } on StateError catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
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
        AppLocalizations.of(
          context,
        ).orderCouponDiscount(_amountFormat.format(order.couponDiscount)),
      if (order.usedPoints > 0)
        AppLocalizations.of(
          context,
        ).orderPointsUsed(_amountFormat.format(order.usedPoints)),
      if (order.earnedPoints > 0)
        AppLocalizations.of(
          context,
        ).orderPointsEarned(_amountFormat.format(order.earnedPoints)),
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
                      color: context.palette.surface,
                      borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
                      border: Border.all(color: context.palette.border),
                    ),
                    child: Icon(
                      LucideIcons.coffee,
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
                          AppLocalizations.of(context)
                              .itemsSummary(
                                order.firstItemName,
                                order.items.length,
                              )
                              .keepWord,
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
                  _PickupStatusChip(
                    status: order.status,
                    refund: order.refundStatus,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)
                          .orderPickupSummary(
                            order.storeName,
                            order.pickupNumber,
                            order.itemCount,
                          )
                          .keepWord,
                      style: textTheme.bodySmall,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        AppLocalizations.of(
                          context,
                        ).priceWon(_amountFormat.format(order.paidAmount)),
                        style: textTheme.labelLarge,
                      ),
                      if (pointsSummary.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          pointsSummary,
                          style: textTheme.bodySmall?.copyWith(
                            color: context.palette.accent,
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
                      AppLocalizations.of(context).orderTrackStatus,
                      style: textTheme.bodySmall?.copyWith(
                        color: context.palette.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(
                      LucideIcons.chevronRight,
                      size: 14,
                      color: context.palette.accent,
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 36,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: context.palette.accentSoft,
                    textStyle: textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () => _reorder(context, ref),
                  icon: const Icon(LucideIcons.rotateCcw, size: 13),
                  label: Text(AppLocalizations.of(context).orderReorder),
                ),
              ),
              if (_reviewable) ...[
                const SizedBox(height: 12),
                Container(
                  height: 1,
                  color: context.palette.border.withValues(alpha: 0.5),
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

  Future<void> _reorder(BuildContext context, WidgetRef ref) async {
    final menuItems = await ref.read(menuItemsProvider.future);
    if (!context.mounted) {
      return;
    }
    final result = buildPickupReorder(order: order, menuItems: menuItems);
    if (!result.hasItems) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).orderReorderUnavailableMenu,
          ),
        ),
      );
      return;
    }
    final notifier = ref.read(pickupCartProvider.notifier);
    for (final item in result.items) {
      notifier.add(
        menuItem: item.menuItem,
        option: item.option,
        quantity: item.quantity,
      );
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result.hasMissing
              ? AppLocalizations.of(
                  context,
                ).orderReorderPartialMenu(result.missingNames.join(', '))
              : AppLocalizations.of(context).orderReorderDone,
        ),
      ),
    );
    context.go('/menu/cart');
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
                    style: textTheme.bodySmall?.copyWith(
                      color: context.palette.muted,
                    ),
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
                label: Text(AppLocalizations.of(context).orderWriteReview),
              ),
            ),
        ],
      ),
    );
  }
}

class _PickupStatusChip extends StatelessWidget {
  const _PickupStatusChip({required this.status, this.refund});

  final PickupOrderStatus status;
  final RefundStatus? refund;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
        border: Border.all(color: context.palette.border),
      ),
      child: Text(
        status == PickupOrderStatus.cancelled
            ? refundLabelFor(
                l10n.pickupStatusLabel(status),
                refund,
                l10n.refundStatusLabel,
              )
            : l10n.pickupStatusLabel(status),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: status == PickupOrderStatus.cancelled
              ? context.palette.muted
              : context.palette.accentSoft,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status, this.refund});

  final BeanOrderStatus status;
  final RefundStatus? refund;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
        border: Border.all(color: context.palette.border),
      ),
      child: Text(
        status == BeanOrderStatus.cancelled
            ? refundLabelFor(
                l10n.beanOrderStatusLabel(status),
                refund,
                l10n.refundStatusLabel,
              )
            : l10n.beanOrderStatusLabel(status),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: status == BeanOrderStatus.cancelled
              ? context.palette.muted
              : context.palette.accentSoft,
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
                color: context.palette.surface,
                borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
                border: Border.all(color: context.palette.border),
              ),
              child: Icon(
                LucideIcons.receiptText,
                color: context.palette.accent,
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
                  AppLocalizations.of(
                    context,
                  ).priceWon(_amountFormat.format(paymentAmount)),
                  style: textTheme.labelLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  AppLocalizations.of(
                    context,
                  ).orderPointsEarned(_amountFormat.format(entry.amount)),
                  style: textTheme.bodySmall?.copyWith(
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
