import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_theme.dart';

class _BannerItem {
  final String title;
  final String subtitle;
  final List<Color> colors;
  final IconData icon;

  const _BannerItem({
    required this.title,
    required this.subtitle,
    required this.colors,
    required this.icon,
  });
}

const _banners = [
  _BannerItem(
    title: '여름 시즌 신메뉴 출시',
    subtitle: '시원한 콜드브루와 함께 여름을 즐겨보세요',
    colors: [Color(0xFF8A6D2F), Color(0xFF4A3A17)],
    icon: LucideIcons.snowflake300,
  ),
  _BannerItem(
    title: '원두 정기 구독',
    subtitle: '매달 새로운 원두를 집에서 만나보세요',
    colors: [Color(0xFF5C4433), Color(0xFF2B1E14)],
    icon: LucideIcons.bean300,
  ),
  _BannerItem(
    title: '친구 초대 이벤트',
    subtitle: '친구를 초대하면 3,000P를 드려요',
    colors: [foxtrotCard, foxtrotSurface],
    icon: LucideIcons.gift300,
  ),
];

class EventBannerCarousel extends StatefulWidget {
  const EventBannerCarousel({super.key});

  @override
  State<EventBannerCarousel> createState() => _EventBannerCarouselState();
}

class _EventBannerCarouselState extends State<EventBannerCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
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
          items: _banners.map((banner) => _BannerCard(banner: banner)).toList(),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_banners.length, (index) {
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
  const _BannerCard({required this.banner});

  final _BannerItem banner;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: banner.colors,
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
            banner.icon,
            size: 48,
            color: foxtrotGoldLight.withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }
}
