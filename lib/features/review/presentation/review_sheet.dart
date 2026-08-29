import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/text_utils.dart';
import '../../../features/review/presentation/review_labels.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/review_models.dart';
import 'review_providers.dart';

Future<void> showReviewSheet(
  BuildContext context, {
  required String productId,
  required ReviewProductType productType,
  required String productName,
  required String orderId,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (context) => ReviewSheet(
      productId: productId,
      productType: productType,
      productName: productName,
      orderId: orderId,
    ),
  );
}

class ReviewSheet extends ConsumerStatefulWidget {
  const ReviewSheet({
    super.key,
    required this.productId,
    required this.productType,
    required this.productName,
    required this.orderId,
  });

  final String productId;
  final ReviewProductType productType;
  final String productName;
  final String orderId;

  @override
  ConsumerState<ReviewSheet> createState() => _ReviewSheetState();
}

class _ReviewSheetState extends ConsumerState<ReviewSheet> {
  final _commentController = TextEditingController();
  int _rating = 5;
  bool _submitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    try {
      await ref
          .read(myReviewsControllerProvider.notifier)
          .addReview(
            productId: widget.productId,
            productType: widget.productType,
            productName: widget.productName,
            orderId: widget.orderId,
            rating: _rating,
            comment: _commentController.text.trim(),
          );
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).reviewSubmitted)),
        );
      }
    } catch (_) {
      if (mounted) {
        setState(() => _submitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).reviewSubmitFailed),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.reviewSheetTitle(
              l10n.reviewProductTypeLabel(widget.productType),
            ),
            style: textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(widget.productName.keepWord, style: textTheme.bodySmall),
          const SizedBox(height: 16),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var star = 1; star <= maxReviewRating; star++)
                  IconButton(
                    // 화면을 읽어 주는 사람에게 별 다섯 개는 전부 같은 버튼이다.
                    tooltip: l10n.reviewRatingStars(star),
                    onPressed: () => setState(() => _rating = star),
                    icon: Icon(
                      Icons.star_rounded,
                      size: 36,
                      color: star <= _rating
                          ? context.palette.accent
                          : context.palette.border,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _commentController,
            maxLines: 3,
            maxLength: 200,
            decoration: InputDecoration(hintText: l10n.reviewSheetHint),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _submitting ? null : _submit,
              icon: const Icon(LucideIcons.messageSquareHeart, size: 18),
              label: Text(
                _submitting ? l10n.reviewSubmitting : l10n.reviewSubmit,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ReviewRatingStars extends StatelessWidget {
  const ReviewRatingStars({super.key, required this.rating, this.size = 16});

  final int rating;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var star = 1; star <= maxReviewRating; star++)
          Icon(
            Icons.star_rounded,
            size: size,
            color: star <= rating
                ? context.palette.accent
                : context.palette.border,
          ),
      ],
    );
  }
}
