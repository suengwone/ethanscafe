import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../theme/app_theme.dart';

class NewBadge extends StatelessWidget {
  const NewBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: context.palette.accent,
        borderRadius: BorderRadius.circular(foxtrotRadiusSmall),
      ),
      child: Text(
        'NEW',
        style: TextStyle(
          color: context.palette.onAccent,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class BestBadge extends StatelessWidget {
  const BestBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: context.palette.accentSoft,
        borderRadius: BorderRadius.circular(foxtrotRadiusSmall),
      ),
      child: Text(
        'BEST',
        style: TextStyle(
          color: context.palette.onAccent,
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
        border: Border.all(color: context.palette.accent),
        borderRadius: BorderRadius.circular(foxtrotRadiusSmall),
      ),
      child: Text(
        'HIT',
        style: TextStyle(
          color: context.palette.accent,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// 재료가 떨어져 오늘 판매하지 않는 상품. 다른 배지와 달리 눈에 덜 띄게 둔다.
class SoldOutBadge extends StatelessWidget {
  const SoldOutBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: context.palette.muted,
        borderRadius: BorderRadius.circular(foxtrotRadiusSmall),
      ),
      child: Text(
        AppLocalizations.of(context).badgeSoldOut,
        style: TextStyle(
          color: context.palette.onAccent,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
