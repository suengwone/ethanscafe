import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/text_utils.dart';
import '../../../core/widgets/new_badge.dart';
import '../../../features/menu/presentation/menu_labels.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/presentation/login_required.dart';
import '../../pickup/presentation/pickup_cart_providers.dart';
import '../../pickup/presentation/pickup_cart_screen.dart';
import '../../pickup/presentation/pickup_option_sheet.dart';
import '../../review/presentation/product_review_section.dart';
import '../domain/menu_models.dart';
import 'menu_photo.dart';
import 'menu_providers.dart';

class MenuDetailScreen extends ConsumerWidget {
  const MenuDetailScreen({super.key, required this.menuId});

  final String menuId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuState = ref.watch(menuItemProvider(menuId));
    final item = menuState.asData?.value;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).menuDetailTitle),
        actions: [
          _FavoriteButton(menuId: menuId),
          const PickupCartButton(),
          const SizedBox(width: 4),
        ],
      ),
      body: menuState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(AppLocalizations.of(context).menuLoadFailed),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.invalidate(menuItemProvider(menuId)),
                child: Text(AppLocalizations.of(context).retry),
              ),
            ],
          ),
        ),
        data: (item) => _MenuDetailBody(item: item),
      ),
      bottomNavigationBar: item == null ? null : _PickupOrderBar(item: item),
    );
  }
}

class _PickupOrderBar extends ConsumerWidget {
  const _PickupOrderBar({required this.item});

  final MenuItem item;

  Future<void> _order(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    if (!requireLogin(context, ref, message: l10n.menuOrderRequiresSignIn)) {
      return;
    }

    final selection = await showPickupOptionSheet(context, item);
    if (selection == null || !context.mounted) return;

    ref
        .read(pickupCartProvider.notifier)
        .add(
          menuItem: item,
          option: selection.option,
          quantity: selection.quantity,
        );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.menuAddedToCart(item.name)),
        action: SnackBarAction(
          label: l10n.menuViewCart,
          onPressed: () => context.push('/menu/cart'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: context.palette.surface,
        border: Border(top: BorderSide(color: context.palette.border)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.soldOut
                          ? AppLocalizations.of(context).menuSoldOutNotice
                          : AppLocalizations.of(context).menuPickupOrder,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      AppLocalizations.of(context).menuPriceLabel(item),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: context.palette.accentSoft,
                      ),
                    ),
                  ],
                ),
              ),
              FilledButton.icon(
                onPressed: item.soldOut ? null : () => _order(context, ref),
                icon: const Icon(LucideIcons.coffee, size: 18),
                label: Text(
                  item.soldOut
                      ? AppLocalizations.of(context).menuSoldOut
                      : AppLocalizations.of(context).menuOrder,
                ),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
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
        color: isFavorite ? context.palette.accent : null,
      ),
      tooltip: isFavorite
          ? AppLocalizations.of(context).menuFavoriteRemove
          : AppLocalizations.of(context).menuFavoriteAdd,
      onPressed: () async {
        await ref.read(favoritesProvider.notifier).toggle(menuId);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                isFavorite
                    ? AppLocalizations.of(context).menuFavoriteRemoved
                    : AppLocalizations.of(context).menuFavoriteAdded,
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
              title: AppLocalizations.of(context).menuSectionAbout,
              child: Text(
                item.detail!.keepWord,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(height: 1.6),
              ),
            ),
            const SizedBox(height: 16),
          ],
          _InfoSection(item: item),
          if (AppLocalizations.of(context).menuCategoryNote(item.category)
              case final note?) ...[
            const SizedBox(height: 16),
            _SectionCard(
              title: AppLocalizations.of(context).menuSectionOptions,
              child: Text(
                note.keepWord,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(height: 1.6),
              ),
            ),
          ],
          const SizedBox(height: 16),
          ProductReviewSection(productId: item.id),
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
                color: context.palette.surface,
                shape: BoxShape.circle,
                border: Border.all(color: context.palette.accent, width: 1.5),
              ),
              clipBehavior: Clip.antiAlias,
              child: ProductPhoto(
                name: item.name,
                imageUrl: item.imageUrl,
                fallbackAsset: item.imageAsset,
                fallbackIcon: menuCategoryIcon(item.category),
                iconSize: 40,
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
              AppLocalizations.of(context).menuPriceLabel(item),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: context.palette.accentSoft,
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
        color: context.palette.accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 13, color: context.palette.accentSoft),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({required this.item});

  final MenuItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _SectionCard(
      title: l10n.menuSectionDetails,
      child: Column(
        children: [
          _InfoRow(
            label: l10n.menuFieldCategory,
            value: l10n.menuCategoryLabel(item.category),
          ),
          _InfoRow(
            label: l10n.menuFieldPrice,
            value: l10n.menuPriceLabel(item),
          ),
          if (item.servingOptions.isNotEmpty)
            _InfoRow(
              label: l10n.menuFieldServingOptions,
              value: item.servingOptions.join(' · '),
            ),
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
          SizedBox(width: 72, child: Text(label, style: textTheme.bodySmall)),
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
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
        border: Border.all(color: context.palette.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: ProductPhoto(
        name: item.name,
        imageUrl: item.imageUrl,
        fallbackAsset: item.imageAsset,
        fallbackIcon: menuCategoryIcon(item.category),
        iconSize: size * 0.45,
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
