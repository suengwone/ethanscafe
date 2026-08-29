import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/text_utils.dart';
import '../../../features/beans/presentation/bean_labels.dart';
import '../../../features/gift/presentation/gift_labels.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/gift_models.dart';
import 'gift_providers.dart';

final _priceFormat = NumberFormat('#,###');
final _dateFormat = DateFormat('yyyy.MM.dd HH:mm');

class GiftHistoryScreen extends ConsumerWidget {
  const GiftHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final giftsState = ref.watch(beanGiftsControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('선물 내역')),
      body: giftsState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('선물 내역을 불러오지 못했습니다.'),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.invalidate(beanGiftsControllerProvider),
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
        data: (gifts) {
          if (gifts.isEmpty) {
            return const _EmptyGifts();
          }
          return ListView.builder(
            padding: foxtrotListPadding,
            itemCount: gifts.length,
            itemBuilder: (context, index) => _GiftCard(gift: gifts[index]),
          );
        },
      ),
    );
  }
}

class _EmptyGifts extends StatelessWidget {
  const _EmptyGifts();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.gift, size: 48, color: context.palette.muted),
          const SizedBox(height: 16),
          Text(
            '보낸 선물이 없어요',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '원두 상세에서 소중한 분께 원두를 선물해 보세요.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _GiftCard extends StatelessWidget {
  const _GiftCard({required this.gift});

  final BeanGift gift;

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: context.palette.surface,
                    borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
                    border: Border.all(color: context.palette.border),
                  ),
                  child: Icon(
                    LucideIcons.gift,
                    color: context.palette.accent,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)
                            .beanQuantity(gift.beanName, gift.quantity)
                            .keepWord,
                        style: textTheme.labelLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _dateFormat.format(gift.createdAt),
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                _GiftStatusChip(status: gift.status),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    'To. ${gift.recipientName} · ${gift.recipientPhone} · '
                            '${AppLocalizations.of(context).beanOption(gift.weight, gift.grind)}'
                        .keepWord,
                    style: textTheme.bodySmall,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '${_priceFormat.format(gift.totalPrice)}원',
                  style: textTheme.labelLarge,
                ),
              ],
            ),
            if (gift.message.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.palette.surface,
                  borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
                  border: Border.all(color: context.palette.border),
                ),
                child: Text(
                  '“${gift.message}”'.keepWord,
                  style: textTheme.bodySmall?.copyWith(color: context.palette.ink),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _GiftStatusChip extends StatelessWidget {
  const _GiftStatusChip({required this.status});

  final BeanGiftStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
        border: Border.all(color: context.palette.border),
      ),
      child: Text(
        AppLocalizations.of(context).giftStatusLabel(status),
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(color: context.palette.accentSoft, fontWeight: FontWeight.w600),
      ),
    );
  }
}
