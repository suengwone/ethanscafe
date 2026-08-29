import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/text_utils.dart';
import '../../../features/menu/presentation/menu_labels.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/menu_models.dart';
import 'menu_detail_screen.dart';
import 'menu_providers.dart';

class FavoriteMenuScreen extends ConsumerWidget {
  const FavoriteMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final favoritesState = ref.watch(favoriteMenuItemsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.favoriteMenuTitle)),
      body: favoritesState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.favoriteMenuLoadFailed),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.invalidate(favoriteMenuItemsProvider),
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
        data: (items) {
          if (items.isEmpty) {
            return const _EmptyFavorites();
          }
          return ListView.builder(
            padding: foxtrotListPadding,
            itemCount: items.length,
            itemBuilder: (context, index) => _FavoriteTile(item: items[index]),
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
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.heart, size: 48, color: context.palette.muted),
          const SizedBox(height: 16),
          Text(
            l10n.favoriteMenuEmptyTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.favoriteMenuEmptyDetail.keepWord,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => context.go('/menu'),
            child: Text(l10n.favoriteMenuBrowse),
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
    final l10n = AppLocalizations.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: MenuImageThumbnail(item: item),
        title: Text(
          item.name.keepWord,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        subtitle: Text(
          '${l10n.menuCategoryLabel(item.category)} · '
                  '${l10n.menuPriceLabel(item)}'
              .keepWord,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: IconButton(
          icon: Icon(LucideIcons.heart600, color: context.palette.accent),
          tooltip: l10n.menuFavoriteRemove,
          onPressed: () => ref.read(favoritesProvider.notifier).toggle(item.id),
        ),
        onTap: () => context.push('/menu/item/${item.id}'),
      ),
    );
  }
}
