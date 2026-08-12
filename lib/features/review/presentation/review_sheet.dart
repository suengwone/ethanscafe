import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/text_utils.dart';
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
      await ref.read(myReviewsControllerProvider.notifier).addReview(
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
          const SnackBar(content: Text('소중한 후기가 등록되었습니다.')),
        );
      }
    } catch (_) {
      if (mounted) {
        setState(() => _submitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('후기 등록에 실패했습니다. 다시 시도해주세요.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
          Text('${widget.productType.label} 후기 남기기', style: textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(widget.productName.keepWord, style: textTheme.bodySmall),
          const SizedBox(height: 16),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var star = 1; star <= maxReviewRating; star++)
                  IconButton(
                    onPressed: () => setState(() => _rating = star),
                    icon: Icon(
                      Icons.star_rounded,
                      size: 36,
                      color: star <= _rating ? foxtrotGold : foxtrotBorder,
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
            decoration: const InputDecoration(
              hintText: '맛과 향은 어떠셨나요? 후기를 남겨주세요.',
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _submitting ? null : _submit,
              icon: const Icon(LucideIcons.messageSquareHeart, size: 18),
              label: Text(_submitting ? '등록 중...' : '후기 등록'),
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
            color: star <= rating ? foxtrotGold : foxtrotBorder,
          ),
      ],
    );
  }
}
