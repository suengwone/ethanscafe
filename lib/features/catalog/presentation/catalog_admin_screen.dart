import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../features/beans/presentation/bean_labels.dart';
import '../../../features/menu/presentation/menu_labels.dart';
import '../../../features/notice/presentation/notice_labels.dart';
import '../../../l10n/app_localizations.dart';
import '../../beans/domain/bean_models.dart';
import '../../beans/presentation/beans_providers.dart';
import '../../home/domain/banner_models.dart';
import '../../home/presentation/home_providers.dart';
import '../../menu/domain/menu_models.dart';
import '../../menu/presentation/menu_providers.dart';
import '../../notice/domain/notice_models.dart';
import '../../notice/presentation/notices_providers.dart';
import '../../store/domain/store_models.dart';
import '../../store/presentation/stores_providers.dart';
import 'banner_edit_screen.dart';
import 'bean_edit_screen.dart';
import 'catalog_admin_providers.dart';
import 'menu_edit_screen.dart';
import 'notice_edit_screen.dart';
import 'store_edit_screen.dart';

final _noticeDateFormat = DateFormat('yyyy.MM.dd');

/// 매장이 메뉴·원두·배너·매장·공지를 등록·수정하고 품절 처리하는 화면.
/// 품절 처리한 상품은 주문 시 서버가 한 번 더 막는다.
class CatalogAdminScreen extends ConsumerWidget {
  const CatalogAdminScreen({super.key});

  static List<({String label, String addLabel})> _tabs(AppLocalizations l10n) =>
      [
        (label: l10n.catalogTabMenu, addLabel: l10n.catalogAddMenu),
        (label: l10n.catalogTabBeans, addLabel: l10n.catalogAddBean),
        (label: l10n.catalogTabBanners, addLabel: l10n.catalogAddBanner),
        (label: l10n.catalogTabStores, addLabel: l10n.catalogAddStore),
        (label: l10n.catalogTabNotices, addLabel: l10n.catalogAddNotice),
      ];

  static Widget _editScreenFor(int tabIndex) {
    return switch (tabIndex) {
      0 => const MenuEditScreen(),
      1 => const BeanEditScreen(),
      2 => const BannerEditScreen(),
      3 => const StoreEditScreen(),
      _ => const NoticeEditScreen(),
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabs = _tabs(AppLocalizations.of(context));
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).catalogAdminTitle),
          bottom: TabBar(tabs: [for (final tab in tabs) Tab(text: tab.label)]),
        ),
        body: const TabBarView(
          children: [
            _MenuTab(),
            _BeanTab(),
            _BannerTab(),
            _StoreTab(),
            _NoticeTab(),
          ],
        ),
        floatingActionButton: Builder(
          builder: (context) {
            final controller = DefaultTabController.of(context);
            // 보고 있는 탭에 맞는 등록 화면을 연다.
            return AnimatedBuilder(
              animation: controller,
              builder: (context, _) {
                return FloatingActionButton.extended(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => _editScreenFor(controller.index),
                    ),
                  ),
                  icon: const Icon(Icons.add),
                  label: Text(tabs[controller.index].addLabel),
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
    final l10n = AppLocalizations.of(context);
    return _CatalogList<MenuItem>(
      state: ref.watch(menuItemsProvider),
      errorMessage: l10n.menuLoadFailed,
      emptyMessage: l10n.catalogMenuEmpty,
      onRetry: () => ref.invalidate(menuItemsProvider),
      nameOf: (item) => item.name,
      subtitleOf: (item) =>
          '${l10n.menuCategoryLabel(item.category)} · '
          '${l10n.menuPriceLabel(item)}',
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
    final l10n = AppLocalizations.of(context);
    return _CatalogList<Bean>(
      state: ref.watch(beansProvider),
      errorMessage: l10n.beansLoadFailed,
      emptyMessage: l10n.catalogBeansEmpty,
      onRetry: () => ref.invalidate(beansProvider),
      nameOf: (bean) => bean.name,
      subtitleOf: (bean) =>
          '${bean.origin} · ${l10n.roastLevelLabel(bean.roastLevel)}',
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
      errorMessage: AppLocalizations.of(context).catalogBannersLoadFailed,
      emptyMessage: AppLocalizations.of(context).catalogBannersEmpty,
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
      errorMessage: AppLocalizations.of(context).storeLoadFailed,
      emptyMessage: AppLocalizations.of(context).catalogStoresEmpty,
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

class _NoticeTab extends ConsumerWidget {
  const _NoticeTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return _CatalogList<Notice>(
      state: ref.watch(noticesProvider),
      errorMessage: l10n.catalogNoticesLoadFailed,
      emptyMessage: l10n.catalogNoticesEmpty,
      onRetry: () => ref.invalidate(noticesProvider),
      nameOf: (notice) => notice.title,
      subtitleOf: (notice) =>
          '${l10n.noticeCategoryLabel(notice.category)} · '
          '${_noticeDateFormat.format(notice.createdAt)}',
      onTap: (context, notice) => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => NoticeEditScreen(notice: notice),
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

  /// 품절 개념이 있는 목록(메뉴·원두)만 넘긴다. 배너·매장·공지는 스위치 없이 그린다.
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
            TextButton(
              onPressed: onRetry,
              child: Text(AppLocalizations.of(context).retry),
            ),
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
              ).textTheme.bodyMedium?.copyWith(color: context.palette.muted),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context).catalogSoldOutFailed('$e'),
            ),
          ),
        );
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
          color: context.palette.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: context.palette.border),
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
                      color: soldOut
                          ? context.palette.muted
                          : context.palette.ink,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    soldOut
                        ? AppLocalizations.of(
                            context,
                          ).catalogSoldOutPrefix(widget.subtitle)
                        : widget.subtitle,
                    style: textTheme.bodySmall?.copyWith(
                      color: context.palette.muted,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (widget.soldOut != null)
              Switch(value: soldOut, onChanged: _busy ? null : _toggle)
            else
              Icon(Icons.chevron_right, color: context.palette.muted),
          ],
        ),
      ),
    );
  }
}
