import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/text_utils.dart';
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

class _CheckoutBar extends ConsumerWidget {
  const _CheckoutBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(beanCartCountProvider);
    final total = ref.watch(beanCartTotalProvider);

    return Container(
      decoration: const BoxDecoration(
        color: foxtrotSurface,
        border: Border(top: BorderSide(color: foxtrotBorder)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
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
                      '${_priceFormat.format(total)}원',
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
                onPressed: () {
                  ref.read(beanCartProvider.notifier).clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('원두 주문이 접수되었습니다. 로스팅 후 순차 발송됩니다.'),
                    ),
                  );
                  context.pop();
                },
                icon: const Icon(LucideIcons.packageCheck, size: 18),
                label: const Text('주문하기'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
