import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/text_utils.dart';
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
      appBar: AppBar(title: const Text('원두 장바구니')),
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
          const Icon(LucideIcons.shoppingBag, size: 48, color: foxtrotMuted),
          const SizedBox(height: 16),
          Text(
            '장바구니가 비어 있어요',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '마음에 드는 원두를 담아보세요.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 20),
          FilledButton.tonal(
            onPressed: () =>
                context.canPop() ? context.pop() : context.go('/menu'),
            child: const Text('원두 보러 가기'),
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
      backgroundColor: foxtrotCard,
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
      backgroundColor: foxtrotCard,
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
            Text('수령 방법', style: textTheme.labelLarge),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _MethodChip(
                    icon: LucideIcons.truck,
                    label: BeanFulfillmentMethod.delivery.label,
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
                    label: BeanFulfillmentMethod.pickup.label,
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
          color: foxtrotSurface,
          borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
          border: Border.all(color: selected ? foxtrotGold : foxtrotBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: selected ? foxtrotGold : foxtrotMuted,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: selected ? foxtrotGoldLight : foxtrotMuted,
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
        const Padding(
          padding: EdgeInsets.only(top: 2),
          child: Icon(LucideIcons.mapPin, size: 16, color: foxtrotGold),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: address == null
              ? Text(
                  '등록된 배송지가 없어요. 배송지를 추가해 주세요.',
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
                          ?.copyWith(color: foxtrotCream),
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
          child: Text(address == null ? '배송지 추가' : '변경'),
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
        const Padding(
          padding: EdgeInsets.only(top: 2),
          child: Icon(LucideIcons.store, size: 16, color: foxtrotGold),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: store == null
              ? Text(
                  '원두를 픽업할 매장을 선택해 주세요.',
                  style: textTheme.bodySmall,
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      store.name.keepWord,
                      style: textTheme.bodySmall
                          ?.copyWith(color: foxtrotCream),
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
          child: Text(store == null ? '매장 선택' : '변경'),
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
            Text('배송지 선택', style: textTheme.titleMedium),
            const SizedBox(height: 4),
            Text('원두를 받을 배송지를 선택해 주세요.', style: textTheme.bodySmall),
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
                      '배송지를 불러오지 못했습니다.',
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
              child: const Text('배송지 관리'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('닫기'),
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
        side: BorderSide(color: highlighted ? foxtrotGold : foxtrotBorder),
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
                color: highlighted ? foxtrotGold : foxtrotMuted,
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
                            '기본 배송지',
                            style: textTheme.bodySmall
                                ?.copyWith(color: foxtrotGoldLight),
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
            Text('픽업 매장 선택', style: textTheme.titleMedium),
            const SizedBox(height: 4),
            Text('로스팅이 끝나면 선택한 매장에서 픽업할 수 있어요.', style: textTheme.bodySmall),
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
                      '매장 정보를 불러오지 못했습니다.',
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
              child: const Text('닫기'),
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
        side: BorderSide(color: highlighted ? foxtrotGold : foxtrotBorder),
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
                color: highlighted ? foxtrotGold : foxtrotMuted,
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
          content: Text('${removed.bean.name}을(를) 장바구니에서 뺐어요.'),
          action: SnackBarAction(
            label: '실행취소',
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
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.bean.name.keepWord, style: textTheme.labelLarge),
                      const SizedBox(height: 3),
                      Text(item.optionLabel, style: textTheme.bodySmall),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _remove(context, ref),
                  icon: const Icon(LucideIcons.trash2, size: 18),
                  color: foxtrotMuted,
                  tooltip: '삭제',
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
                  '${_priceFormat.format(item.totalPrice)}원',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    letterSpacing: -0.3,
                    color: foxtrotCream,
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
          color: foxtrotSurface,
          borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
          border: Border.all(color: foxtrotBorder),
        ),
        child: Icon(
          icon,
          size: 16,
          color: enabled ? foxtrotGold : foxtrotMuted,
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

  String _orderName(List<BeanCartItem> items) => items.length == 1
      ? items.first.bean.name
      : '${items.first.bean.name} 외 ${items.length - 1}건';

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
        const SnackBar(content: Text('배송지를 먼저 등록해 주세요.')),
      );
      return;
    }
    if (method == BeanFulfillmentMethod.pickup && store == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('픽업 매장을 먼저 선택해 주세요.')),
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
            const SnackBar(content: Text('결제가 완료되지 않았습니다.')),
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
                ? '원두 주문이 접수되었습니다. ${_priceFormat.format(order.earnedPoints)}P가 적립됐어요.'
                : method == BeanFulfillmentMethod.pickup
                    ? '원두 주문이 접수되었습니다. 로스팅 후 매장에서 픽업하실 수 있어요.'
                    : '원두 주문이 접수되었습니다. 로스팅 후 순차 발송됩니다.',
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
        const SnackBar(content: Text('주문 처리에 실패했습니다. 다시 시도해 주세요.')),
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
      decoration: const BoxDecoration(
        color: foxtrotSurface,
        border: Border(top: BorderSide(color: foxtrotBorder)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(LucideIcons.ticket, size: 16, color: foxtrotGold),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      coupons.length > 1
                          ? '쿠폰 ${coupons.length}장 적용'
                          : coupons.isNotEmpty
                              ? coupons.first.title
                              : applicable.isEmpty
                                  ? '적용 가능한 쿠폰이 없어요'
                                  : '사용 가능한 쿠폰 ${applicable.length}장',
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (couponDiscount > 0)
                    Text(
                      '-${_priceFormat.format(couponDiscount)}원',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: foxtrotGold),
                    ),
                  TextButton(
                    onPressed: applicable.isEmpty || _submitting
                        ? null
                        : () => _selectCoupons(applicable, total),
                    child: Text(coupons.isEmpty ? '쿠폰 선택' : '변경'),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(LucideIcons.coins, size: 16, color: foxtrotGold),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      usablePoints > 0
                          ? '포인트 사용 (보유 ${_priceFormat.format(balance)}P)'
                          : '사용 가능한 포인트가 없어요',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  if (usedPoints > 0)
                    Text(
                      '-${_priceFormat.format(usedPoints)}P',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: foxtrotGold),
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
                          '총 $count개',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          '${_priceFormat.format(payAmount)}원',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: foxtrotGoldLight,
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
                          ? '주문 중...'
                          : payAmount > 0
                              ? '결제하기'
                              : '주문하기',
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
