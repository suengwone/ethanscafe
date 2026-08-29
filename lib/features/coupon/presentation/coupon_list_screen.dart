import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/text_utils.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/coupon_models.dart';
import 'coupon_select_sheet.dart';
import 'coupons_providers.dart';

final _dateFormat = DateFormat('yyyy.MM.dd');

class CouponListScreen extends ConsumerWidget {
  const CouponListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final couponsState = ref.watch(couponsControllerProvider);
    final now = ref.watch(couponNowProvider);

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).couponListTitle)),
      body: couponsState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(AppLocalizations.of(context).couponLoadFailed),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.invalidate(couponsControllerProvider),
                child: Text(AppLocalizations.of(context).retry),
              ),
            ],
          ),
        ),
        data: (coupons) {
          final usable = coupons
              .where((coupon) => coupon.isUsable(now))
              .toList();
          final unusable = coupons
              .where((coupon) => !coupon.isUsable(now))
              .toList();

          if (coupons.isEmpty) {
            return const _EmptyCoupons();
          }

          return ListView(
            padding: foxtrotListPadding,
            children: [
              _SectionLabel(
                label: AppLocalizations.of(
                  context,
                ).couponSectionUsable(usable.length),
              ),
              ...usable.map(
                (coupon) => _CouponCard(
                  coupon: coupon,
                  now: now,
                  onTap: () => _startUseFlow(context, ref, coupon),
                ),
              ),
              if (unusable.isNotEmpty) ...[
                const SizedBox(height: 16),
                _SectionLabel(
                  label: AppLocalizations.of(context).couponSectionSpent,
                ),
                ...unusable.map(
                  (coupon) => _CouponCard(coupon: coupon, now: now),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Future<void> _startUseFlow(
    BuildContext context,
    WidgetRef ref,
    Coupon coupon,
  ) async {
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.palette.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _CouponUseSheet(coupon: coupon),
    );
    if (confirmed != true || !context.mounted) return;

    try {
      await ref.read(couponsControllerProvider.notifier).useCoupon(coupon.id);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).couponMarkedUsed)),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).couponUseFailed)),
      );
    }
  }
}

class _EmptyCoupons extends StatelessWidget {
  const _EmptyCoupons();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.ticket, size: 48, color: context.palette.muted),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context).couponEmpty,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(label, style: Theme.of(context).textTheme.titleSmall),
    );
  }
}

class _CouponCard extends StatelessWidget {
  const _CouponCard({required this.coupon, required this.now, this.onTap});

  final Coupon coupon;
  final DateTime now;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final usable = coupon.isUsable(now);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Opacity(
          opacity: usable ? 1 : 0.5,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: context.palette.surface,
                    borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
                    border: Border.all(
                      color: usable
                          ? context.palette.accent
                          : context.palette.border,
                    ),
                  ),
                  child: Icon(
                    LucideIcons.ticket,
                    color: usable
                        ? context.palette.accent
                        : context.palette.muted,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              coupon.title.keepWord,
                              style: textTheme.labelLarge,
                            ),
                          ),
                          if (coupon.isStackable) ...[
                            const SizedBox(width: 6),
                            const CouponStackableBadge(),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        coupon.description.keepWord,
                        style: textTheme.bodySmall,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '~ ${_dateFormat.format(coupon.expiresAt)}',
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                _StatusChip(coupon: coupon, now: now),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.coupon, required this.now});

  final Coupon coupon;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final String label;
    final bool highlighted;
    if (coupon.isUsed) {
      label = AppLocalizations.of(context).couponStateUsed;
      highlighted = false;
    } else if (coupon.isExpired(now)) {
      label = AppLocalizations.of(context).couponStateExpired;
      highlighted = false;
    } else {
      label = AppLocalizations.of(context).couponStateUsable;
      highlighted = true;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: highlighted
            ? context.palette.accent.withValues(alpha: 0.15)
            : context.palette.surface,
        borderRadius: BorderRadius.circular(foxtrotRadiusSmall),
        border: highlighted ? null : Border.all(color: context.palette.border),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: highlighted
              ? context.palette.accentSoft
              : context.palette.muted,
        ),
      ),
    );
  }
}

class _CouponUseSheet extends StatelessWidget {
  const _CouponUseSheet({required this.coupon});

  final Coupon coupon;

  Future<void> _confirmUse(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).couponUseTitle),
        content: Text(AppLocalizations.of(context).couponUseConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context).commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppLocalizations.of(context).couponUseAction),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

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
            Center(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
                ),
                child: QrImageView(
                  data: 'foxtrot-coupon:${coupon.id}',
                  version: QrVersions.auto,
                  size: 180.0,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              coupon.id.toUpperCase(),
              style: textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              coupon.title.keepWord,
              style: textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              coupon.description.keepWord,
              style: textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              AppLocalizations.of(
                context,
              ).couponValidUntil(_dateFormat.format(coupon.expiresAt)),
              style: textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: context.palette.surface,
                borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
                border: Border.all(color: context.palette.border),
              ),
              child: Row(
                children: [
                  Icon(
                    LucideIcons.info,
                    color: context.palette.accent,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context).couponShowQr,
                      style: textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => _confirmUse(context),
              child: Text(AppLocalizations.of(context).couponUseButton),
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
