import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/new_badge.dart';
import '../../beans/presentation/beans_list_view.dart';
import '../domain/menu_models.dart';
import 'menu_detail_screen.dart';
import 'menu_providers.dart';

class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('메뉴'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: '드립 커피'),
              Tab(text: '에스프레소'),
              Tab(text: '음료'),
              Tab(text: '티'),
              Tab(text: '디저트'),
              Tab(text: '원두'),
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
            const Text('메뉴 정보를 불러오지 못했습니다.'),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () =>
                  ref.invalidate(menuItemsByCategoryProvider(category)),
              child: const Text('다시 시도'),
            ),
          ],
        ),
      ),
      data: (menuItems) {
        final note = category.note;
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: menuItems.length + (note == null ? 0 : 1),
          itemBuilder: (context, index) {
            if (note != null && index == 0) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(4, 8, 4, 12),
                child: Text(
                  note,
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

class _MenuTile extends StatelessWidget {
  const _MenuTile({required this.item});

  final MenuItem item;

  @override
  Widget build(BuildContext context) {
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
          item.description,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              item.priceLabel,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            if (item.badge == MenuBadge.isNew) const NewBadge(),
            if (item.badge == MenuBadge.hit) const HitBadge(),
          ],
        ),
        onTap: () => context.push('/menu/item/${item.id}'),
      ),
    );
  }
}
