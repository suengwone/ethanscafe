import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/text_utils.dart';
import '../domain/store_models.dart';
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
            error is StateError ? error.message : '현재 위치를 확인할 수 없습니다.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storesState = ref.watch(storesProvider);
    final distancesState = ref.watch(storeDistancesProvider);
    final distances = distancesState.asData?.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('매장 찾기'),
        actions: [
          IconButton(
            icon: distancesState.isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(LucideIcons.locateFixed),
            tooltip: '내 주변 거리 보기',
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
          final sorted = [...stores];
          if (distances != null) {
            sorted.sort(
              (a, b) => (distances[a.id] ?? double.infinity)
                  .compareTo(distances[b.id] ?? double.infinity),
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
                            ? '우측 상단 버튼을 누르면 내 위치에서 가까운 순으로 정렬됩니다.'
                            : '내 위치에서 가까운 순으로 정렬되었습니다.')
                        .keepWord,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              }
              final store = sorted[index - 1];
              return _StoreCard(
                store: store,
                distanceMeters: distances?[store.id],
              );
            },
          );
        },
      ),
    );
  }
}

class _StoreCard extends StatelessWidget {
  const _StoreCard({required this.store, this.distanceMeters});

  final CafeStore store;
  final double? distanceMeters;

  String get _distanceLabel {
    final meters = distanceMeters!;
    if (meters < 1000) {
      return '${meters.round()}m';
    }
    return '${(meters / 1000).toStringAsFixed(1)}km';
  }

  Future<void> _call(BuildContext context) async {
    final uri = Uri(scheme: 'tel', path: store.phone.replaceAll('-', ''));
    final launched = await canLaunchUrl(uri) && await launchUrl(uri);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('전화 연결에 실패했습니다: ${store.phone}')),
      );
    }
  }

  Future<void> _openMap(BuildContext context) async {
    final uri = Uri.https('maps.google.com', '/', {
      'q': '${store.latitude},${store.longitude}',
    });
    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('지도를 열 수 없습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: foxtrotGold.withValues(alpha: 0.15),
                      borderRadius:
                          BorderRadius.circular(foxtrotRadiusSmall),
                    ),
                    child: Text(
                      _distanceLabel,
                      style: const TextStyle(
                        fontSize: 12,
                        color: foxtrotGoldLight,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            _InfoRow(icon: LucideIcons.mapPin, text: store.address),
            const SizedBox(height: 4),
            _InfoRow(
              icon: LucideIcons.clock,
              text: '평일 ${store.weekdayHours} · 주말 ${store.weekendHours}',
            ),
            const SizedBox(height: 4),
            _InfoRow(icon: LucideIcons.phone, text: store.phone),
            if (store.services.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: store.services
                    .map((service) => _ServiceChip(label: service))
                    .toList(),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _call(context),
                    icon: const Icon(LucideIcons.phone, size: 16),
                    label: const Text('전화'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _openMap(context),
                    icon: const Icon(LucideIcons.map, size: 16),
                    label: const Text('지도 보기'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: foxtrotGold),
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

class _ServiceChip extends StatelessWidget {
  const _ServiceChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: foxtrotGold.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(foxtrotRadiusSmall),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 11, color: foxtrotGoldLight),
      ),
    );
  }
}
