import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../domain/menu_models.dart';
import 'menu_detail_screen.dart';
import 'menu_providers.dart';

class FavoriteMenuScreen extends ConsumerWidget {
  const FavoriteMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesState = ref.watch(favoriteMenuItemsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('즐겨찾기 메뉴')),
      body: favoritesState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('즐겨찾기 메뉴를 불러오지 못했습니다.'),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.invalidate(favoriteMenuItemsProvider),
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
        data: (items) {
          if (items.isEmpty) {
            return const _EmptyFavorites();
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: items.length,
            itemBuilder: (context, index) =>
                _FavoriteTile(item: items[index]),
          );
        },
      ),
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(LucideIcons.heart, size: 48, color: foxtrotMuted),
          const SizedBox(height: 16),
          Text(
            '아직 즐겨찾기한 메뉴가 없어요',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '메뉴 상세에서 하트를 눌러 자주 마시는 메뉴를 등록해보세요.',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => context.go('/menu'),
            child: const Text('메뉴 보러가기'),
          ),
        ],
      ),
    );
  }
}

class _FavoriteTile extends ConsumerWidget {
  const _FavoriteTile({required this.item});

  final MenuItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: foxtrotSurface,
            borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
            border: Border.all(color: foxtrotBorder),
          ),
          child: Icon(
            menuCategoryIcon(item.category),
            color: foxtrotGold,
            size: 26,
          ),
        ),
        title: Text(
          item.name,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        subtitle: Text(
          '${item.category.label} · ${item.priceLabel}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: IconButton(
          icon: const Icon(LucideIcons.heart600, color: foxtrotGold),
          tooltip: '즐겨찾기 해제',
          onPressed: () =>
              ref.read(favoritesProvider.notifier).toggle(item.id),
        ),
        onTap: () => context.push('/menu/item/${item.id}'),
      ),
    );
  }
}
