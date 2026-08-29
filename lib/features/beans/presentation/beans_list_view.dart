import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/text_utils.dart';
import '../../../core/widgets/new_badge.dart';
import '../../../features/beans/presentation/bean_labels.dart';
import '../../../l10n/app_localizations.dart';
import '../../review/domain/review_models.dart';
import '../../review/presentation/review_providers.dart';
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
            Text(AppLocalizations.of(context).beansLoadFailed),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => ref.invalidate(beansProvider),
              child: Text(AppLocalizations.of(context).retry),
            ),
          ],
        ),
      ),
      data: (beans) {
        final acidic = beans
            .where((bean) => !bean.isDecaf && bean.isAcidic)
            .toList();
        final nutty = beans
            .where((bean) => !bean.isDecaf && !bean.isAcidic)
            .toList();
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
                  _BeanSectionHeader(
                    icon: LucideIcons.citrus,
                    title: AppLocalizations.of(context).beansFilterAcidic,
                    subtitle: AppLocalizations.of(
                      context,
                    ).beansFilterAcidicNote,
                  ),
                  ...acidic.map((bean) => _BeanCard(bean: bean)),
                ],
                if (nutty.isNotEmpty) ...[
                  _BeanSectionHeader(
                    icon: LucideIcons.nut,
                    title: AppLocalizations.of(context).beansFilterMellow,
                    subtitle: AppLocalizations.of(
                      context,
                    ).beansFilterMellowNote,
                  ),
                  ...nutty.map((bean) => _BeanCard(bean: bean)),
                ],
                if (decaf.isNotEmpty) ...[
                  _BeanSectionHeader(
                    icon: LucideIcons.moonStar,
                    title: AppLocalizations.of(context).beansFilterDecaf,
                    subtitle: AppLocalizations.of(context).beansFilterDecafNote,
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
      color: context.palette.accent,
      borderRadius: BorderRadius.circular(foxtrotRadiusLarge),
      child: InkWell(
        borderRadius: BorderRadius.circular(foxtrotRadiusLarge),
        onTap: () => context.push('/menu/beans-cart'),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Row(
            children: [
              Icon(
                LucideIcons.shoppingBag,
                size: 18,
                color: context.palette.onAccent,
              ),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context).beansCartCount(count),
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: context.palette.onAccent,
                ),
              ),
              const Spacer(),
              Text(
                AppLocalizations.of(
                  context,
                ).priceWon(_priceFormat.format(total)),
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: context.palette.onAccent,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                LucideIcons.chevronRight,
                size: 16,
                color: context.palette.onAccent,
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
        AppLocalizations.of(context).beansRoastNotice.keepWord,
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
              Icon(icon, size: 18, color: context.palette.accent),
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

class _BeanCard extends ConsumerWidget {
  const _BeanCard({required this.bean});

  final Bean bean;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final statsBadges =
        ref.watch(productBadgesProvider).value ??
        const <String, Set<ProductBadge>>{};
    final badges = statsBadges[bean.id] ?? const <ProductBadge>{};

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
                      color: context.palette.surface,
                      borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
                      border: Border.all(color: context.palette.border),
                    ),
                    child: Icon(
                      LucideIcons.bean,
                      color: context.palette.accent,
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
                            // 품절이면 판매 배지는 의미가 없어 대신 품절만 보여준다.
                            if (bean.soldOut) ...[
                              const SizedBox(width: 6),
                              const SoldOutBadge(),
                            ] else ...[
                              if (badges.contains(ProductBadge.best)) ...[
                                const SizedBox(width: 6),
                                const BestBadge(),
                              ],
                              if (badges.contains(ProductBadge.hit)) ...[
                                const SizedBox(width: 6),
                                const HitBadge(),
                              ],
                              if (bean.isNew) ...[
                                const SizedBox(width: 6),
                                const NewBadge(),
                              ],
                            ],
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          AppLocalizations.of(context)
                              .beansRoastOf(
                                bean.origin,
                                AppLocalizations.of(
                                  context,
                                ).roastLevelLabel(bean.roastLevel),
                              )
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
                color: context.palette.border.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context).beansPricePer200g,
                    style: textTheme.bodySmall,
                  ),
                  const Spacer(),
                  Text(
                    AppLocalizations.of(
                      context,
                    ).priceWon(_priceFormat.format(bean.price200)),
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      letterSpacing: -0.3,
                      color: context.palette.ink,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(
                    LucideIcons.chevronRight,
                    size: 16,
                    color: context.palette.muted,
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
        color: context.palette.accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(foxtrotRadiusSmall),
      ),
      child: Text(
        note,
        style: TextStyle(fontSize: 11, color: context.palette.accentSoft),
      ),
    );
  }
}
