import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/text_utils.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/coupon_models.dart';

final _priceFormat = NumberFormat('#,###');

Future<List<Coupon>?> showCouponSelectSheet({
  required BuildContext context,
  required List<Coupon> coupons,
  required List<Coupon> selected,
  required int orderAmount,
}) {
  return showModalBottomSheet<List<Coupon>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.palette.card,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => CouponSelectSheet(
      coupons: coupons,
      selected: selected,
      orderAmount: orderAmount,
    ),
  );
}

class CouponSelectSheet extends StatefulWidget {
  const CouponSelectSheet({
    super.key,
    required this.coupons,
    required this.selected,
    required this.orderAmount,
  });

  final List<Coupon> coupons;
  final List<Coupon> selected;
  final int orderAmount;

  @override
  State<CouponSelectSheet> createState() => _CouponSelectSheetState();
}

class _CouponSelectSheetState extends State<CouponSelectSheet> {
  late final List<Coupon> _selected = [...widget.selected];

  bool _isSelected(Coupon coupon) =>
      _selected.any((candidate) => candidate.id == coupon.id);

  void _toggle(Coupon coupon) {
    setState(() {
      if (_isSelected(coupon)) {
        _selected.removeWhere((candidate) => candidate.id == coupon.id);
        return;
      }
      if (!coupon.isStackable) {
        _selected.removeWhere((candidate) => !candidate.isStackable);
      }
      _selected.add(coupon);
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final discount = totalCouponDiscount(_selected, widget.orderAmount);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          foxtrotScreenHPadding,
          20,
          foxtrotScreenHPadding,
          16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(AppLocalizations.of(context).couponSelectTitle, style: textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              AppLocalizations.of(context).couponSelectNotice,
              style: textTheme.bodySmall,
            ),
            const SizedBox(height: 14),
            _CouponOptionCard(
              title: AppLocalizations.of(context).couponSelectNone,
              highlighted: _selected.isEmpty,
              onTap: () => setState(_selected.clear),
            ),
            ...widget.coupons.map(
              (coupon) => _CouponOptionCard(
                title: coupon.title,
                description: coupon.description,
                stackable: coupon.isStackable,
                trailing: '-${_priceFormat.format(
                  coupon.discountFor(widget.orderAmount),
                )}원',
                highlighted: _isSelected(coupon),
                onTap: () => _toggle(coupon),
              ),
            ),
            const SizedBox(height: 14),
            FilledButton(
              onPressed: () => Navigator.pop(context, List.of(_selected)),
              child: Text(
                discount > 0
                    ? AppLocalizations.of(context).couponSelectApplyWithDiscount(
                        _priceFormat.format(discount),
                      )
                    : AppLocalizations.of(context).couponSelectApply,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context).commonClose),
            ),
          ],
        ),
      ),
    );
  }
}

class CouponStackableBadge extends StatelessWidget {
  const CouponStackableBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: context.palette.accent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(foxtrotRadiusSmall),
      ),
      child: Text(
        AppLocalizations.of(context).couponStackable,
        style: TextStyle(fontSize: 10, color: context.palette.accentSoft),
      ),
    );
  }
}

class _CouponOptionCard extends StatelessWidget {
  const _CouponOptionCard({
    required this.title,
    this.description,
    this.trailing,
    this.stackable = false,
    required this.highlighted,
    required this.onTap,
  });

  final String title;
  final String? description;
  final String? trailing;
  final bool stackable;
  final bool highlighted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
        side: BorderSide(color: highlighted ? context.palette.accent : context.palette.border),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Icon(
                highlighted ? LucideIcons.circleCheck : LucideIcons.ticket,
                size: 20,
                color: highlighted ? context.palette.accent : context.palette.muted,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            title.keepWord,
                            style: textTheme.labelLarge,
                          ),
                        ),
                        if (stackable) ...[
                          const SizedBox(width: 6),
                          const CouponStackableBadge(),
                        ],
                      ],
                    ),
                    if (description != null) ...[
                      const SizedBox(height: 3),
                      Text(description!.keepWord, style: textTheme.bodySmall),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 10),
                Text(
                  trailing!,
                  style: textTheme.labelLarge?.copyWith(color: context.palette.accent),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
