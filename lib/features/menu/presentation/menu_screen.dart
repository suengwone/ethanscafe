import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/text_utils.dart';
import '../../../core/widgets/new_badge.dart';
import '../../../features/menu/presentation/menu_labels.dart';
import '../../../l10n/app_localizations.dart';
import '../../beans/presentation/beans_list_view.dart';
import '../../pickup/presentation/pickup_cart_screen.dart';
import '../../review/domain/review_models.dart';
import '../../review/presentation/review_providers.dart';
import '../domain/menu_models.dart';
import 'menu_detail_screen.dart';
import 'menu_providers.dart';

class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.menuTitle),
          actions: const [PickupCartButton(), SizedBox(width: 4)],
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.center,
            tabs: [
              for (final category in MenuCategory.values)
                Tab(text: l10n.menuCategoryLabel(category)),
              Tab(text: l10n.menuCategoryBeans),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _MenuList(category: MenuCategory.drip),
            _MenuList(category: MenuCategory.espresso),
            _MenuList(category: MenuCategory.beverage),
            _MenuList(category: MenuCategory.tea),
            _MenuList(category: MenuCategory.dessert),
            BeansListView(),
          ],
        ),
      ),
    );
  }
}

class _MenuList extends ConsumerWidget {
  final MenuCategory category;

  const _MenuList({required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuState = ref.watch(menuItemsByCategoryProvider(category));

    return menuState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppLocalizations.of(context).menuLoadFailed),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () =>
                  ref.invalidate(menuItemsByCategoryProvider(category)),
              child: Text(AppLocalizations.of(context).retry),
            ),
          ],
        ),
      ),
      data: (menuItems) {
        final note = AppLocalizations.of(context).menuCategoryNote(category);
        return ListView.builder(
          padding: foxtrotListPadding,
          itemCount: menuItems.length + (note == null ? 0 : 1),
          itemBuilder: (context, index) {
            if (note != null && index == 0) {
              return Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 12),
                child: Text(
                  note.keepWord,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              );
            }
            final item = menuItems[note == null ? index : index - 1];
            return _MenuTile(item: item);
          },
        );
      },
    );
  }
}

class _MenuTile extends ConsumerWidget {
  const _MenuTile({required this.item});

  final MenuItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsBadges = ref.watch(productBadgesProvider).value ??
        const <String, Set<ProductBadge>>{};
    final badges = statsBadges[item.id] ?? const <ProductBadge>{};
    final showNew = item.badge == MenuBadge.isNew;
    final showHit =
        item.badge == MenuBadge.hit || badges.contains(ProductBadge.hit);
    final showBest = badges.contains(ProductBadge.best);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: MenuImageThumbnail(item: item),
        title: Text(
          item.name.keepWord,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        subtitle: Text(
          item.description.keepWord,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              AppLocalizations.of(context).menuPriceLabel(item),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            if (item.soldOut || showNew || showHit || showBest)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 품절이면 판매 배지는 의미가 없어 대신 품절만 보여준다.
                  if (item.soldOut) const SoldOutBadge(),
                  if (!item.soldOut) ...[
                  if (showBest) const BestBadge(),
                  if (showHit) ...[
                    if (showBest) const SizedBox(width: 4),
                    const HitBadge(),
                  ],
                  if (showNew) ...[
                    if (showBest || showHit) const SizedBox(width: 4),
                    const NewBadge(),
                  ],
                  ],
                ],
              ),
          ],
        ),
        onTap: () => context.push('/menu/item/${item.id}'),
      ),
    );
  }
}
