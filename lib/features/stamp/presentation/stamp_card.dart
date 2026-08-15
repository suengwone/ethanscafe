import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../domain/stamp_reward.dart';
import 'stamp_providers.dart';

class StampCardSection extends ConsumerWidget {
  const StampCardSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stampState = ref.watch(stampControllerProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: stampState.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (error, _) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('스탬프 정보를 불러오지 못했습니다.'),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.invalidate(stampControllerProvider),
                child: const Text('다시 시도'),
              ),
            ],
          ),
          data: (data) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '스탬프 카드',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  Text(
                    '${data.count} / $stampRewardThreshold',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(color: foxtrotGold),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '음료 $stampRewardThreshold잔을 마시면 무료 음료 쿠폰을 드려요.\n'
                '키오스크 결제 후 직원에게 멤버십 QR을 보여주세요.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              _StampGrid(count: data.count),
              if (data.totalEarned > 0) ...[
                const SizedBox(height: 12),
                Text(
                  '지금까지 모은 스탬프 ${data.totalEarned}개',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StampGrid extends StatelessWidget {
  const _StampGrid({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(stampRewardThreshold, (index) {
        final filled = index < count;
        return Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: filled ? foxtrotGold : Colors.transparent,
            border: Border.all(
              color: filled
                  ? foxtrotGold
                  : Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          child: Icon(
            LucideIcons.coffee,
            size: 14,
            color: filled
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.outlineVariant,
          ),
        );
      }),
    );
  }
}
