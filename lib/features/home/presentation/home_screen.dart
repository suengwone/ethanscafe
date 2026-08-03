import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
            _GreetingHeader(
              displayName: user?.displayName,
              isLoggedIn: user != null,
            ),
            const SizedBox(height: 16),
            const RewardsCard(),
            const SizedBox(height: 24),
            const EventBannerCarousel(),
            const SizedBox(height: 24),
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isLoggedIn ? '$name님, 반가워요!' : "Ethan's Cafe에 어서오세요!",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  '오늘도 향긋한 커피 한 잔의 여유를 즐겨보세요',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => context.push('/stores'),
            icon: const Icon(LucideIcons.mapPin, size: 20),
            tooltip: '매장 찾기',
          ),
          IconButton(
            onPressed: () => context.push('/notices'),
            icon: const Icon(LucideIcons.bell, size: 20),
            tooltip: '알림',
          ),
          if (!isLoggedIn)
            OutlinedButton(
              onPressed: () => context.go('/login'),
              child: const Text('로그인'),
            ),
        ],
      ),
    );
  }
}
