import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

/// 상품 사진.
///
/// 매장이 올린 사진이 있으면 그것을, 없으면 카테고리 사진을 보여 준다. 카테고리
/// 사진은 같은 분류의 상품이 전부 똑같이 보이므로 자리를 채우는 용도일 뿐이다.
/// 올린 사진이 뜨지 않을 때도(주소가 죽었거나 오프라인) 같은 자리로 되돌아간다.
class ProductPhoto extends StatelessWidget {
  const ProductPhoto({
    super.key,
    required this.name,
    required this.fallbackAsset,
    required this.fallbackIcon,
    this.imageUrl,
    this.iconSize,
  });

  final String name;
  final String fallbackAsset;
  final IconData fallbackIcon;
  final String? imageUrl;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    final label = AppLocalizations.of(context).menuPhotoOf(name);
    final url = imageUrl;
    if (url == null || url.isEmpty) {
      return _asset(label);
    }
    // 자리 크기를 알아야 그만큼만 디코딩한다. 목록 썸네일이 원본 그대로를 펼치면
    // 한 화면치 사진만으로도 메모리가 훅 올라간다.
    return LayoutBuilder(
      builder: (context, constraints) {
        final ratio = MediaQuery.devicePixelRatioOf(context);
        final width = constraints.maxWidth.isFinite
            ? (constraints.maxWidth * ratio).round()
            : null;
        return Image.network(
          url,
          semanticLabel: label,
          fit: BoxFit.cover,
          cacheWidth: width,
          // 사진이 오는 동안 빈칸 대신 분류 사진을 두고, 실패해도 같은 자리로
          // 돌아간다. 목록에서 칸이 깜빡이지 않는다.
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) =>
              frame == null && !wasSynchronouslyLoaded ? _asset(label) : child,
          errorBuilder: (context, error, stackTrace) => _asset(label),
        );
      },
    );
  }

  Widget _asset(String label) => Image.asset(
    fallbackAsset,
    semanticLabel: label,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) => Builder(
      builder: (context) => Icon(
        fallbackIcon,
        color: Theme.of(context).colorScheme.primary,
        size: iconSize,
      ),
    ),
  );
}
