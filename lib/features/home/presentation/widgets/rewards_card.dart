import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/text_utils.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../points/presentation/points_providers.dart';

const int rewardGoal = 5000;

final _pointFormat = NumberFormat('#,###');

class GuestRewardsCard extends StatelessWidget {
  const GuestRewardsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [context.palette.card, context.palette.surface],
            ),
            borderRadius: BorderRadius.circular(foxtrotRadiusLarge),
            border: Border.all(color: context.palette.accent.withValues(alpha: 0.45)),
            boxShadow: context.palette.cardShadow,
          ),
          child: InkWell(
            onTap: () => context.go('/login'),
            borderRadius: BorderRadius.circular(foxtrotRadiusLarge),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        LucideIcons.sparkles,
                        color: context.palette.accent,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        l10n.homeRewardsTitle,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const Spacer(),
                      Icon(
                        LucideIcons.chevronRight,
                        color: context.palette.muted,
                        size: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.homeRewardsSignInPrompt.keepWord,
                    style: TextStyle(
                      color: context.palette.accentSoft,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n
                        .homeRewardsSignInDetail(
                          _pointFormat.format(rewardGoal),
                        )
                        .keepWord,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 14),
                  FilledButton.icon(
                    onPressed: () => context.go('/login'),
                    icon: const Icon(LucideIcons.logIn, size: 18),
                    label: Text(l10n.homeRewardsSignInAction),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(44),
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

class RewardsCard extends ConsumerWidget {
  const RewardsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final balance =
        ref.watch(pointsControllerProvider).asData?.value.balance ?? 0;
    final progress = (balance / rewardGoal).clamp(0.0, 1.0);
    final remaining = rewardGoal - balance;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [context.palette.card, context.palette.surface],
            ),
            borderRadius: BorderRadius.circular(foxtrotRadiusLarge),
            border: Border.all(color: context.palette.accent.withValues(alpha: 0.45)),
            boxShadow: context.palette.cardShadow,
          ),
          child: InkWell(
            onTap: () => context.go('/points'),
            borderRadius: BorderRadius.circular(foxtrotRadiusLarge),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        LucideIcons.sparkles,
                        color: context.palette.accent,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        l10n.homeRewardsMineTitle,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const Spacer(),
                      Icon(
                        LucideIcons.chevronRight,
                        color: context.palette.muted,
                        size: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.homeRewardsBalance(_pointFormat.format(balance)),
                    style: TextStyle(
                      color: context.palette.accentSoft,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(foxtrotRadiusSmall),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: context.palette.border,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(context.palette.accent),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    (remaining > 0
                            ? l10n.homeRewardsRemaining(
                                _pointFormat.format(remaining),
                              )
                            : l10n.homeRewardsGoalReached)
                        .keepWord,
                    style: Theme.of(context).textTheme.bodySmall,
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
