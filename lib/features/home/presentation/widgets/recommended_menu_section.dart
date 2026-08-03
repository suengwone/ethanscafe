import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/new_badge.dart';

class _RecommendedItem {
  final String name;
  final String price;
  final IconData icon;
  final bool isNew;
  final bool isHit;

  const _RecommendedItem({
    required this.name,
    required this.price,
    required this.icon,
    this.isNew = false,
    this.isHit = false,
  });
}

const _recommendedItems = [
  _RecommendedItem(
    name: '니카라과 핀카 리브레 게이샤',
    price: '6,800원',
    icon: LucideIcons.bean,
    isNew: true,
  ),
  _RecommendedItem(
    name: '플랫 화이트',
    price: '5,500원',
    icon: LucideIcons.coffee,
    isHit: true,
  ),
  _RecommendedItem(
    name: '딸기 라떼',
    price: '6,000원',
    icon: LucideIcons.cupSoda,
    isHit: true,
  ),
  _RecommendedItem(
    name: '과일 주스',
    price: '6,000원',
    icon: LucideIcons.milk,
    isNew: true,
  ),
  _RecommendedItem(
    name: '블루베리 베이글',
    price: '4,300원',
    icon: LucideIcons.croissant,
    isHit: true,
  ),
];

class RecommendedMenuSection extends StatelessWidget {
  const RecommendedMenuSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                '이 메뉴 어때요?',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              TextButton(
                onPressed: () => context.go('/menu'),
                child: const Text('전체보기'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 170,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: _recommendedItems.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) =>
                _RecommendedCard(item: _recommendedItems[index]),
          ),
        ),
      ],
    );
  }
}

class _RecommendedCard extends StatelessWidget {
  const _RecommendedCard({required this.item});

  final _RecommendedItem item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: foxtrotCard,
        borderRadius: BorderRadius.circular(foxtrotRadiusLarge),
        border: Border.all(color: foxtrotBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: foxtrotSurface,
                child: Icon(item.icon, size: 30, color: colorScheme.primary),
              ),
              if (item.isNew)
                const Positioned(
                  right: 0,
                  top: 0,
                  child: NewBadge(),
                ),
              if (item.isHit)
                const Positioned(
                  right: 0,
                  top: 0,
                  child: HitBadge(),
                ),
            ],
          ),
          const Spacer(),
          Text(
            item.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 2),
          Text(
            item.price,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
