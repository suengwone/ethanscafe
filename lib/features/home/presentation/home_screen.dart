import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../auth/presentation/auth_providers.dart';
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
            const RewardsCard(),
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
  const _GreetingHeader({
    required this.displayName,
    required this.isLoggedIn,
  });

  final String? displayName;
  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    final name = displayName ?? '고객';
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
                  isLoggedIn ? '$name님,\n반가워요!' : '폭스트롯에\n어서오세요!',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 6),
                Text(
                  '오늘도 향긋한 커피 한 잔의 여유를 즐겨보세요',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          _CircleIconButton(
            icon: LucideIcons.mapPin,
            tooltip: '매장 찾기',
            onPressed: () => context.push('/stores'),
          ),
          const SizedBox(width: 8),
          _CircleIconButton(
            icon: LucideIcons.bell,
            tooltip: '알림',
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
              child: const Text('로그인'),
            ),
          ],
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      style: IconButton.styleFrom(
        backgroundColor: foxtrotCard,
        shape: CircleBorder(
          side: BorderSide(color: foxtrotBorder.withValues(alpha: 0.7)),
        ),
        minimumSize: const Size(40, 40),
      ),
      icon: Icon(icon, size: 18, color: foxtrotCream),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: const [
          _QuickActionItem(
            icon: LucideIcons.coffee,
            label: '주문하기',
            location: '/menu',
          ),
          SizedBox(width: 10),
          _QuickActionItem(
            icon: LucideIcons.ticketPercent,
            label: '쿠폰함',
            location: '/profile/coupons',
          ),
          SizedBox(width: 10),
          _QuickActionItem(
            icon: LucideIcons.receiptText,
            label: '주문내역',
            location: '/profile/orders',
          ),
          SizedBox(width: 10),
          _QuickActionItem(
            icon: LucideIcons.store,
            label: '매장찾기',
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
        color: foxtrotCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(foxtrotRadiusLarge),
          side: BorderSide(color: foxtrotBorder.withValues(alpha: 0.7)),
        ),
        child: InkWell(
          onTap: () => context.go(location),
          borderRadius: BorderRadius.circular(foxtrotRadiusLarge),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Column(
              children: [
                Icon(icon, size: 22, color: foxtrotGold),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: foxtrotCream,
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
