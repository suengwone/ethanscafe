import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/text_utils.dart';
import '../../../core/widgets/new_badge.dart';
import '../../auth/presentation/login_required.dart';
import '../../review/presentation/product_review_section.dart';
import '../../subscription/presentation/bean_subscribe_sheet.dart';
import '../domain/bean_models.dart';
import 'bean_cart_providers.dart';
import 'beans_providers.dart';

final _priceFormat = NumberFormat('#,###');

class BeanDetailScreen extends ConsumerWidget {
  const BeanDetailScreen({super.key, required this.beanId});

  final String beanId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final beanState = ref.watch(beanProvider(beanId));
    final bean = beanState.asData?.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('원두 상세'),
        actions: const [BeanCartButton(), SizedBox(width: 4)],
      ),
      body: beanState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('원두 정보를 불러오지 못했습니다.'),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.invalidate(beanProvider(beanId)),
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
        data: (bean) => _BeanDetailBody(bean: bean),
      ),
      bottomNavigationBar: bean == null ? null : _OrderBar(bean: bean),
    );
  }
}

class _BeanDetailBody extends StatelessWidget {
  const _BeanDetailBody({required this.bean});

  final Bean bean;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        foxtrotScreenHPadding,
        16,
        foxtrotScreenHPadding,
        24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _HeaderSection(bean: bean),
          const SizedBox(height: 16),
          _TastingNotesSection(bean: bean),
          const SizedBox(height: 16),
          _FlavorProfileSection(bean: bean),
          const SizedBox(height: 16),
          _StorySection(bean: bean),
          const SizedBox(height: 16),
          _InfoSection(bean: bean),
          const SizedBox(height: 16),
          ProductReviewSection(productId: bean.id),
        ],
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({required this.bean});

  final Bean bean;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: context.palette.surface,
                shape: BoxShape.circle,
                border: Border.all(color: context.palette.accent, width: 1.5),
              ),
              child: Icon(
                LucideIcons.bean,
                color: context.palette.accent,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    bean.name.keepWord,
                    style: textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
                if (bean.isNew) ...[
                  const SizedBox(width: 8),
                  const NewBadge(),
                ],
              ],
            ),
            const SizedBox(height: 6),
            Text(
              bean.description.keepWord,
              style: textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _InfoChip(icon: LucideIcons.mapPin, label: bean.origin),
                _InfoChip(
                  icon: LucideIcons.flame,
                  label: '${bean.roastLevel.label} 로스팅',
                ),
                _InfoChip(icon: LucideIcons.droplets, label: bean.process),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
        border: Border.all(color: context.palette.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: context.palette.accent),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: context.palette.ink),
          ),
        ],
      ),
    );
  }
}

class _TastingNotesSection extends StatelessWidget {
  const _TastingNotesSection({required this.bean});

  final Bean bean;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: '향미 노트',
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: bean.tastingNotes
            .map(
              (note) => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: context.palette.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
                ),
                child: Text(
                  note,
                  style: TextStyle(
                    fontSize: 13,
                    color: context.palette.accentSoft,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _FlavorProfileSection extends StatelessWidget {
  const _FlavorProfileSection({required this.bean});

  final Bean bean;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: '테이스팅 프로필',
      child: Column(
        children: [
          _ProfileRow(label: '산미', level: bean.acidity),
          const SizedBox(height: 12),
          _ProfileRow(label: '바디', level: bean.body),
          const SizedBox(height: 12),
          _ProfileRow(label: '단맛', level: bean.sweetness),
        ],
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({required this.label, required this.level});

  final String label;
  final int level;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 40,
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Row(
            children: List.generate(5, (index) {
              final filled = index < level;
              return Expanded(
                child: Container(
                  height: 6,
                  margin: EdgeInsets.only(right: index < 4 ? 6 : 0),
                  decoration: BoxDecoration(
                    color: filled ? context.palette.accent : context.palette.surface,
                    borderRadius: BorderRadius.circular(3),
                    border: filled ? null : Border.all(color: context.palette.border),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(width: 12),
        Text('$level/5', style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _StorySection extends StatelessWidget {
  const _StorySection({required this.bean});

  final Bean bean;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: '원두 이야기',
      child: Text(
        bean.story.keepWord,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({required this.bean});

  final Bean bean;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: '상세 정보',
      child: Column(
        children: [
          _InfoRow(label: '원산지', value: bean.origin),
          _InfoRow(label: '가공 방식', value: bean.process),
          _InfoRow(label: '로스팅', value: bean.roastLevel.label),
          _InfoRow(label: '추천 추출', value: bean.recommendedBrews.join(' · ')),
          _InfoRow(
            label: '가격',
            value:
                '200g ${_priceFormat.format(bean.price200)}원 · '
                '500g ${_priceFormat.format(bean.price500)}원',
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72,
            child: Text(label, style: textTheme.bodySmall),
          ),
          Expanded(child: Text(value.keepWord, style: textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class BeanCartButton extends ConsumerWidget {
  const BeanCartButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(beanCartCountProvider);

    return IconButton(
      onPressed: () => context.push('/menu/beans-cart'),
      tooltip: '원두 장바구니',
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
                    color: context.palette.background,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _OrderBar extends ConsumerWidget {
  const _OrderBar({required this.bean});

  final Bean bean;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: context.palette.surface,
        border: Border(top: BorderSide(color: context.palette.border)),
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
                      '200g 기준',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      '${_priceFormat.format(bean.price200)}원',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: context.palette.accentSoft,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _openGift(context, ref),
                tooltip: '선물하기',
                icon: const Icon(LucideIcons.gift, size: 20),
                style: IconButton.styleFrom(
                  side: BorderSide(color: context.palette.border),
                  foregroundColor: context.palette.accentSoft,
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () =>
                    showBeanSubscribeSheet(context, ref, bean: bean),
                icon: const Icon(LucideIcons.repeat, size: 16),
                label: const Text('구독'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  side: BorderSide(color: context.palette.accent),
                  foregroundColor: context.palette.accentSoft,
                ),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed:
                    bean.soldOut ? null : () => _showOrderSheet(context, ref),
                icon: const Icon(LucideIcons.shoppingBag, size: 18),
                label: Text(bean.soldOut ? '품절' : '주문하기'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
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

  void _openGift(BuildContext context, WidgetRef ref) {
    if (!requireLogin(context, ref, message: '원두 선물하기는 로그인 후 이용할 수 있어요.')) {
      return;
    }
    context.push('/menu/beans/${bean.id}/gift');
  }

  Future<void> _showOrderSheet(BuildContext context, WidgetRef ref) async {
    if (!requireLogin(context, ref, message: '원두 주문은 로그인 후 이용할 수 있어요.')) {
      return;
    }

    final result = await showModalBottomSheet<BeanOrderSelection>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.palette.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => BeanOrderSheet(bean: bean),
    );
    if (result == null || !context.mounted) return;

    ref
        .read(beanCartProvider.notifier)
        .add(
          bean: bean,
          weight: result.weight,
          grind: result.grind,
          quantity: result.quantity,
        );

    if (result.action == BeanOrderAction.addToCart) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${bean.name}을(를) 장바구니에 담았습니다.'),
          action: SnackBarAction(
            label: '보기',
            onPressed: () => context.push('/menu/beans-cart'),
          ),
        ),
      );
      return;
    }

    context.push('/menu/beans-cart');
  }
}

enum BeanOrderAction { addToCart, orderNow }

class BeanOrderSelection {
  const BeanOrderSelection({
    required this.action,
    required this.weight,
    required this.grind,
    required this.quantity,
  });

  final BeanOrderAction action;
  final BeanWeight weight;
  final GrindOption grind;
  final int quantity;
}

class BeanOrderSheet extends StatefulWidget {
  const BeanOrderSheet({super.key, required this.bean});

  final Bean bean;

  @override
  State<BeanOrderSheet> createState() => _BeanOrderSheetState();
}

class _BeanOrderSheetState extends State<BeanOrderSheet> {
  BeanWeight _weight = BeanWeight.g200;
  GrindOption _grind = GrindOption.wholeBean;
  int _quantity = 1;

  int get _totalPrice => widget.bean.priceOf(_weight) * _quantity;

  void _pop(BuildContext context, BeanOrderAction action) {
    Navigator.of(context).pop(
      BeanOrderSelection(
        action: action,
        weight: _weight,
        grind: _grind,
        quantity: _quantity,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.bean.name.keepWord, style: textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              '${widget.bean.origin} · ${widget.bean.roastLevel.label} 로스팅'
                  .keepWord,
              style: textTheme.bodySmall,
            ),
            const SizedBox(height: 20),
            Text('용량', style: textTheme.titleSmall),
            const SizedBox(height: 8),
            Row(
              children: BeanWeight.values
                  .map(
                    (weight) => Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: weight == BeanWeight.values.last ? 0 : 8,
                        ),
                        child: _WeightOption(
                          weight: weight,
                          price: widget.bean.priceOf(weight),
                          selected: _weight == weight,
                          onTap: () => setState(() => _weight = weight),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 20),
            Text('분쇄도', style: textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: GrindOption.values
                  .map(
                    (grind) => ChoiceChip(
                      label: Text(grind.label),
                      selected: _grind == grind,
                      onSelected: (_) => setState(() => _grind = grind),
                      selectedColor: context.palette.accent.withValues(alpha: 0.25),
                      labelStyle: TextStyle(
                        fontSize: 13,
                        color: _grind == grind
                            ? context.palette.accentSoft
                            : context.palette.ink,
                      ),
                      side: BorderSide(
                        color: _grind == grind ? context.palette.accent : context.palette.border,
                      ),
                      backgroundColor: context.palette.surface,
                      showCheckmark: false,
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 6),
            Text(_grind.description.keepWord, style: textTheme.bodySmall),
            const SizedBox(height: 20),
            Row(
              children: [
                Text('수량', style: textTheme.titleSmall),
                const Spacer(),
                _QuantityButton(
                  icon: LucideIcons.minus,
                  enabled: _quantity > 1,
                  onTap: () => setState(() => _quantity--),
                ),
                SizedBox(
                  width: 44,
                  child: Text(
                    '$_quantity',
                    textAlign: TextAlign.center,
                    style: textTheme.titleMedium,
                  ),
                ),
                _QuantityButton(
                  icon: LucideIcons.plus,
                  enabled: _quantity < 9,
                  onTap: () => setState(() => _quantity++),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 12),
            Row(
              children: [
                Text('총 결제 금액', style: textTheme.bodyMedium),
                const Spacer(),
                Text(
                  '${_priceFormat.format(_totalPrice)}원',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: context.palette.accentSoft,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pop(context, BeanOrderAction.addToCart),
                    icon: const Icon(LucideIcons.shoppingBag, size: 18),
                    label: const Text('장바구니 담기'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: context.palette.accent),
                      foregroundColor: context.palette.accentSoft,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    onPressed: () => _pop(context, BeanOrderAction.orderNow),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text('${_priceFormat.format(_totalPrice)}원 주문'),
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

class _WeightOption extends StatelessWidget {
  const _WeightOption({
    required this.weight,
    required this.price,
    required this.selected,
    required this.onTap,
  });

  final BeanWeight weight;
  final int price;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? context.palette.accent.withValues(alpha: 0.15)
              : context.palette.surface,
          borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
          border: Border.all(
            color: selected ? context.palette.accent : context.palette.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              weight.label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: selected ? context.palette.accentSoft : context.palette.ink,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${_priceFormat.format(price)}원',
              style: Theme.of(context).textTheme.bodySmall,
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
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: context.palette.surface,
          borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
          border: Border.all(color: context.palette.border),
        ),
        child: Icon(
          icon,
          size: 18,
          color: enabled ? context.palette.accent : context.palette.muted,
        ),
      ),
    );
  }
}
