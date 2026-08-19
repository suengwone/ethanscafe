import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../beans/domain/bean_models.dart';
import '../../beans/presentation/beans_providers.dart';
import '../../home/domain/banner_models.dart';
import '../../home/presentation/home_providers.dart';
import '../../menu/domain/menu_models.dart';
import '../../menu/presentation/menu_providers.dart';
import '../../store/domain/store_models.dart';
import '../../store/presentation/stores_providers.dart';
import 'banner_edit_screen.dart';
import 'bean_edit_screen.dart';
import 'catalog_admin_providers.dart';
import 'menu_edit_screen.dart';
import 'store_edit_screen.dart';

/// 매장이 메뉴·원두·배너·매장 정보를 등록·수정하고 품절 처리하는 화면.
/// 품절 처리한 상품은 주문 시 서버가 한 번 더 막는다.
class CatalogAdminScreen extends ConsumerWidget {
  const CatalogAdminScreen({super.key});

  static const _tabs = <({String label, String addLabel})>[
    (label: '메뉴', addLabel: '메뉴 등록'),
    (label: '원두', addLabel: '원두 등록'),
    (label: '배너', addLabel: '배너 등록'),
    (label: '매장', addLabel: '매장 등록'),
  ];

  static Widget _editScreenFor(int tabIndex) {
    return switch (tabIndex) {
      0 => const MenuEditScreen(),
      1 => const BeanEditScreen(),
      2 => const BannerEditScreen(),
      _ => const StoreEditScreen(),
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('카탈로그 관리'),
          bottom: TabBar(
            tabs: [for (final tab in _tabs) Tab(text: tab.label)],
          ),
        ),
        body: const TabBarView(
          children: [
            _MenuTab(),
            _BeanTab(),
            _BannerTab(),
            _StoreTab(),
          ],
        ),
        floatingActionButton: Builder(
          builder: (context) {
            final tabs = DefaultTabController.of(context);
            // 보고 있는 탭에 맞는 등록 화면을 연다.
            return AnimatedBuilder(
              animation: tabs,
              builder: (context, _) {
                return FloatingActionButton.extended(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => _editScreenFor(tabs.index),
                    ),
                  ),
                  icon: const Icon(Icons.add),
                  label: Text(_tabs[tabs.index].addLabel),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _MenuTab extends ConsumerWidget {
  const _MenuTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _CatalogList<MenuItem>(
      state: ref.watch(menuItemsProvider),
      errorMessage: '메뉴를 불러오지 못했습니다.',
      emptyMessage: '등록된 메뉴가 없습니다.',
      onRetry: () => ref.invalidate(menuItemsProvider),
      nameOf: (item) => item.name,
      subtitleOf: (item) => '${item.category.label} · ${item.priceLabel}',
      soldOutOf: (item) => item.soldOut,
      onSoldOutChanged: (item, soldOut) => ref
          .read(catalogAdminControllerProvider)
          .setMenuSoldOut(item.id, soldOut),
      onTap: (context, item) => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => MenuEditScreen(item: item),
        ),
      ),
    );
  }
}

class _BeanTab extends ConsumerWidget {
  const _BeanTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _CatalogList<Bean>(
      state: ref.watch(beansProvider),
      errorMessage: '원두를 불러오지 못했습니다.',
      emptyMessage: '등록된 원두가 없습니다.',
      onRetry: () => ref.invalidate(beansProvider),
      nameOf: (bean) => bean.name,
      subtitleOf: (bean) => '${bean.origin} · ${bean.roastLevel.label}',
      soldOutOf: (bean) => bean.soldOut,
      onSoldOutChanged: (bean, soldOut) => ref
          .read(catalogAdminControllerProvider)
          .setBeanSoldOut(bean.id, soldOut),
      onTap: (context, bean) => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => BeanEditScreen(bean: bean),
        ),
      ),
    );
  }
}

class _BannerTab extends ConsumerWidget {
  const _BannerTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _CatalogList<EventBanner>(
      state: ref.watch(bannersProvider),
      errorMessage: '배너를 불러오지 못했습니다.',
      emptyMessage: '등록된 배너가 없습니다.',
      onRetry: () => ref.invalidate(bannersProvider),
      nameOf: (banner) => banner.title,
      subtitleOf: (banner) => banner.subtitle,
      onTap: (context, banner) => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => BannerEditScreen(banner: banner),
        ),
      ),
    );
  }
}

class _StoreTab extends ConsumerWidget {
  const _StoreTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _CatalogList<CafeStore>(
      state: ref.watch(storesProvider),
      errorMessage: '매장을 불러오지 못했습니다.',
      emptyMessage: '등록된 매장이 없습니다.',
      onRetry: () => ref.invalidate(storesProvider),
      nameOf: (store) => store.name,
      subtitleOf: (store) => store.address,
      onTap: (context, store) => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => StoreEditScreen(store: store),
        ),
      ),
    );
  }
}

class _CatalogList<T> extends StatelessWidget {
  const _CatalogList({
    required this.state,
    required this.errorMessage,
    required this.emptyMessage,
    required this.onRetry,
    required this.nameOf,
    required this.subtitleOf,
    this.soldOutOf,
    this.onSoldOutChanged,
    this.onTap,
  });

  final AsyncValue<List<T>> state;
  final String errorMessage;
  final String emptyMessage;
  final VoidCallback onRetry;
  final String Function(T) nameOf;
  final String Function(T) subtitleOf;

  /// 품절 개념이 있는 목록(메뉴·원두)만 넘긴다. 배너·매장은 스위치 없이 그린다.
  final bool Function(T)? soldOutOf;
  final Future<void> Function(T, bool)? onSoldOutChanged;
  final void Function(BuildContext, T)? onTap;

  @override
  Widget build(BuildContext context) {
    return state.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(errorMessage),
            const SizedBox(height: 8),
            TextButton(onPressed: onRetry, child: const Text('다시 시도')),
          ],
        ),
      ),
      data: (items) {
        if (items.isEmpty) {
          return Center(
            child: Text(
              emptyMessage,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: foxtrotMuted),
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final item = items[index];
            final soldOut = soldOutOf?.call(item);
            final onSoldOutChanged = this.onSoldOutChanged;
            return _CatalogTile(
              name: nameOf(item),
              subtitle: subtitleOf(item),
              soldOut: soldOut,
              onSoldOutChanged: soldOut == null || onSoldOutChanged == null
                  ? null
                  : (value) => onSoldOutChanged(item, value),
              onTap: onTap == null ? null : () => onTap!(context, item),
            );
          },
        );
      },
    );
  }
}

class _CatalogTile extends StatefulWidget {
  const _CatalogTile({
    required this.name,
    required this.subtitle,
    this.soldOut,
    this.onSoldOutChanged,
    this.onTap,
  });

  final String name;
  final String subtitle;
  final bool? soldOut;
  final Future<void> Function(bool)? onSoldOutChanged;
  final VoidCallback? onTap;

  @override
  State<_CatalogTile> createState() => _CatalogTileState();
}

class _CatalogTileState extends State<_CatalogTile> {
  bool _busy = false;

  Future<void> _toggle(bool soldOut) async {
    final onSoldOutChanged = widget.onSoldOutChanged;
    if (_busy || onSoldOutChanged == null) {
      return;
    }
    setState(() => _busy = true);
    try {
      await onSoldOutChanged(soldOut);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('판매 상태를 바꾸지 못했습니다: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final soldOut = widget.soldOut ?? false;
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: foxtrotCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: foxtrotBorder),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: textTheme.bodyLarge?.copyWith(
                      color: soldOut ? foxtrotMuted : foxtrotCream,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    soldOut ? '품절 · ${widget.subtitle}' : widget.subtitle,
                    style: textTheme.bodySmall?.copyWith(color: foxtrotMuted),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (widget.soldOut != null)
              Switch(value: soldOut, onChanged: _busy ? null : _toggle)
            else
              const Icon(Icons.chevron_right, color: foxtrotMuted),
          ],
        ),
      ),
    );
  }
}
