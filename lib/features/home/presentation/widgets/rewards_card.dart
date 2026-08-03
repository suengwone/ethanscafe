import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../points/presentation/points_providers.dart';

const int rewardGoal = 5000;

final _pointFormat = NumberFormat('#,###');

class RewardsCard extends ConsumerWidget {
  const RewardsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance =
        ref.watch(pointsControllerProvider).asData?.value.balance ?? 0;
    final progress = (balance / rewardGoal).clamp(0.0, 1.0);
    final remaining = rewardGoal - balance;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [cafeGreen, cafeDarkGreen],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: InkWell(
            onTap: () => context.go('/points'),
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: cafeGold, size: 20),
                      const SizedBox(width: 6),
                      const Text(
                        '나의 리워드',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${_pointFormat.format(balance)}P',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 6,
                      backgroundColor: Colors.white.withValues(alpha: 0.25),
                      valueColor: const AlwaysStoppedAnimation<Color>(cafeGold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    remaining > 0
                        ? '${_pointFormat.format(remaining)}P 더 모으면 무료 음료 쿠폰!'
                        : '무료 음료 쿠폰으로 교환할 수 있어요!',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
