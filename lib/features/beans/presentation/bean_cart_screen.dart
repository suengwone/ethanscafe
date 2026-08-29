import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/text_utils.dart';
import '../../../features/beans/presentation/bean_labels.dart';
import '../../../features/order/presentation/order_labels.dart';
import '../../../l10n/app_localizations.dart';
import '../../coupon/domain/coupon_models.dart';
import '../../coupon/presentation/coupon_select_sheet.dart';
import '../../coupon/presentation/coupons_providers.dart';
import '../../order/domain/order_models.dart';
import '../../order/presentation/order_providers.dart';
import '../../payment/domain/payment_models.dart';
import '../../payment/presentation/payment_providers.dart';
import '../../points/presentation/points_providers.dart';
import '../../profile/domain/delivery_address.dart';
import '../../profile/presentation/delivery_address_screen.dart';
import '../../store/domain/store_models.dart';
import '../../store/presentation/stores_providers.dart';
import '../domain/bean_cart_models.dart';
import 'bean_cart_providers.dart';

final _priceFormat = NumberFormat('#,###');

DeliveryAddress? _effectiveDeliveryAddress(WidgetRef ref) {
  final selected = ref.watch(beanDeliveryAddressProvider);
  final addresses =
      ref.watch(deliveryAddressesProvider).value ?? const <DeliveryAddress>[];
  if (selected != null &&
      addresses.any((address) => address.id == selected.id)) {
    return selected;
  }
  if (addresses.isEmpty) {
    return null;
  }
  return addresses.firstWhere(
    (address) => address.isDefault,
    orElse: () => addresses.first,
  );
}

String _fullAddress(DeliveryAddress address) => address.address2.isEmpty
    ? address.address1
    : '${address.address1} ${address.address2}';

class BeanCartScreen extends ConsumerWidget {
  const BeanCartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(beanCartProvider);

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).beanCartTitle)),
      body: items.isEmpty
          ? const _EmptyCart()
          : ListView(
              padding: foxtrotListPadding,
              children: [
                const _FulfillmentCard(),
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

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.shoppingBag, size: 48, color: context.palette.muted),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context).beanCartEmptyTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context).beanCartEmptyDetail,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 20),
          FilledButton.tonal(
            onPressed: () =>
                context.canPop() ? context.pop() : context.go('/menu'),
            child: Text(AppLocalizations.of(context).beanCartBrowse),
          ),
        ],
      ),
    );
  }
}

class _FulfillmentCard extends ConsumerWidget {
  const _FulfillmentCard();

  Future<void> _selectAddress(BuildContext context, WidgetRef ref) async {
    final address = await showModalBottomSheet<DeliveryAddress>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.palette.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _AddressSelectSheet(
        selected: _effectiveDeliveryAddress(ref),
      ),
    );
    if (address == null) return;
    ref.read(beanDeliveryAddressProvider.notifier).select(address);
  }

  Future<void> _selectStore(BuildContext context, WidgetRef ref) async {
    final store = await showModalBottomSheet<CafeStore>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.palette.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const _BeanStoreSelectSheet(),
    );
    if (store == null) return;
    ref.read(beanPickupStoreProvider.notifier).select(store);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final method = ref.watch(beanFulfillmentMethodProvider);
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context).beanCartFulfillment, style: textTheme.labelLarge),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _MethodChip(
                    icon: LucideIcons.truck,
                    label: AppLocalizations.of(context).fulfillmentLabel(
                      BeanFulfillmentMethod.delivery,
                    ),
                    selected: method == BeanFulfillmentMethod.delivery,
                    onTap: () => ref
                        .read(beanFulfillmentMethodProvider.notifier)
                        .select(BeanFulfillmentMethod.delivery),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _MethodChip(
                    icon: LucideIcons.store,
                    label: AppLocalizations.of(context).fulfillmentLabel(BeanFulfillmentMethod.pickup),
                    selected: method == BeanFulfillmentMethod.pickup,
                    onTap: () => ref
                        .read(beanFulfillmentMethodProvider.notifier)
                        .select(BeanFulfillmentMethod.pickup),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (method == BeanFulfillmentMethod.delivery)
              _DeliverySummaryRow(
                onChange: () => _selectAddress(context, ref),
              )
            else
              _PickupSummaryRow(
                onChange: () => _selectStore(context, ref),
              ),
          ],
        ),
      ),
    );
  }
}

class _MethodChip extends StatelessWidget {
  const _MethodChip({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: context.palette.surface,
          borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
          border: Border.all(color: selected ? context.palette.accent : context.palette.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: selected ? context.palette.accent : context.palette.muted,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: selected ? context.palette.accentSoft : context.palette.muted,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeliverySummaryRow extends ConsumerWidget {
  const _DeliverySummaryRow({required this.onChange});

  final VoidCallback onChange;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final address = _effectiveDeliveryAddress(ref);
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 2),
          child: Icon(LucideIcons.mapPin, size: 16, color: context.palette.accent),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: address == null
              ? Text(
                  AppLocalizations.of(context).beanCartNoAddress,
                  style: textTheme.bodySmall,
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${address.label} · ${address.recipient} · ${address.phone}',
                      style: textTheme.bodySmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _fullAddress(address).keepWord,
                      style: textTheme.bodySmall
                          ?.copyWith(color: context.palette.ink),
                    ),
                  ],
                ),
        ),
        TextButton(
          onPressed: address == null
              ? () => context.push('/profile/addresses')
              : onChange,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            minimumSize: const Size(0, 32),
          ),
          child: Text(
            address == null ? AppLocalizations.of(context).beanCartAddAddress : AppLocalizations.of(context).beanCartChange,
          ),
        ),
      ],
    );
  }
}

class _PickupSummaryRow extends ConsumerWidget {
  const _PickupSummaryRow({required this.onChange});

  final VoidCallback onChange;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(beanPickupStoreProvider);
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 2),
          child: Icon(LucideIcons.store, size: 16, color: context.palette.accent),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: store == null
              ? Text(
                  AppLocalizations.of(context).beanCartNoStore,
                  style: textTheme.bodySmall,
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      store.name.keepWord,
                      style: textTheme.bodySmall
                          ?.copyWith(color: context.palette.ink),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      store.address.keepWord,
                      style: textTheme.bodySmall,
                    ),
                  ],
                ),
        ),
        TextButton(
          onPressed: onChange,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            minimumSize: const Size(0, 32),
          ),
          child: Text(
            store == null ? AppLocalizations.of(context).beanCartChooseStore : AppLocalizations.of(context).beanCartChange,
          ),
        ),
      ],
    );
  }
}

class _AddressSelectSheet extends ConsumerWidget {
  const _AddressSelectSheet({this.selected});

  final DeliveryAddress? selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressesState = ref.watch(deliveryAddressesProvider);
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
            Text(AppLocalizations.of(context).beanCartAddressSheetTitle, style: textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(AppLocalizations.of(context).beanCartAddressSheetDetail, style: textTheme.bodySmall),
            const SizedBox(height: 14),
            ...switch (addressesState) {
              AsyncData(:final value) => value.map(
                  (address) => _AddressOptionCard(
                    address: address,
                    highlighted: address.id == selected?.id,
                    onTap: () => Navigator.pop(context, address),
                  ),
                ),
              AsyncError() => [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      AppLocalizations.of(context).beanCartAddressLoadFailed,
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
              onPressed: () {
                Navigator.pop(context);
                context.push('/profile/addresses');
              },
              child: Text(AppLocalizations.of(context).beanCartManageAddresses),
            ),
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

class _AddressOptionCard extends StatelessWidget {
  const _AddressOptionCard({
    required this.address,
    required this.highlighted,
    required this.onTap,
  });

  final DeliveryAddress address;
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
                address.label == '회사'
                    ? LucideIcons.building2
                    : LucideIcons.house,
                size: 20,
                color: highlighted ? context.palette.accent : context.palette.muted,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(address.label, style: textTheme.labelLarge),
                        if (address.isDefault) ...[
                          const SizedBox(width: 8),
                          Text(
                            AppLocalizations.of(context).beanCartDefaultAddress,
                            style: textTheme.bodySmall
                                ?.copyWith(color: context.palette.accentSoft),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${address.recipient} · ${address.phone}',
                      style: textTheme.bodySmall,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _fullAddress(address).keepWord,
                      style: textTheme.bodySmall,
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
}

class _BeanStoreSelectSheet extends ConsumerWidget {
  const _BeanStoreSelectSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storesState = ref.watch(storesProvider);
    final selected = ref.watch(beanPickupStoreProvider);
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
            Text(AppLocalizations.of(context).beanCartStoreSheetDetail, style: textTheme.bodySmall),
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

  final BeanCartItem item;
  final int index;

  /// 장바구니에서 실수로 지우는 일이 잦아 되돌릴 기회를 준다.
  void _remove(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(beanCartProvider.notifier);
    final removed = item;
    notifier.removeAt(index);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).beanCartRemoved(removed.bean.name)),
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
    final notifier = ref.read(beanCartProvider.notifier);

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
                Container(
                  width: 44,
                  height: 44,
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
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.bean.name.keepWord, style: textTheme.labelLarge),
                      const SizedBox(height: 3),
                      Text(
                        AppLocalizations.of(context).beanOption(item.weight, item.grind),
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
                  onTap: () => notifier.changeQuantity(index, item.quantity - 1),
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
                  enabled: item.quantity < beanCartMaxQuantity,
                  onTap: () => notifier.changeQuantity(index, item.quantity + 1),
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

  String _orderName(AppLocalizations l10n, List<BeanCartItem> items) =>
      items.length == 1
      ? items.first.bean.name
      : l10n.orderItemsSummary(items.first.bean.name, items.length - 1);

  Future<void> _placeOrder(
    int usedPoints,
    List<Coupon> coupons,
    int payAmount,
    BeanFulfillmentMethod method,
    DeliveryAddress? address,
    CafeStore? store,
  ) async {
    if (method == BeanFulfillmentMethod.delivery && address == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).beanCartNeedAddress)),
      );
      return;
    }
    if (method == BeanFulfillmentMethod.pickup && store == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).beanCartNeedStore)),
      );
      return;
    }

    final items = ref.read(beanCartProvider);
    setState(() => _submitting = true);
    try {
      PaymentApproval? payment;
      if (payAmount > 0) {
        payment = await ref.read(paymentGatewayProvider).pay(
              context,
              PaymentRequest(
                orderId: generatePaymentOrderId(),
                orderName: _orderName(AppLocalizations.of(context), items),
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
          .read(beanOrdersControllerProvider.notifier)
          .placeOrder(
            cartItems: items,
            usedPoints: usedPoints,
            coupons: coupons,
            payment: payment,
            fulfillmentMethod: method,
            deliveryAddress: address,
            pickupStore: store,
          );
      if (!mounted) {
        return;
      }
      ref.read(beanCartProvider.notifier).clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            order.earnedPoints > 0
                ? AppLocalizations.of(context).beanCartOrderedWithPoints(
                    _priceFormat.format(order.earnedPoints),
                  )
                : method == BeanFulfillmentMethod.pickup
                ? AppLocalizations.of(context).beanCartOrderedPickup
                : AppLocalizations.of(context).beanCartOrderedDelivery,
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
    final count = ref.watch(beanCartCountProvider);
    final total = ref.watch(beanCartTotalProvider);
    final method = ref.watch(beanFulfillmentMethodProvider);
    final address = _effectiveDeliveryAddress(ref);
    final store = ref.watch(beanPickupStoreProvider);
    final balance =
        ref.watch(pointsControllerProvider).value?.balance ?? 0;
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
                        : () => _placeOrder(
                              usedPoints,
                              coupons,
                              payAmount,
                              method,
                              address,
                              store,
                            ),
                    icon: Icon(
                      payAmount > 0
                          ? LucideIcons.creditCard
                          : LucideIcons.packageCheck,
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
