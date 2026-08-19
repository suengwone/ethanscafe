import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/text_utils.dart';
import '../../domain/banner_models.dart';
import '../banner_icons.dart';
import '../home_providers.dart';

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
                colors: context.palette.bannerGradients[i % context.palette.bannerGradients.length],
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
                    : context.palette.border,
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
        border: Border.all(color: context.palette.accent.withValues(alpha: 0.35)),
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
                  banner.title.keepWord,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: context.palette.accentSoft),
                ),
                const SizedBox(height: 6),
                Text(
                  banner.subtitle.keepWord,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.palette.ink.withValues(alpha: 0.85),
                      ),
                ),
              ],
            ),
          ),
          Icon(
            bannerIcon(banner.icon),
            size: 48,
            color: context.palette.accentSoft.withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }
}
