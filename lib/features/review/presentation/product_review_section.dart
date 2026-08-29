import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/text_utils.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/review_models.dart';
import 'review_providers.dart';
import 'review_sheet.dart';

final _dateFormat = DateFormat('yyyy.MM.dd');

class ProductReviewSection extends ConsumerWidget {
  const ProductReviewSection({
    super.key,
    required this.productId,
    this.maxVisible = 3,
  });

  final String productId;
  final int maxVisible;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final reviewsState = ref.watch(productReviewsProvider(productId));
    final stats = ref.watch(productStatsProvider).asData?.value[productId];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(l10n.reviewSectionTitle, style: textTheme.titleMedium),
                if (stats != null && stats.hasRating) ...[
                  const SizedBox(width: 8),
                  Icon(
                    Icons.star_rounded,
                    size: 18,
                    color: context.palette.accent,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    stats.averageRating.toStringAsFixed(1),
                    style: textTheme.labelLarge?.copyWith(
                      color: context.palette.accentSoft,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text('(${stats.ratingCount})', style: textTheme.bodySmall),
                ],
              ],
            ),
            const SizedBox(height: 12),
            reviewsState.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, _) =>
                  Text(l10n.reviewLoadFailed, style: textTheme.bodySmall),
              data: (reviews) {
                if (reviews.isEmpty) {
                  return const _EmptyReviews();
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final (index, review)
                        in reviews.take(maxVisible).indexed) ...[
                      if (index > 0)
                        Divider(
                          height: 20,
                          color: context.palette.border.withValues(alpha: 0.5),
                        ),
                      _ReviewRow(review: review),
                    ],
                    if (reviews.length > maxVisible) ...[
                      const SizedBox(height: 12),
                      Text(
                        l10n.reviewMoreCount(reviews.length - maxVisible),
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyReviews extends StatelessWidget {
  const _EmptyReviews();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Icon(
          LucideIcons.messageSquareHeart,
          size: 18,
          color: context.palette.muted,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(l10n.reviewEmpty.keepWord, style: textTheme.bodySmall),
        ),
      ],
    );
  }
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow({required this.review});

  final ProductReview review;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ReviewRatingStars(rating: review.rating),
            const Spacer(),
            Text(
              _dateFormat.format(review.createdAt),
              style: textTheme.bodySmall,
            ),
          ],
        ),
        if (review.comment.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            review.comment.keepWord,
            style: textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
        ],
      ],
    );
  }
}
