import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/text_utils.dart';
import '../../../features/menu/presentation/menu_labels.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/presentation/login_required.dart';
import '../../coupon/domain/coupon_models.dart';
import '../../coupon/presentation/coupon_select_sheet.dart';
import '../../coupon/presentation/coupons_providers.dart';
import '../../menu/presentation/menu_detail_screen.dart';
import '../../payment/domain/payment_models.dart';
import '../../payment/presentation/payment_providers.dart';
import '../../points/presentation/points_providers.dart';
import '../../store/domain/store_models.dart';
import '../../store/presentation/stores_providers.dart';
import '../domain/pickup_cart_models.dart';
import 'pickup_cart_providers.dart';
import 'pickup_order_providers.dart';

final _priceFormat = NumberFormat('#,###');

class PickupCartScreen extends ConsumerWidget {
  const PickupCartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(pickupCartProvider);

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).pickupCartTitle)),
      body: items.isEmpty
          ? const _EmptyCart()
          : ListView(
              padding: foxtrotListPadding,
              children: [
                const _StoreCard(),
                const SizedBox(height: 4),
                ...List.generate(
                  items.length,
                  (index) => _CartItemCard(item: items[index], index: index),
                ),
              ],
            ),
      bottomNavigationBar: items.isEmpty ? null : const _CheckoutBar(),
    );
  }
}

class PickupCartButton extends ConsumerWidget {
  const PickupCartButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(pickupCartCountProvider);

    return IconButton(
      onPressed: () {
        if (!requireLogin(
          context,
          ref,
          message: AppLocalizations.of(context).pickupCartRequiresSignIn,
        )) {
          return;
        }
        context.push('/menu/cart');
      },
      tooltip: AppLocalizations.of(context).pickupCartTooltip,
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          const Icon(LucideIcons.shoppingBag, size: 22),
          if (count > 0)
            Positioned(
              top: -4,
              right: -6,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 1,
                ),
                decoration: BoxDecoration(
                  color: context.palette.accent,
                  borderRadius: BorderRadius.circular(9),
                ),
                constraints: const BoxConstraints(minWidth: 16),
                child: Text(
                  '$count',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: context.palette.onAccent,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.coffee, size: 48, color: context.palette.muted),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context).pickupCartEmptyTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context).pickupCartEmptyDetail,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 20),
          FilledButton.tonal(
            onPressed: () =>
                context.canPop() ? context.pop() : context.go('/menu'),
            child: Text(AppLocalizations.of(context).pickupCartBrowse),
          ),
        ],
      ),
    );
  }
}

class _StoreCard extends ConsumerWidget {
  const _StoreCard();

  Future<void> _selectStore(BuildContext context, WidgetRef ref) async {
    final store = await showModalBottomSheet<CafeStore>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.palette.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const _StoreSelectSheet(),
    );
    if (store == null) return;
    ref.read(pickupStoreProvider.notifier).select(store);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(pickupStoreProvider);
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: context.palette.surface,
                borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
                border: Border.all(color: context.palette.border),
              ),
              child: Icon(
                LucideIcons.store,
                color: context.palette.accent,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store == null
                        ? AppLocalizations.of(context).pickupCartChooseStorePrompt
                        : store.name.keepWord,
                    style: textTheme.labelLarge,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    store == null
                        ? AppLocalizations.of(context).pickupCartStoreRequired
                        : store.address.keepWord,
                    style: textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () => _selectStore(context, ref),
              child: Text(
                store == null ? AppLocalizations.of(context).beanCartChooseStore : AppLocalizations.of(context).beanCartChange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoreSelectSheet extends ConsumerWidget {
  const _StoreSelectSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storesState = ref.watch(storesProvider);
    final selected = ref.watch(pickupStoreProvider);
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          foxtrotScreenHPadding,
          20,
          foxtrotScreenHPadding,
          16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(AppLocalizations.of(context).beanCartStoreSheetTitle, style: textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(AppLocalizations.of(context).pickupCartStoreSheetDetail, style: textTheme.bodySmall),
            const SizedBox(height: 14),
            ...switch (storesState) {
              AsyncData(:final value) => value.map(
                  (store) => _StoreOptionCard(
                    store: store,
                    highlighted: store.id == selected?.id,
                    onTap: () => Navigator.pop(context, store),
                  ),
                ),
              AsyncError() => [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      AppLocalizations.of(context).beanCartStoreLoadFailed,
                      textAlign: TextAlign.center,
                      style: textTheme.bodySmall,
                    ),
                  ),
                ],
              _ => const [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ],
            },
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context).commonClose),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoreOptionCard extends StatelessWidget {
  const _StoreOptionCard({
    required this.store,
    required this.highlighted,
    required this.onTap,
  });

  final CafeStore store;
  final bool highlighted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
        side: BorderSide(color: highlighted ? context.palette.accent : context.palette.border),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Icon(
                LucideIcons.store,
                size: 20,
                color: highlighted ? context.palette.accent : context.palette.muted,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(store.name.keepWord, style: textTheme.labelLarge),
                    const SizedBox(height: 3),
                    Text(store.address.keepWord, style: textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CartItemCard extends ConsumerWidget {
  const _CartItemCard({required this.item, required this.index});

  final PickupCartItem item;
  final int index;

  /// 장바구니에서 실수로 지우는 일이 잦아 되돌릴 기회를 준다.
  void _remove(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(pickupCartProvider.notifier);
    final removed = item;
    notifier.removeAt(index);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).pickupCartRemoved(removed.menuItem.name)),
          action: SnackBarAction(
            label: AppLocalizations.of(context).beanCartUndo,
            onPressed: () => notifier.insertAt(index, removed),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final notifier = ref.read(pickupCartProvider.notifier);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MenuImageThumbnail(item: item.menuItem, size: 44),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.menuItem.name.keepWord,
                        style: textTheme.labelLarge,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.optionLabel ??
                            AppLocalizations.of(
                              context,
                            ).menuCategoryLabel(item.menuItem.category),
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _remove(context, ref),
                  icon: const Icon(LucideIcons.trash2, size: 18),
                  color: context.palette.muted,
                  tooltip: AppLocalizations.of(context).beanCartDelete,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _QuantityButton(
                  icon: LucideIcons.minus,
                  enabled: item.quantity > 1,
                  onTap: () =>
                      notifier.changeQuantity(index, item.quantity - 1),
                ),
                SizedBox(
                  width: 40,
                  child: Text(
                    '${item.quantity}',
                    textAlign: TextAlign.center,
                    style: textTheme.titleMedium,
                  ),
                ),
                _QuantityButton(
                  icon: LucideIcons.plus,
                  enabled: item.quantity < pickupCartMaxQuantity,
                  onTap: () =>
                      notifier.changeQuantity(index, item.quantity + 1),
                ),
                const Spacer(),
                Text(
                  AppLocalizations.of(context).priceWon(_priceFormat.format(item.totalPrice)),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    letterSpacing: -0.3,
                    color: context.palette.ink,
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

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
      onTap: enabled ? onTap : null,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: context.palette.surface,
          borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
          border: Border.all(color: context.palette.border),
        ),
        child: Icon(
          icon,
          size: 16,
          color: enabled ? context.palette.accent : context.palette.muted,
        ),
      ),
    );
  }
}

class _CheckoutBar extends ConsumerStatefulWidget {
  const _CheckoutBar();

  @override
  ConsumerState<_CheckoutBar> createState() => _CheckoutBarState();
}

class _CheckoutBarState extends ConsumerState<_CheckoutBar> {
  bool _usePoints = false;
  bool _submitting = false;
  List<Coupon> _coupons = const [];

  Future<void> _selectCoupons(List<Coupon> applicable, int total) async {
    final selection = await showCouponSelectSheet(
      context: context,
      coupons: applicable,
      selected: _coupons,
      orderAmount: total,
    );
    if (selection == null || !mounted) {
      return;
    }
    setState(() => _coupons = selection);
  }

  String _orderName(List<PickupCartItem> items) => items.length == 1
      ? items.first.menuItem.name
      : '${items.first.menuItem.name} 외 ${items.length - 1}건';

  Future<void> _placeOrder(
    int usedPoints,
    List<Coupon> coupons,
    int payAmount,
  ) async {
    final store = ref.read(pickupStoreProvider);
    if (store == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).beanCartNeedStore)),
      );
      return;
    }

    final items = ref.read(pickupCartProvider);
    setState(() => _submitting = true);
    try {
      PaymentApproval? payment;
      if (payAmount > 0) {
        payment = await ref.read(paymentGatewayProvider).pay(
              context,
              PaymentRequest(
                orderId: generatePaymentOrderId(),
                orderName: _orderName(items),
                amount: payAmount,
              ),
            );
        if (payment == null) {
          if (!mounted) {
            return;
          }
          setState(() => _submitting = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context).beanCartPaymentIncomplete)),
          );
          return;
        }
      }

      final order = await ref
          .read(pickupOrdersControllerProvider.notifier)
          .placeOrder(
            cartItems: items,
            store: store,
            usedPoints: usedPoints,
            coupons: coupons,
            payment: payment,
          );
      if (!mounted) {
        return;
      }
      ref.read(pickupCartProvider.notifier).clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            order.earnedPoints > 0
                ? AppLocalizations.of(context).pickupCartOrderedWithPoints(
                    order.pickupNumber,
                    _priceFormat.format(order.earnedPoints),
                  )
                : AppLocalizations.of(context).pickupCartOrdered(order.pickupNumber),
          ),
        ),
      );
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/menu');
      }
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).beanCartOrderFailed)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final count = ref.watch(pickupCartCountProvider);
    final total = ref.watch(pickupCartTotalProvider);
    final balance = ref.watch(pointsControllerProvider).value?.balance ?? 0;
    final allCoupons =
        ref.watch(couponsControllerProvider).value ?? const <Coupon>[];
    final now = ref.watch(couponNowProvider);
    final applicable = allCoupons
        .where((coupon) => coupon.canApplyTo(orderAmount: total, now: now))
        .toList();
    final coupons = _coupons
        .where(
          (coupon) =>
              applicable.any((candidate) => candidate.id == coupon.id),
        )
        .toList();
    final couponDiscount = totalCouponDiscount(coupons, total);
    final usablePoints = balance.clamp(0, total - couponDiscount);
    final usedPoints = _usePoints ? usablePoints : 0;
    final payAmount = total - couponDiscount - usedPoints;


    return Container(
      decoration: BoxDecoration(
        color: context.palette.surface,
        border: Border(top: BorderSide(color: context.palette.border)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(LucideIcons.ticket, size: 16, color: context.palette.accent),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      coupons.length > 1
                          ? AppLocalizations.of(context).beanCartCouponsApplied(coupons.length)
                          : coupons.isNotEmpty
                              ? coupons.first.title
                              : applicable.isEmpty
                                ? AppLocalizations.of(context).beanCartNoUsableCoupons
                                : AppLocalizations.of(context).beanCartUsableCoupons(applicable.length),
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (couponDiscount > 0)
                    Text(
                      AppLocalizations.of(context).discountAmount(_priceFormat.format(couponDiscount)),
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: context.palette.accent),
                    ),
                  TextButton(
                    onPressed: applicable.isEmpty || _submitting
                        ? null
                        : () => _selectCoupons(applicable, total),
                    child: Text(
                      coupons.isEmpty
                          ? AppLocalizations.of(context).beanCartChooseCoupon
                          : AppLocalizations.of(context).beanCartChange,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(LucideIcons.coins, size: 16, color: context.palette.accent),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      usablePoints > 0
                        ? AppLocalizations.of(context).beanCartUsePoints(_priceFormat.format(balance))
                        : AppLocalizations.of(context).beanCartNoPoints,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  if (usedPoints > 0)
                    Text(
                      '-${_priceFormat.format(usedPoints)}P',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: context.palette.accent),
                    ),
                  Switch(
                    value: _usePoints,
                    onChanged: usablePoints > 0 && !_submitting
                        ? (value) => setState(() => _usePoints = value)
                        : null,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppLocalizations.of(context).beanCartItemCount(count),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          AppLocalizations.of(context).priceWon(_priceFormat.format(payAmount)),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: context.palette.accentSoft,
                          ),
                        ),
                      ],
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: _submitting
                        ? null
                        : () => _placeOrder(usedPoints, coupons, payAmount),
                    icon: Icon(
                      payAmount > 0
                          ? LucideIcons.creditCard
                          : LucideIcons.coffee,
                      size: 18,
                    ),
                    label: Text(
                      _submitting
                        ? AppLocalizations.of(context).beanCartOrdering
                        : payAmount > 0
                        ? AppLocalizations.of(context).beanCartPay
                        : AppLocalizations.of(context).beanCartOrder,
                    ),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
