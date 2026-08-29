import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/text_utils.dart';
import '../../../features/wholesale/presentation/wholesale_labels.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/wholesale_models.dart';
import 'wholesale_providers.dart';

final _priceFormat = NumberFormat('#,###');
final _dateFormat = DateFormat('yyyy.MM.dd HH:mm');

class WholesaleQuoteHistoryScreen extends ConsumerWidget {
  const WholesaleQuoteHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quotesState = ref.watch(wholesaleQuotesControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('견적 요청 내역')),
      body: quotesState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('견적 내역을 불러오지 못했습니다.'),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () =>
                    ref.invalidate(wholesaleQuotesControllerProvider),
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
        data: (quotes) {
          if (quotes.isEmpty) {
            return const _EmptyQuotes();
          }
          return ListView.builder(
            padding: foxtrotListPadding,
            itemCount: quotes.length,
            itemBuilder: (context, index) => _QuoteCard(quote: quotes[index]),
          );
        },
      ),
    );
  }
}

class _EmptyQuotes extends StatelessWidget {
  const _EmptyQuotes();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.fileText, size: 48, color: context.palette.muted),
          const SizedBox(height: 16),
          Text(
            '아직 견적 요청이 없어요',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '도매 원두 리스트에서 원하는 원두로 견적을 요청해 보세요.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _QuoteCard extends StatelessWidget {
  const _QuoteCard({required this.quote});

  final WholesaleQuote quote;

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
                    LucideIcons.fileText,
                    color: context.palette.accent,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(quote.summary.keepWord, style: textTheme.labelLarge),
                      const SizedBox(height: 4),
                      Text(
                        _dateFormat.format(quote.createdAt),
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                _QuoteStatusChip(status: quote.status),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.palette.surface,
                borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
                border: Border.all(color: context.palette.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final item in quote.items)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${item.beanName} · ${item.kg}kg'.keepWord,
                              style: textTheme.bodySmall
                                  ?.copyWith(color: context.palette.ink),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '${_priceFormat.format(item.totalPrice)}원',
                            style: textTheme.bodySmall
                                ?.copyWith(color: context.palette.ink),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    '${quote.companyName} · 총 ${quote.totalKg}kg'.keepWord,
                    style: textTheme.bodySmall,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '예상 ${_priceFormat.format(quote.totalAmount)}원',
                  style: textTheme.labelLarge?.copyWith(color: context.palette.accent),
                ),
              ],
            ),
            if (quote.memo.isNotEmpty) ...[
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
                  '“${quote.memo}”'.keepWord,
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

class _QuoteStatusChip extends StatelessWidget {
  const _QuoteStatusChip({required this.status});

  final WholesaleQuoteStatus status;

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
        AppLocalizations.of(context).wholesaleStatusLabel(status),
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(color: context.palette.accentSoft, fontWeight: FontWeight.w600),
      ),
    );
  }
}
