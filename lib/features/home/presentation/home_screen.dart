import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/circle_icon_button.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/presentation/auth_providers.dart';
import '../../notification/presentation/notification_bell_button.dart';
import 'widgets/event_banner_carousel.dart';
import 'widgets/recommended_menu_section.dart';
import 'widgets/rewards_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).asData?.value;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          children: [
            _GreetingHeader(
              displayName: user?.displayName,
              isLoggedIn: user != null,
            ),
            const SizedBox(height: 20),
            if (user != null) const RewardsCard() else const GuestRewardsCard(),
            const SizedBox(height: 16),
            const _QuickActions(),
            const SizedBox(height: 28),
            const EventBannerCarousel(),
            const SizedBox(height: 28),
            const RecommendedMenuSection(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _GreetingHeader extends StatelessWidget {
  const _GreetingHeader({required this.displayName, required this.isLoggedIn});

  final String? displayName;
  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final name = displayName ?? l10n.homeGreetingGuestName;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isLoggedIn
                      ? l10n.homeGreetingMember(name)
                      : l10n.homeGreetingVisitor,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.homeGreetingSubtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          CircleIconButton(
            icon: LucideIcons.mapPin,
            tooltip: l10n.homeFindStore,
            onPressed: () => context.push('/stores'),
          ),
          const SizedBox(width: 8),
          // 회원은 자기 알림함으로, 게스트는 알림함이 빌 수밖에 없으니 공지로 보낸다.
          if (isLoggedIn)
            const NotificationBellButton()
          else
            CircleIconButton(
              icon: LucideIcons.bell,
              tooltip: l10n.noticeListTitle,
              onPressed: () => context.push('/notices'),
            ),
          if (!isLoggedIn) ...[
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: () => context.go('/login'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 40),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: Text(l10n.homeSignIn),
            ),
          ],
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _QuickActionItem(
            icon: LucideIcons.coffee,
            label: l10n.homeQuickOrder,
            location: '/menu',
          ),
          const SizedBox(width: 10),
          _QuickActionItem(
            icon: LucideIcons.ticketPercent,
            label: l10n.homeQuickCoupons,
            location: '/profile/coupons',
          ),
          const SizedBox(width: 10),
          _QuickActionItem(
            icon: LucideIcons.receiptText,
            label: l10n.homeQuickOrderHistory,
            location: '/profile/orders',
          ),
          const SizedBox(width: 10),
          _QuickActionItem(
            icon: LucideIcons.store,
            label: l10n.homeQuickStores,
            location: '/stores',
          ),
        ],
      ),
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  const _QuickActionItem({
    required this.icon,
    required this.label,
    required this.location,
  });

  final IconData icon;
  final String label;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: context.palette.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(foxtrotRadiusLarge),
          side: BorderSide(
            color: context.palette.border.withValues(alpha: 0.7),
          ),
        ),
        child: InkWell(
          onTap: () => context.go(location),
          borderRadius: BorderRadius.circular(foxtrotRadiusLarge),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Column(
              children: [
                Icon(icon, size: 22, color: context.palette.accent),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.palette.ink,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
