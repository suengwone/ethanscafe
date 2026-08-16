import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/text_utils.dart';
import '../../../core/widgets/guest_signup_notice_card.dart';
import '../../auth/presentation/auth_providers.dart';
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
    final isMember = ref.watch(authStateProvider).value != null;

    return Scaffold(
      appBar: AppBar(title: const Text('픽업 주문')),
      body: items.isEmpty
          ? const _EmptyCart()
          : ListView(
              padding: foxtrotListPadding,
              children: [
                if (!isMember)
                  const GuestSignupNoticeCard(
                    message: '비회원으로도 주문할 수 있어요.\n회원가입하면 결제 금액의 10%가 포인트로 적립돼요.',
                  ),
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
      onPressed: () => context.push('/menu/cart'),
      tooltip: '픽업 장바구니',
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
                  color: foxtrotGold,
                  borderRadius: BorderRadius.circular(9),
                ),
                constraints: const BoxConstraints(minWidth: 16),
                child: Text(
                  '$count',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: foxtrotBlack,
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
          const Icon(LucideIcons.coffee, size: 48, color: foxtrotMuted),
          const SizedBox(height: 16),
          Text(
            '장바구니가 비어 있어요',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '메뉴에서 마시고 싶은 음료를 담아보세요.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 20),
          FilledButton.tonal(
            onPressed: () =>
                context.canPop() ? context.pop() : context.go('/menu'),
            child: const Text('메뉴 보러 가기'),
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
      backgroundColor: foxtrotCard,
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
                color: foxtrotSurface,
                borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
                border: Border.all(color: foxtrotBorder),
              ),
              child: const Icon(
                LucideIcons.store,
                color: foxtrotGold,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store == null ? '픽업 매장을 선택해 주세요' : store.name.keepWord,
                    style: textTheme.labelLarge,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    store == null
                        ? '주문 전에 픽업할 매장이 필요해요.'
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
              child: Text(store == null ? '매장 선택' : '변경'),
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
            Text('픽업 매장 선택', style: textTheme.titleMedium),
            const SizedBox(height: 4),
            Text('음료를 픽업할 매장을 선택해 주세요.', style: textTheme.bodySmall),
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

  final PickupCartItem item;
  final int index;

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
                        item.optionLabel ?? item.menuItem.category.label,
                        style: textTheme.bodySmall,
                      ),
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
        const SnackBar(content: Text('픽업 매장을 먼저 선택해 주세요.')),
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
            const SnackBar(content: Text('결제가 완료되지 않았습니다.')),
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
                ? '픽업 주문이 접수되었습니다. 주문번호 ${order.pickupNumber}번 · '
                    '${_priceFormat.format(order.earnedPoints)}P가 적립됐어요.'
                : '픽업 주문이 접수되었습니다. 주문번호 ${order.pickupNumber}번 · '
                    '준비가 끝나면 알려드릴게요.',
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

    final isMember = ref.watch(authStateProvider).value != null;

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
              if (isMember) ...[
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
              ] else
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      const Icon(
                        LucideIcons.userPlus,
                        size: 16,
                        color: foxtrotGold,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '포인트 적립·쿠폰은 회원가입 후 이용할 수 있어요.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
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
                        : () => _placeOrder(usedPoints, coupons, payAmount),
                    icon: Icon(
                      payAmount > 0
                          ? LucideIcons.creditCard
                          : LucideIcons.coffee,
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
