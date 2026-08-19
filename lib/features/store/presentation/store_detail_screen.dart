import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/text_utils.dart';
import '../domain/store_models.dart';
import 'store_widgets.dart';
import 'stores_providers.dart';

/// 매장 한 곳의 상세 — 오늘 영업 여부, 매장 공지, 편의시설.
class StoreDetailScreen extends ConsumerWidget {
  const StoreDetailScreen({super.key, required this.storeId});

  final String storeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storesState = ref.watch(storesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('매장 정보')),
      body: storesState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('매장 정보를 불러오지 못했습니다.'),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.invalidate(storesProvider),
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
        data: (stores) {
          final store = stores.where((s) => s.id == storeId).firstOrNull;
          if (store == null) {
            return const Center(child: Text('문 닫은 매장이거나 없는 매장입니다.'));
          }
          final now = ref.watch(storeClockProvider)();
          final distance = ref.watch(storeDistancesProvider).asData?.value;
          return _StoreDetail(
            store: store,
            now: now,
            distanceMeters: distance?[store.id],
          );
        },
      ),
    );
  }
}

class _StoreDetail extends StatelessWidget {
  const _StoreDetail({
    required this.store,
    required this.now,
    this.distanceMeters,
  });

  final CafeStore store;
  final DateTime now;
  final double? distanceMeters;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final todayHours = store.hoursOn(now);

    return ListView(
      padding: foxtrotListPadding,
      children: [
        const SizedBox(height: 8),
        Text(store.name.keepWord, style: textTheme.titleLarge),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            StoreOpenBadge(store: store, now: now),
            StoreCongestionBadge(store: store, now: now),
            if (distanceMeters != null)
              StoreBadge(
                label: '내 위치에서 ${storeDistanceLabel(distanceMeters!)}',
                color: context.palette.accentSoft,
              ),
          ],
        ),
        if (store.notice.isNotEmpty) ...[
          const SizedBox(height: 16),
          _NoticeCard(notice: store.notice),
        ],
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StoreInfoRow(icon: LucideIcons.mapPin, text: store.address),
                const SizedBox(height: 8),
                StoreInfoRow(icon: LucideIcons.phone, text: store.phone),
                const SizedBox(height: 8),
                StoreInfoRow(
                  icon: LucideIcons.clock,
                  text: todayHours.isEmpty
                      ? '영업시간 정보가 없습니다.'
                      : '오늘 $todayHours',
                ),
                const SizedBox(height: 12),
                StoreActionRow(store: store),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text('영업시간', style: textTheme.titleMedium),
        const SizedBox(height: 8),
        _HoursRow(label: '평일', hours: store.weekdayHours),
        const SizedBox(height: 4),
        _HoursRow(label: '주말', hours: store.weekendHours),
        if (store.services.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text('편의시설', style: textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: store.services
                .map((service) => StoreServiceChip(label: service))
                .toList(),
          ),
        ],
      ],
    );
  }
}

class _NoticeCard extends StatelessWidget {
  const _NoticeCard({required this.notice});

  final String notice;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.palette.accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(foxtrotRadiusSmall),
        border: Border.all(color: context.palette.accent.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(LucideIcons.megaphone, size: 16, color: context.palette.accent),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '매장 공지',
                  style: TextStyle(fontSize: 12, color: context.palette.accentSoft),
                ),
                const SizedBox(height: 4),
                Text(
                  notice.keepWord,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HoursRow extends StatelessWidget {
  const _HoursRow({required this.label, required this.hours});

  final String label;
  final String hours;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        SizedBox(
          width: 48,
          child: Text(label, style: textTheme.bodySmall),
        ),
        Expanded(
          child: Text(
            hours.isEmpty ? '정보 없음' : hours,
            style: textTheme.bodySmall?.copyWith(color: context.palette.ink),
          ),
        ),
      ],
    );
  }
}
