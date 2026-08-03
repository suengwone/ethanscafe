import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class NewBadge extends StatelessWidget {
  const NewBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: foxtrotGold,
        borderRadius: BorderRadius.circular(foxtrotRadiusSmall),
      ),
      child: const Text(
        'NEW',
        style: TextStyle(
          color: foxtrotBlack,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class HitBadge extends StatelessWidget {
  const HitBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: foxtrotGold),
        borderRadius: BorderRadius.circular(foxtrotRadiusSmall),
      ),
      child: const Text(
        'HIT',
        style: TextStyle(
          color: foxtrotGold,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
