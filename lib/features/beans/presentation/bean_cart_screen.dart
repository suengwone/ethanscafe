import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/text_utils.dart';
import '../../coupon/domain/coupon_models.dart';
import '../../coupon/presentation/coupons_providers.dart';
import '../../order/presentation/order_providers.dart';
import '../../payment/domain/payment_models.dart';
import '../../payment/presentation/payment_providers.dart';
import '../../points/presentation/points_providers.dart';
import '../domain/bean_cart_models.dart';
import 'bean_cart_providers.dart';

final _priceFormat = NumberFormat('#,###');

class BeanCartScreen extends ConsumerWidget {
  const BeanCartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(beanCartProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('원두 장바구니')),
      body: items.isEmpty
          ? const _EmptyCart()
          : ListView.builder(
              padding: foxtrotListPadding,
              itemCount: items.length,
              itemBuilder: (context, index) =>
                  _CartItemCard(item: items[index], index: index),
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
            onPressed: () => context.pop(),
            child: const Text('원두 보러 가기'),
          ),
        ],
      ),
    );
  }
}

class _CartItemCard extends ConsumerWidget {
  const _CartItemCard({required this.item, required this.index});

  final BeanCartItem item;
  final int index;

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
                  onPressed: () => notifier.removeAt(index),
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

class _CouponChoice {
  const _CouponChoice(this.coupon);

  final Coupon? coupon;
}

class _CouponSelectSheet extends StatelessWidget {
  const _CouponSelectSheet({
    required this.coupons,
    required this.selected,
    required this.orderAmount,
  });

  final List<Coupon> coupons;
  final Coupon? selected;
  final int orderAmount;

  @override
  Widget build(BuildContext context) {
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
            Text('쿠폰 선택', style: textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              '주문 금액에 맞는 쿠폰 1장을 적용할 수 있어요.',
              style: textTheme.bodySmall,
            ),
            const SizedBox(height: 14),
            _CouponOptionCard(
              title: '쿠폰 적용 안함',
              highlighted: selected == null,
              onTap: () =>
                  Navigator.pop(context, const _CouponChoice(null)),
            ),
            ...coupons.map(
              (coupon) => _CouponOptionCard(
                title: coupon.title,
                description: coupon.description,
                trailing: '-${_priceFormat.format(
                  coupon.discountFor(orderAmount),
                )}원',
                highlighted: coupon.id == selected?.id,
                onTap: () =>
                    Navigator.pop(context, _CouponChoice(coupon)),
              ),
            ),
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

class _CouponOptionCard extends StatelessWidget {
  const _CouponOptionCard({
    required this.title,
    this.description,
    this.trailing,
    required this.highlighted,
    required this.onTap,
  });

  final String title;
  final String? description;
  final String? trailing;
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
        side: BorderSide(
          color: highlighted ? foxtrotGold : foxtrotBorder,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Icon(
                LucideIcons.ticket,
                size: 20,
                color: highlighted ? foxtrotGold : foxtrotMuted,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title.keepWord, style: textTheme.labelLarge),
                    if (description != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        description!.keepWord,
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 10),
                Text(
                  trailing!,
                  style: textTheme.labelLarge?.copyWith(color: foxtrotGold),
                ),
              ],
            ],
          ),
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
  Coupon? _coupon;

  Future<void> _selectCoupon(List<Coupon> applicable, int total) async {
    final selection = await showModalBottomSheet<_CouponChoice>(
      context: context,
      isScrollControlled: true,
      backgroundColor: foxtrotCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _CouponSelectSheet(
        coupons: applicable,
        selected: _coupon,
        orderAmount: total,
      ),
    );
    if (selection == null || !mounted) {
      return;
    }
    setState(() => _coupon = selection.coupon);
  }

  String _orderName(List<BeanCartItem> items) => items.length == 1
      ? items.first.bean.name
      : '${items.first.bean.name} 외 ${items.length - 1}건';

  Future<void> _placeOrder(
    int usedPoints,
    Coupon? coupon,
    int payAmount,
  ) async {
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
            coupon: coupon,
            payment: payment,
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
                : '원두 주문이 접수되었습니다. 로스팅 후 순차 발송됩니다.',
          ),
        ),
      );
      context.pop();
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
    final balance =
        ref.watch(pointsControllerProvider).value?.balance ?? 0;
    final coupons =
        ref.watch(couponsControllerProvider).value ?? const <Coupon>[];
    final now = ref.watch(couponNowProvider);
    final applicable = coupons
        .where((coupon) => coupon.canApplyTo(orderAmount: total, now: now))
        .toList();
    final selected = _coupon;
    final coupon = selected != null &&
            applicable.any((candidate) => candidate.id == selected.id)
        ? selected
        : null;
    final couponDiscount = coupon?.discountFor(total) ?? 0;
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
                      coupon != null
                          ? coupon.title
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
                        : () => _selectCoupon(applicable, total),
                    child: Text(coupon == null ? '쿠폰 선택' : '변경'),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(LucideIcons.coins, size: 16, color: foxtrotGold),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '보유 포인트 ${_priceFormat.format(balance)}P',
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
                        : () => _placeOrder(usedPoints, coupon, payAmount),
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
