import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../domain/coupon_models.dart';
import 'coupons_providers.dart';

final _dateFormat = DateFormat('yyyy.MM.dd');

class CouponListScreen extends ConsumerWidget {
  const CouponListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final couponsState = ref.watch(couponsProvider);
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
                onPressed: () => ref.invalidate(couponsProvider),
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            children: [
              _SectionLabel(label: '사용 가능 ${usable.length}장'),
              ...usable.map(
                (coupon) => _CouponCard(coupon: coupon, now: now),
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
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
      child: Text(label, style: Theme.of(context).textTheme.titleSmall),
    );
  }
}

class _CouponCard extends StatelessWidget {
  const _CouponCard({required this.coupon, required this.now});

  final Coupon coupon;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final usable = coupon.isUsable(now);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
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
                    Text(coupon.title, style: textTheme.labelLarge),
                    const SizedBox(height: 4),
                    Text(coupon.description, style: textTheme.bodySmall),
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
