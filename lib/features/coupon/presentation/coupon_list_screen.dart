import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/text_utils.dart';
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
      appBar: AppBar(title: const Text('쿠폰함')),
      body: couponsState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('쿠폰을 불러오지 못했습니다.'),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.invalidate(couponsControllerProvider),
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
        data: (coupons) {
          final usable =
              coupons.where((coupon) => coupon.isUsable(now)).toList();
          final unusable =
              coupons.where((coupon) => !coupon.isUsable(now)).toList();

          if (coupons.isEmpty) {
            return const _EmptyCoupons();
          }

          return ListView(
            padding: foxtrotListPadding,
            children: [
              _SectionLabel(label: '사용 가능 ${usable.length}장'),
              ...usable.map(
                (coupon) => _CouponCard(
                  coupon: coupon,
                  now: now,
                  onTap: () => _startUseFlow(context, ref, coupon),
                ),
              ),
              if (unusable.isNotEmpty) ...[
                const SizedBox(height: 16),
                const _SectionLabel(label: '사용 완료 · 기간 만료'),
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
      backgroundColor: foxtrotCard,
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
        const SnackBar(content: Text('쿠폰이 사용 처리되었습니다.')),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('쿠폰 사용에 실패했습니다. 다시 시도해주세요.')),
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
          const Icon(LucideIcons.ticket, size: 48, color: foxtrotMuted),
          const SizedBox(height: 16),
          Text(
            '보유한 쿠폰이 없어요',
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
                    color: foxtrotSurface,
                    borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
                    border: Border.all(
                      color: usable ? foxtrotGold : foxtrotBorder,
                    ),
                  ),
                  child: Icon(
                    LucideIcons.ticket,
                    color: usable ? foxtrotGold : foxtrotMuted,
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
      label = '사용 완료';
      highlighted = false;
    } else if (coupon.isExpired(now)) {
      label = '기간 만료';
      highlighted = false;
    } else {
      label = '사용 가능';
      highlighted = true;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: highlighted
            ? foxtrotGold.withValues(alpha: 0.15)
            : foxtrotSurface,
        borderRadius: BorderRadius.circular(foxtrotRadiusSmall),
        border: highlighted ? null : Border.all(color: foxtrotBorder),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: highlighted ? foxtrotGoldLight : foxtrotMuted,
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
        title: const Text('쿠폰 사용'),
        content: const Text(
          '매장 직원 확인 후 사용 처리해주세요.\n사용 처리된 쿠폰은 되돌릴 수 없습니다.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('사용'),
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
              '~ ${_dateFormat.format(coupon.expiresAt)}까지 사용 가능',
              style: textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: foxtrotSurface,
                borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
                border: Border.all(color: foxtrotBorder),
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.info, color: foxtrotGold, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '매장 직원에게 QR 코드를 보여주세요.\n직원 스캔·확인 후 사용하기 버튼을 눌러주세요.',
                      style: textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => _confirmUse(context),
              child: const Text('사용하기'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('닫기'),
            ),
          ],
        ),
      ),
    );
  }
}
