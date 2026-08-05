import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/text_utils.dart';
import '../../../core/widgets/new_badge.dart';
import '../domain/bean_models.dart';
import 'bean_cart_providers.dart';
import 'beans_providers.dart';

final _priceFormat = NumberFormat('#,###');

class BeansListView extends ConsumerWidget {
  const BeansListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final beansState = ref.watch(beansProvider);

    return beansState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('원두 정보를 불러오지 못했습니다.'),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => ref.invalidate(beansProvider),
              child: const Text('다시 시도'),
            ),
          ],
        ),
      ),
      data: (beans) {
        final acidic =
            beans.where((bean) => !bean.isDecaf && bean.isAcidic).toList();
        final nutty =
            beans.where((bean) => !bean.isDecaf && !bean.isAcidic).toList();
        final decaf = beans.where((bean) => bean.isDecaf).toList();
        final cartCount = ref.watch(beanCartCountProvider);

        return Stack(
          children: [
            ListView(
              padding: cartCount > 0
                  ? foxtrotListPadding.copyWith(bottom: 88)
                  : foxtrotListPadding,
              children: [
                const _BeansHeader(),
                if (acidic.isNotEmpty) ...[
                  const _BeanSectionHeader(
                    icon: LucideIcons.citrus,
                    title: '산미가 화사한 원두',
                    subtitle: '과일처럼 밝고 산뜻한 맛을 좋아한다면',
                  ),
                  ...acidic.map((bean) => _BeanCard(bean: bean)),
                ],
                if (nutty.isNotEmpty) ...[
                  const _BeanSectionHeader(
                    icon: LucideIcons.nut,
                    title: '산미 적은 고소한 원두',
                    subtitle: '산미 부담 없이 고소하고 묵직한 한 잔을 원한다면',
                  ),
                  ...nutty.map((bean) => _BeanCard(bean: bean)),
                ],
                if (decaf.isNotEmpty) ...[
                  const _BeanSectionHeader(
                    icon: LucideIcons.moonStar,
                    title: '디카페인',
                    subtitle: '늦은 오후에도 카페인 걱정 없이',
                  ),
                  ...decaf.map((bean) => _BeanCard(bean: bean)),
                ],
              ],
            ),
            if (cartCount > 0)
              const Positioned(
                left: foxtrotScreenHPadding,
                right: foxtrotScreenHPadding,
                bottom: 16,
                child: _CartSummaryBar(),
              ),
          ],
        );
      },
    );
  }
}

class _CartSummaryBar extends ConsumerWidget {
  const _CartSummaryBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(beanCartCountProvider);
    final total = ref.watch(beanCartTotalProvider);

    return Material(
      color: foxtrotGold,
      borderRadius: BorderRadius.circular(foxtrotRadiusLarge),
      child: InkWell(
        borderRadius: BorderRadius.circular(foxtrotRadiusLarge),
        onTap: () => context.push('/menu/beans-cart'),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Row(
            children: [
              const Icon(
                LucideIcons.shoppingBag,
                size: 18,
                color: foxtrotBlack,
              ),
              const SizedBox(width: 8),
              Text(
                '장바구니 · $count개',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: foxtrotBlack,
                ),
              ),
              const Spacer(),
              Text(
                '${_priceFormat.format(total)}원',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: foxtrotBlack,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                LucideIcons.chevronRight,
                size: 16,
                color: foxtrotBlack,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BeansHeader extends StatelessWidget {
  const _BeansHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      child: Text(
        '매주 화요일 로스팅한 원두를 홀빈 또는 원하는 분쇄도로 보내드립니다.'.keepWord,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}

class _BeanSectionHeader extends StatelessWidget {
  const _BeanSectionHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: foxtrotGold),
              const SizedBox(width: 7),
              Expanded(
                child: Text(title.keepWord, style: textTheme.titleMedium),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Text(subtitle.keepWord, style: textTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}

class _BeanCard extends StatelessWidget {
  const _BeanCard({required this.bean});

  final Bean bean;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(foxtrotRadiusLarge),
        onTap: () => context.push('/menu/beans/${bean.id}'),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                bean.name.keepWord,
                                style: textTheme.labelLarge,
                              ),
                            ),
                            if (bean.isNew) ...[
                              const SizedBox(width: 6),
                              const NewBadge(),
                            ],
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${bean.origin} · ${bean.roastLevel.label} 로스팅'
                              .keepWord,
                          style: textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: bean.tastingNotes
                    .take(3)
                    .map((note) => _TastingNoteChip(note: note))
                    .toList(),
              ),
              const SizedBox(height: 12),
              Container(
                height: 1,
                color: foxtrotBorder.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text('200g 기준', style: textTheme.bodySmall),
                  const Spacer(),
                  Text(
                    '${_priceFormat.format(bean.price200)}원',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      letterSpacing: -0.3,
                      color: foxtrotCream,
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(
                    LucideIcons.chevronRight,
                    size: 16,
                    color: foxtrotMuted,
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

class _TastingNoteChip extends StatelessWidget {
  const _TastingNoteChip({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: foxtrotGold.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(foxtrotRadiusSmall),
      ),
      child: Text(
        note,
        style: const TextStyle(fontSize: 11, color: foxtrotGoldLight),
      ),
    );
  }
}
