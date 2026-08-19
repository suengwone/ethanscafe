import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/text_utils.dart';
import '../../../../core/widgets/new_badge.dart';
import '../../../menu/domain/menu_models.dart';
import '../../../menu/presentation/menu_detail_screen.dart';
import '../../../menu/presentation/menu_providers.dart';

final recommendedMenuItemsProvider =
    FutureProvider<List<MenuItem>>((ref) async {
  final items = await ref.watch(menuItemsProvider.future);
  return items.where((item) => item.isRecommended).toList();
});

class RecommendedMenuSection extends ConsumerWidget {
  const RecommendedMenuSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items =
        ref.watch(recommendedMenuItemsProvider).asData?.value ?? const [];
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text(
                '이 메뉴 어때요?',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Spacer(),
              TextButton(
                onPressed: () => context.go('/menu'),
                style: TextButton.styleFrom(foregroundColor: context.palette.muted),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('전체보기'),
                    SizedBox(width: 2),
                    Icon(LucideIcons.chevronRight, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 196,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) =>
                _RecommendedCard(item: items[index]),
          ),
        ),
      ],
    );
  }
}

class _RecommendedCard extends StatelessWidget {
  const _RecommendedCard({required this.item});

  final MenuItem item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: 148,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.palette.card,
        borderRadius: BorderRadius.circular(foxtrotRadiusLarge),
        border: Border.all(color: context.palette.border.withValues(alpha: 0.7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: context.palette.surface,
                  shape: BoxShape.circle,
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  item.imageAsset,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    menuCategoryIcon(item.category),
                    size: 30,
                    color: colorScheme.primary,
                  ),
                ),
              ),
              if (item.badge == MenuBadge.isNew)
                const Positioned(
                  right: 0,
                  top: 0,
                  child: NewBadge(),
                ),
              if (item.badge == MenuBadge.hit)
                const Positioned(
                  right: 0,
                  top: 0,
                  child: HitBadge(),
                ),
            ],
          ),
          const Spacer(),
          Text(
            item.name.keepWord,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 2),
          Text(
            item.priceLabel,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
