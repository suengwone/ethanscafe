import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/text_utils.dart';
import '../../../l10n/app_localizations.dart';
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
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).storeDetailTitle),
      ),
      body: storesState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(AppLocalizations.of(context).storeLoadFailed),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.invalidate(storesProvider),
                child: Text(AppLocalizations.of(context).retry),
              ),
            ],
          ),
        ),
        data: (stores) {
          final store = stores.where((s) => s.id == storeId).firstOrNull;
          if (store == null) {
            return Center(
              child: Text(AppLocalizations.of(context).storeNotFound),
            );
          }
          final now = ref.watch(storeClockProvider)();
          final distance = ref.watch(storeDistancesProvider).asData?.value;
          final activity = ref.watch(storeActivityProvider).asData?.value;
          return _StoreDetail(
            store: store,
            now: now,
            distanceMeters: distance?[store.id],
            activity: activity?[store.id],
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
    this.activity,
  });

  final CafeStore store;
  final DateTime now;
  final double? distanceMeters;
  final StoreActivity? activity;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final todayHours = store.hoursOn(now);
    final congestion = store.congestionViewAt(now, activity: activity);

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
            StoreCongestionBadge(store: store, now: now, activity: activity),
            if (distanceMeters != null)
              StoreBadge(
                label: AppLocalizations.of(
                  context,
                ).storeDistanceFromYou(storeDistanceLabel(distanceMeters!)),
                color: context.palette.accentSoft,
              ),
          ],
        ),
        // 자동으로 잰 값은 직원이 올린 값과 성격이 달라서 근거를 같이 밝힌다.
        if (congestion.isLive) ...[
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(
              context,
            ).storeCongestionMeasured(congestion.liveOrders ?? 0).keepWord,
            style: textTheme.bodySmall,
          ),
        ],
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
                      ? AppLocalizations.of(context).storeHoursUnknown
                      : AppLocalizations.of(
                          context,
                        ).storeHoursToday(todayHours),
                ),
                const SizedBox(height: 12),
                StoreActionRow(store: store),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          AppLocalizations.of(context).storeSectionHours,
          style: textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        _HoursRow(
          label: AppLocalizations.of(context).storeHoursWeekday,
          hours: store.weekdayHours,
        ),
        const SizedBox(height: 4),
        _HoursRow(
          label: AppLocalizations.of(context).storeHoursWeekend,
          hours: store.weekendHours,
        ),
        if (store.services.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text(
            AppLocalizations.of(context).storeSectionFacilities,
            style: textTheme.titleMedium,
          ),
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
        border: Border.all(
          color: context.palette.accent.withValues(alpha: 0.4),
        ),
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
                  AppLocalizations.of(context).storeNoticeTitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: context.palette.accentSoft,
                  ),
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
        SizedBox(width: 48, child: Text(label, style: textTheme.bodySmall)),
        Expanded(
          child: Text(
            hours.isEmpty ? AppLocalizations.of(context).storeNoInfo : hours,
            style: textTheme.bodySmall?.copyWith(color: context.palette.ink),
          ),
        ),
      ],
    );
  }
}
