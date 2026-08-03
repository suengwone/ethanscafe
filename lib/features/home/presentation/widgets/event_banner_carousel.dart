import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/banner_models.dart';
import '../home_providers.dart';

const _bannerGradients = <List<Color>>[
  [Color(0xFF8A6D2F), Color(0xFF4A3A17)],
  [Color(0xFF5C4433), Color(0xFF2B1E14)],
  [foxtrotCard, foxtrotSurface],
];

IconData _bannerIcon(String icon) {
  switch (icon) {
    case 'snowflake':
      return LucideIcons.snowflake300;
    case 'bean':
      return LucideIcons.bean300;
    case 'gift':
      return LucideIcons.gift300;
    default:
      return LucideIcons.sparkles;
  }
}

class EventBannerCarousel extends ConsumerStatefulWidget {
  const EventBannerCarousel({super.key});

  @override
  ConsumerState<EventBannerCarousel> createState() =>
      _EventBannerCarouselState();
}

class _EventBannerCarouselState extends ConsumerState<EventBannerCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final banners = ref.watch(bannersProvider).asData?.value ?? const [];
    if (banners.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 140,
            viewportFraction: 0.92,
            enlargeCenterPage: true,
            enlargeFactor: 0.15,
            onPageChanged: (index, reason) {
              setState(() => _currentIndex = index);
            },
          ),
          items: [
            for (var i = 0; i < banners.length; i++)
              _BannerCard(
                banner: banners[i],
                colors: _bannerGradients[i % _bannerGradients.length],
              ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(banners.length, (index) {
            final isActive = index == _currentIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isActive ? 16 : 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: isActive
                    ? Theme.of(context).colorScheme.primary
                    : foxtrotBorder,
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _BannerCard extends StatelessWidget {
  const _BannerCard({required this.banner, required this.colors});

  final EventBanner banner;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        borderRadius: BorderRadius.circular(foxtrotRadiusLarge),
        border: Border.all(color: foxtrotGold.withValues(alpha: 0.35)),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  banner.title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: foxtrotGoldLight),
                ),
                const SizedBox(height: 6),
                Text(
                  banner.subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: foxtrotCream.withValues(alpha: 0.85),
                      ),
                ),
              ],
            ),
          ),
          Icon(
            _bannerIcon(banner.icon),
            size: 48,
            color: foxtrotGoldLight.withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }
}
