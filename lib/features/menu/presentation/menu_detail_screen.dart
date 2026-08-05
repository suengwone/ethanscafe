import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/text_utils.dart';
import '../../../core/widgets/new_badge.dart';
import '../domain/menu_models.dart';
import 'menu_providers.dart';

class MenuDetailScreen extends ConsumerWidget {
  const MenuDetailScreen({super.key, required this.menuId});

  final String menuId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuState = ref.watch(menuItemProvider(menuId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('메뉴 상세'),
        actions: [
          _FavoriteButton(menuId: menuId),
        ],
      ),
      body: menuState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('메뉴 정보를 불러오지 못했습니다.'),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.invalidate(menuItemProvider(menuId)),
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
        data: (item) => _MenuDetailBody(item: item),
      ),
    );
  }
}

class _FavoriteButton extends ConsumerWidget {
  const _FavoriteButton({required this.menuId});

  final String menuId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider).asData?.value ?? const {};
    final isFavorite = favorites.contains(menuId);

    return IconButton(
      icon: Icon(
        isFavorite ? LucideIcons.heart600 : LucideIcons.heart,
        color: isFavorite ? foxtrotGold : null,
      ),
      tooltip: isFavorite ? '즐겨찾기 해제' : '즐겨찾기 등록',
      onPressed: () async {
        await ref.read(favoritesProvider.notifier).toggle(menuId);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                isFavorite ? '즐겨찾기에서 삭제되었습니다.' : '즐겨찾기에 추가되었습니다.',
              ),
              duration: const Duration(seconds: 1),
            ),
          );
      },
    );
  }
}

class _MenuDetailBody extends StatelessWidget {
  const _MenuDetailBody({required this.item});

  final MenuItem item;

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
          _HeaderSection(item: item),
          const SizedBox(height: 16),
          if (item.detail != null) ...[
            _SectionCard(
              title: '메뉴 소개',
              child: Text(
                item.detail!.keepWord,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(height: 1.6),
              ),
            ),
            const SizedBox(height: 16),
          ],
          _InfoSection(item: item),
          if (item.category.note != null) ...[
            const SizedBox(height: 16),
            _SectionCard(
              title: '옵션 안내',
              child: Text(
                item.category.note!.keepWord,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(height: 1.6),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({required this.item});

  final MenuItem item;

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
                color: foxtrotSurface,
                shape: BoxShape.circle,
                border: Border.all(color: foxtrotGold, width: 1.5),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                item.imageAsset,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(
                  menuCategoryIcon(item.category),
                  color: foxtrotGold,
                  size: 40,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    item.name.keepWord,
                    style: textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
                if (item.badge == MenuBadge.isNew) ...[
                  const SizedBox(width: 8),
                  const NewBadge(),
                ],
                if (item.badge == MenuBadge.hit) ...[
                  const SizedBox(width: 8),
                  const HitBadge(),
                ],
              ],
            ),
            const SizedBox(height: 6),
            Text(
              item.description.keepWord,
              style: textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
            Text(
              item.priceLabel,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: foxtrotGoldLight,
              ),
            ),
            if (item.servingOptions.isNotEmpty) ...[
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                alignment: WrapAlignment.center,
                children: item.servingOptions
                    .map((option) => _ServingChip(label: option))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ServingChip extends StatelessWidget {
  const _ServingChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: foxtrotGold.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 13, color: foxtrotGoldLight),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({required this.item});

  final MenuItem item;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: '상세 정보',
      child: Column(
        children: [
          _InfoRow(label: '카테고리', value: item.category.label),
          _InfoRow(label: '가격', value: item.priceLabel),
          if (item.servingOptions.isNotEmpty)
            _InfoRow(label: '제공 옵션', value: item.servingOptions.join(' · ')),
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

class MenuImageThumbnail extends StatelessWidget {
  const MenuImageThumbnail({super.key, required this.item, this.size = 60});

  final MenuItem item;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: foxtrotSurface,
        borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
        border: Border.all(color: foxtrotBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        item.imageAsset,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Icon(
          menuCategoryIcon(item.category),
          color: foxtrotGold,
          size: size * 0.45,
        ),
      ),
    );
  }
}

IconData menuCategoryIcon(MenuCategory category) {
  switch (category) {
    case MenuCategory.drip:
      return LucideIcons.bean;
    case MenuCategory.espresso:
      return LucideIcons.coffee;
    case MenuCategory.beverage:
      return LucideIcons.cupSoda;
    case MenuCategory.tea:
      return LucideIcons.leaf;
    case MenuCategory.dessert:
      return LucideIcons.croissant;
  }
}
