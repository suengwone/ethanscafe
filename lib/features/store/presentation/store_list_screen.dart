import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/text_utils.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/location_failure.dart';
import '../domain/store_models.dart';
import 'store_widgets.dart';
import 'stores_providers.dart';

class StoreListScreen extends ConsumerWidget {
  const StoreListScreen({super.key});

  Future<void> _locate(BuildContext context, WidgetRef ref) async {
    await ref
        .read(storeDistancesProvider.notifier)
        .refreshFromCurrentLocation();
    if (!context.mounted) return;

    final error = ref.read(storeDistancesProvider).error;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _locationErrorMessage(AppLocalizations.of(context), error),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storesState = ref.watch(storesProvider);
    final distancesState = ref.watch(storeDistancesProvider);
    final l10n = AppLocalizations.of(context);
    final distances = distancesState.asData?.value;
    final activity = ref.watch(storeActivityProvider).asData?.value;
    final now = ref.watch(storeClockProvider)();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.storeListTitle),
        actions: [
          IconButton(
            icon: distancesState.isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(LucideIcons.locateFixed),
            tooltip: l10n.storeSortByDistance,
            onPressed: distancesState.isLoading
                ? null
                : () => _locate(context, ref),
          ),
        ],
      ),
      body: storesState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.storeLoadFailed),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.invalidate(storesProvider),
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
        data: (stores) {
          final sorted = [...stores];
          if (distances != null) {
            sorted.sort(
              (a, b) => (distances[a.id] ?? double.infinity).compareTo(
                distances[b.id] ?? double.infinity,
              ),
            );
          }
          return ListView.builder(
            padding: foxtrotListPadding,
            itemCount: sorted.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 12),
                  child: Text(
                    (distances == null
                            ? l10n.storeSortHint
                            : l10n.storeSortedByDistance)
                        .keepWord,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              }
              final store = sorted[index - 1];
              return _StoreCard(
                store: store,
                now: now,
                distanceMeters: distances?[store.id],
                activity: activity?[store.id],
              );
            },
          );
        },
      ),
    );
  }
}

class _StoreCard extends StatelessWidget {
  const _StoreCard({
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

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(foxtrotRadiusSmall),
        onTap: () => context.push('/stores/${store.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      store.name.keepWord,
                      style: textTheme.titleMedium,
                    ),
                  ),
                  if (distanceMeters != null)
                    StoreBadge(
                      label: storeDistanceLabel(distanceMeters!),
                      color: context.palette.accentSoft,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  StoreOpenBadge(store: store, now: now),
                  StoreCongestionBadge(
                    store: store,
                    now: now,
                    activity: activity,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              StoreInfoRow(icon: LucideIcons.mapPin, text: store.address),
              const SizedBox(height: 4),
              StoreInfoRow(
                icon: LucideIcons.clock,
                text: AppLocalizations.of(
                  context,
                ).storeHoursSummary(store.weekdayHours, store.weekendHours),
              ),
              const SizedBox(height: 4),
              StoreInfoRow(icon: LucideIcons.phone, text: store.phone),
              if (store.notice.isNotEmpty) ...[
                const SizedBox(height: 4),
                StoreInfoRow(icon: LucideIcons.megaphone, text: store.notice),
              ],
              if (store.services.isNotEmpty) ...[
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: store.services
                      .map((service) => StoreServiceChip(label: service))
                      .toList(),
                ),
              ],
              const SizedBox(height: 12),
              StoreActionRow(store: store),
            ],
          ),
        ),
      ),
    );
  }
}

String _locationErrorMessage(AppLocalizations l10n, Object error) {
  if (error is! LocationUnavailable) {
    return l10n.storeLocationUnavailable;
  }
  return switch (error.reason) {
    LocationFailure.serviceOff => l10n.storeLocationServiceOff,
    LocationFailure.permissionDenied => l10n.storeLocationPermissionDenied,
  };
}
