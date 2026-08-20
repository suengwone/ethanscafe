import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/text_utils.dart';
import '../domain/store_models.dart';

/// 매장 목록과 매장 상세가 함께 쓰는 조각들.

String storeDistanceLabel(double meters) {
  if (meters < 1000) {
    return '${meters.round()}m';
  }
  return '${(meters / 1000).toStringAsFixed(1)}km';
}

Future<void> callStore(BuildContext context, CafeStore store) async {
  final uri = Uri(scheme: 'tel', path: store.phone.replaceAll('-', ''));
  final launched = await canLaunchUrl(uri) && await launchUrl(uri);
  if (!launched && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('전화 연결에 실패했습니다: ${store.phone}')),
    );
  }
}

Future<void> openStoreMap(BuildContext context, CafeStore store) async {
  final uri = Uri.https('maps.google.com', '/', {
    'q': '${store.latitude},${store.longitude}',
  });
  final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!launched && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('지도를 열 수 없습니다.')),
    );
  }
}

class StoreBadge extends StatelessWidget {
  const StoreBadge({super.key, required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(foxtrotRadiusSmall),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, color: color),
      ),
    );
  }
}

/// 오늘 영업시간 기준 열림/닫힘. 시간을 해석할 수 없으면 아무것도 안 보인다.
class StoreOpenBadge extends StatelessWidget {
  const StoreOpenBadge({super.key, required this.store, required this.now});

  final CafeStore store;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final isOpen = store.isOpenAt(now);
    if (isOpen == null) {
      return const SizedBox.shrink();
    }
    return StoreBadge(
      label: isOpen ? '영업 중' : '영업 종료',
      color: isOpen ? context.palette.accentSoft : context.palette.muted,
    );
  }
}

/// 혼잡도 뱃지. 직원이 올린 값이 먼저고, 없으면 진행 중인 주문으로 잰 값을 쓴다.
/// 둘 다 없거나 낡았으면 아무것도 안 보인다.
class StoreCongestionBadge extends StatelessWidget {
  const StoreCongestionBadge({
    super.key,
    required this.store,
    required this.now,
    this.activity,
  });

  final CafeStore store;
  final DateTime now;
  final StoreActivity? activity;

  Color? _color(StoreCongestion? congestion, FoxtrotPalette palette) {
    return switch (congestion) {
      StoreCongestion.relaxed => palette.accentSoft,
      StoreCongestion.normal => palette.accent,
      StoreCongestion.busy => palette.danger,
      _ => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    final view = store.congestionViewAt(now, activity: activity);
    final color = _color(view.congestion, context.palette);
    if (color == null) {
      return const SizedBox.shrink();
    }
    return StoreBadge(label: '현재 ${view.congestion.label}', color: color);
  }
}

class StoreInfoRow extends StatelessWidget {
  const StoreInfoRow({super.key, required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: context.palette.accent),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text.keepWord,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}

class StoreServiceChip extends StatelessWidget {
  const StoreServiceChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: context.palette.accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(foxtrotRadiusSmall),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, color: context.palette.accentSoft),
      ),
    );
  }
}

/// 전화·지도 버튼 한 줄.
class StoreActionRow extends StatelessWidget {
  const StoreActionRow({super.key, required this.store});

  final CafeStore store;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => callStore(context, store),
            icon: const Icon(LucideIcons.phone, size: 16),
            label: const Text('전화'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => openStoreMap(context, store),
            icon: const Icon(LucideIcons.map, size: 16),
            label: const Text('지도 보기'),
          ),
        ),
      ],
    );
  }
}
