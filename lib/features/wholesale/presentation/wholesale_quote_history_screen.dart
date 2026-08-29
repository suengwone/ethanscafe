import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/l10n/summary_labels.dart';
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
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).wholesaleHistoryTitle),
      ),
      body: quotesState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(AppLocalizations.of(context).wholesaleHistoryLoadFailed),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () =>
                    ref.invalidate(wholesaleQuotesControllerProvider),
                child: Text(AppLocalizations.of(context).retry),
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
            AppLocalizations.of(context).wholesaleHistoryEmptyTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context).wholesaleHistoryEmptyDetail,
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
                      Text(
                        AppLocalizations.of(context)
                            .itemsSummary(
                              quote.firstItemName,
                              quote.items.length,
                            )
                            .keepWord,
                        style: textTheme.labelLarge,
                      ),
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
                              style: textTheme.bodySmall?.copyWith(
                                color: context.palette.ink,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            AppLocalizations.of(
                              context,
                            ).priceWon(_priceFormat.format(item.totalPrice)),
                            style: textTheme.bodySmall?.copyWith(
                              color: context.palette.ink,
                            ),
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
                    AppLocalizations.of(context)
                        .wholesaleCompanyAndKg(quote.companyName, quote.totalKg)
                        .keepWord,
                    style: textTheme.bodySmall,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  AppLocalizations.of(
                    context,
                  ).wholesaleEstimate(_priceFormat.format(quote.totalAmount)),
                  style: textTheme.labelLarge?.copyWith(
                    color: context.palette.accent,
                  ),
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
                  style: textTheme.bodySmall?.copyWith(
                    color: context.palette.ink,
                  ),
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
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: context.palette.accentSoft,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
