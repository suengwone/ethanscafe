import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

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
    colors: [Color(0xFF1E88A8), Color(0xFF0B5468)],
    icon: Icons.ac_unit,
  ),
  _BannerItem(
    title: '원두 정기 구독',
    subtitle: '매달 새로운 원두를 집에서 만나보세요',
    colors: [Color(0xFF6D4C41), Color(0xFF3E2723)],
    icon: Icons.coffee,
  ),
  _BannerItem(
    title: '친구 초대 이벤트',
    subtitle: '친구를 초대하면 3,000P를 드려요',
    colors: [Color(0xFF00704A), Color(0xFF004E33)],
    icon: Icons.card_giftcard,
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
                    : Colors.grey.shade300,
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
        borderRadius: BorderRadius.circular(16),
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  banner.subtitle,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            banner.icon,
            size: 48,
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }
}
