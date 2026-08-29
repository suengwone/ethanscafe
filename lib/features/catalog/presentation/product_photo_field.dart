import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/product_photos_repository.dart';
import 'product_photo_providers.dart';

/// 상품 등록·수정 화면의 사진 칸.
///
/// 고른 사진을 그 자리에서 올리고 주소만 위로 넘긴다. 저장을 누르기 전에 올려
/// 두는 편이, 저장 도중 사진 업로드까지 겹쳐 실패하는 것보다 낫다. 사진 없이
/// 저장하면 지금처럼 분류별 기본 사진이 보인다.
class ProductPhotoField extends ConsumerStatefulWidget {
  const ProductPhotoField({
    super.key,
    required this.productType,
    required this.productId,
    required this.imageUrl,
    required this.onChanged,
  });

  /// `menu` 또는 `bean`. 보안 규칙이 이 두 경로만 허용한다.
  final String productType;
  final String productId;
  final String? imageUrl;
  final ValueChanged<String?> onChanged;

  @override
  ConsumerState<ProductPhotoField> createState() => _ProductPhotoFieldState();
}

class _ProductPhotoFieldState extends ConsumerState<ProductPhotoField> {
  bool _uploading = false;

  Future<void> _pick() async {
    final repository = ref.read(productPhotosRepositoryProvider);
    if (repository == null) {
      return;
    }
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);

    // 휴대폰 사진은 그대로 올리면 몇 MB다. 목록 썸네일에 필요한 크기까지만 줄인다.
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 85,
    );
    if (picked == null) {
      return;
    }

    final bytes = await picked.readAsBytes();
    final contentType = picked.mimeType ?? 'image/jpeg';
    final rejection = productPhotoRejection(
      byteCount: bytes.length,
      contentType: contentType,
    );
    if (rejection != null) {
      messenger.showSnackBar(
        SnackBar(content: Text(_rejectionMessage(l10n, rejection))),
      );
      return;
    }

    setState(() => _uploading = true);
    try {
      final url = await repository.upload(
        productType: widget.productType,
        productId: widget.productId,
        bytes: bytes,
        contentType: contentType,
      );
      widget.onChanged(url);
    } catch (error) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.photoUploadFailed('$error'))),
      );
    } finally {
      if (mounted) {
        setState(() => _uploading = false);
      }
    }
  }

  static String _rejectionMessage(AppLocalizations l10n, String rejection) =>
      switch (rejection) {
        'tooLarge' => l10n.photoTooLarge,
        'unsupportedType' => l10n.photoUnsupportedType,
        _ => l10n.photoEmpty,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Firebase가 없는 자리(테스트, 초기화 실패)에서는 칸 자체를 감춘다.
    if (ref.watch(productPhotosRepositoryProvider) == null) {
      return const SizedBox.shrink();
    }
    final url = widget.imageUrl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.photoSectionTitle,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: context.palette.surface,
                borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
                border: Border.all(color: context.palette.border),
              ),
              clipBehavior: Clip.antiAlias,
              child: url == null || url.isEmpty
                  ? Icon(LucideIcons.image, color: context.palette.muted)
                  : Image.network(url, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OutlinedButton.icon(
                    onPressed: _uploading ? null : _pick,
                    icon: _uploading
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(LucideIcons.upload, size: 16),
                    label: Text(
                      _uploading
                          ? l10n.photoUploading
                          : (url == null || url.isEmpty
                                ? l10n.photoAdd
                                : l10n.photoReplace),
                    ),
                  ),
                  if (url != null && url.isNotEmpty)
                    TextButton(
                      onPressed: _uploading
                          ? null
                          : () => widget.onChanged(null),
                      child: Text(l10n.photoRemove),
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          l10n.photoFallbackNotice,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
