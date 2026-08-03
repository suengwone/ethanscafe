import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/new_badge.dart';
import '../domain/bean_models.dart';
import 'beans_providers.dart';

final _priceFormat = NumberFormat('#,###');

class BeansListView extends ConsumerWidget {
  const BeansListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final beansState = ref.watch(beansProvider);

    return beansState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('원두 정보를 불러오지 못했습니다.'),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => ref.invalidate(beansProvider),
              child: const Text('다시 시도'),
            ),
          ],
        ),
      ),
      data: (beans) => ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: beans.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return const _BeansHeader();
          }
          return _BeanCard(bean: beans[index - 1]);
        },
      ),
    );
  }
}

class _BeansHeader extends StatelessWidget {
  const _BeansHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 12),
      child: Text(
        '매주 화요일 로스팅한 원두를 홀빈 또는 원하는 분쇄도로 보내드립니다.',
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}

class _BeanCard extends StatelessWidget {
  const _BeanCard({required this.bean});

  final Bean bean;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(foxtrotRadiusLarge),
        onTap: () => context.push('/menu/beans/${bean.id}'),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: foxtrotSurface,
                  borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
                  border: Border.all(color: foxtrotBorder),
                ),
                child: const Icon(
                  LucideIcons.bean,
                  color: foxtrotGold,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            bean.name,
                            style: textTheme.labelLarge,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (bean.isNew) ...[
                          const SizedBox(width: 6),
                          const NewBadge(),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${bean.origin} · ${bean.roastLevel.label} 로스팅',
                      style: textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: bean.tastingNotes
                          .take(3)
                          .map((note) => _TastingNoteChip(note: note))
                          .toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${_priceFormat.format(bean.price200)}원',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text('200g', style: textTheme.bodySmall),
                  const SizedBox(height: 8),
                  const Icon(
                    LucideIcons.chevronRight,
                    size: 16,
                    color: foxtrotMuted,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TastingNoteChip extends StatelessWidget {
  const _TastingNoteChip({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: foxtrotGold.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(foxtrotRadiusSmall),
      ),
      child: Text(
        note,
        style: const TextStyle(fontSize: 11, color: foxtrotGoldLight),
      ),
    );
  }
}
