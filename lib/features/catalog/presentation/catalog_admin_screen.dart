import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../beans/domain/bean_models.dart';
import '../../beans/presentation/beans_providers.dart';
import '../../menu/domain/menu_models.dart';
import '../../menu/presentation/menu_providers.dart';
import 'catalog_admin_providers.dart';
import 'menu_edit_screen.dart';

/// 매장이 상품을 등록·수정하고 품절 처리하는 화면.
/// 품절 처리한 상품은 주문 시 서버가 한 번 더 막는다.
class CatalogAdminScreen extends ConsumerWidget {
  const CatalogAdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('상품 관리'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '메뉴'),
              Tab(text: '원두'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [_MenuSoldOutTab(), _BeanSoldOutTab()],
        ),
        floatingActionButton: Builder(
          builder: (context) {
            final tabs = DefaultTabController.of(context);
            // 원두 등록은 아직 없으므로 메뉴 탭에서만 띄운다.
            return AnimatedBuilder(
              animation: tabs,
              builder: (context, _) {
                if (tabs.index != 0) {
                  return const SizedBox.shrink();
                }
                return FloatingActionButton.extended(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => const MenuEditScreen(),
                    ),
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('메뉴 등록'),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _MenuSoldOutTab extends ConsumerWidget {
  const _MenuSoldOutTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(menuItemsProvider);
    return _CatalogList<MenuItem>(
      state: state,
      emptyMessage: '등록된 메뉴가 없습니다.',
      onRetry: () => ref.invalidate(menuItemsProvider),
      nameOf: (item) => item.name,
      subtitleOf: (item) => '${item.category.label} · ${item.priceLabel}',
      soldOutOf: (item) => item.soldOut,
      onChanged: (item, soldOut) => ref
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

class _BeanSoldOutTab extends ConsumerWidget {
  const _BeanSoldOutTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(beansProvider);
    return _CatalogList<Bean>(
      state: state,
      emptyMessage: '등록된 원두가 없습니다.',
      onRetry: () => ref.invalidate(beansProvider),
      nameOf: (bean) => bean.name,
      subtitleOf: (bean) => '${bean.origin} · ${bean.roastLevel.label}',
      soldOutOf: (bean) => bean.soldOut,
      onChanged: (bean, soldOut) => ref
          .read(catalogAdminControllerProvider)
          .setBeanSoldOut(bean.id, soldOut),
    );
  }
}

class _CatalogList<T> extends StatelessWidget {
  const _CatalogList({
    required this.state,
    required this.emptyMessage,
    required this.onRetry,
    required this.nameOf,
    required this.subtitleOf,
    required this.soldOutOf,
    required this.onChanged,
    this.onTap,
  });

  final AsyncValue<List<T>> state;
  final String emptyMessage;
  final VoidCallback onRetry;
  final String Function(T) nameOf;
  final String Function(T) subtitleOf;
  final bool Function(T) soldOutOf;
  final Future<void> Function(T, bool) onChanged;
  final void Function(BuildContext, T)? onTap;

  @override
  Widget build(BuildContext context) {
    return state.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('상품을 불러오지 못했습니다.'),
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
            return _SoldOutTile(
              name: nameOf(item),
              subtitle: subtitleOf(item),
              soldOut: soldOutOf(item),
              onChanged: (soldOut) => onChanged(item, soldOut),
              onTap: onTap == null ? null : () => onTap!(context, item),
            );
          },
        );
      },
    );
  }
}

class _SoldOutTile extends StatefulWidget {
  const _SoldOutTile({
    required this.name,
    required this.subtitle,
    required this.soldOut,
    required this.onChanged,
    this.onTap,
  });

  final String name;
  final String subtitle;
  final bool soldOut;
  final Future<void> Function(bool) onChanged;
  final VoidCallback? onTap;

  @override
  State<_SoldOutTile> createState() => _SoldOutTileState();
}

class _SoldOutTileState extends State<_SoldOutTile> {
  bool _busy = false;

  Future<void> _toggle(bool soldOut) async {
    if (_busy) {
      return;
    }
    setState(() => _busy = true);
    try {
      await widget.onChanged(soldOut);
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
                      color: widget.soldOut ? foxtrotMuted : foxtrotCream,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.soldOut
                        ? '품절 · ${widget.subtitle}'
                        : widget.subtitle,
                    style: textTheme.bodySmall?.copyWith(color: foxtrotMuted),
                  ),
                ],
              ),
            ),
            Switch(value: widget.soldOut, onChanged: _busy ? null : _toggle),
          ],
        ),
      ),
    );
  }
}
