import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';

class _RecommendedItem {
  final String name;
  final String price;
  final IconData icon;
  final bool isNew;

  const _RecommendedItem({
    required this.name,
    required this.price,
    required this.icon,
    this.isNew = false,
  });
}

const _recommendedItems = [
  _RecommendedItem(
    name: '플랫화이트',
    price: '5,500원',
    icon: Icons.coffee,
    isNew: true,
  ),
  _RecommendedItem(
    name: '토피넛 라떼',
    price: '5,500원',
    icon: Icons.emoji_food_beverage,
    isNew: true,
  ),
  _RecommendedItem(
    name: '아메리카노',
    price: '4,500원',
    icon: Icons.coffee_outlined,
  ),
  _RecommendedItem(
    name: '크로플',
    price: '6,500원',
    icon: Icons.bakery_dining,
  ),
  _RecommendedItem(
    name: '브라질 산토스',
    price: '14,000원',
    icon: Icons.grain,
    isNew: true,
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
              const Text(
                '이 메뉴 어때요?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
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
        borderRadius: BorderRadius.circular(16),
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
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: foxtrotGold,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'NEW',
                      style: TextStyle(
                        color: foxtrotBlack,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const Spacer(),
          Text(
            item.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            item.price,
            style: const TextStyle(
              fontSize: 13,
              color: foxtrotMuted,
            ),
          ),
        ],
      ),
    );
  }
}
