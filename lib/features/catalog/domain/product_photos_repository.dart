import 'dart:typed_data';

/// 상품 사진 저장소.
///
/// 매장이 고른 사진을 올리고 주소를 돌려준다. 그 주소는 상품 문서에 들어가고,
/// 손님 화면은 로그인 없이 그 주소로 사진을 읽는다.
abstract class ProductPhotosRepository {
  /// [productType]은 `menu` 또는 `bean`. 보안 규칙이 이 경로만 허용한다.
  Future<String> upload({
    required String productType,
    required String productId,
    required Uint8List bytes,
    required String contentType,
  });

  Future<void> delete(String downloadUrl);
}

/// 규칙이 받아 주는 형식. 앱에서 한 번 걸러야 매장이 올린 뒤에야 거절당하는 일이
/// 없다.
const productPhotoContentTypes = {'image/jpeg', 'image/png', 'image/webp'};

/// 규칙과 같은 한도. 규칙이 `size < 5MB`라 딱 5MB짜리도 거절당하므로 앱도 같은
/// 선에서 막는다. 어긋나면 다 올린 뒤에야 거절당한다.
const productPhotoMaxBytes = 5 * 1024 * 1024;

/// 올릴 수 있는 사진인지 본다. 규칙이 최종 관문이고 이건 먼저 알려 주는 쪽이다.
String? productPhotoRejection({
  required int byteCount,
  required String contentType,
}) {
  if (!productPhotoContentTypes.contains(contentType)) {
    return 'unsupportedType';
  }
  if (byteCount >= productPhotoMaxBytes) {
    return 'tooLarge';
  }
  if (byteCount == 0) {
    return 'empty';
  }
  return null;
}
