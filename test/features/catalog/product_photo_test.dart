import 'package:flutter_test/flutter_test.dart';

import 'package:cafe_app/features/catalog/domain/product_photos_repository.dart';

void main() {
  group('올릴 수 있는 사진인지 본다', () {
    test('보통 사진은 통과한다', () {
      expect(
        productPhotoRejection(byteCount: 800 * 1024, contentType: 'image/jpeg'),
        isNull,
      );
      expect(
        productPhotoRejection(byteCount: 200, contentType: 'image/png'),
        isNull,
      );
    });

    test('사진이 아닌 것은 막는다', () {
      // 규칙도 막지만, 다 올린 뒤에 거절당하면 매장이 이유를 알기 어렵다.
      expect(
        productPhotoRejection(byteCount: 100, contentType: 'application/pdf'),
        'unsupportedType',
      );
      expect(
        productPhotoRejection(byteCount: 100, contentType: 'text/html'),
        'unsupportedType',
      );
    });

    test('한도를 넘는 파일은 막는다', () {
      expect(
        productPhotoRejection(
          byteCount: productPhotoMaxBytes + 1,
          contentType: 'image/jpeg',
        ),
        'tooLarge',
      );
      // 규칙은 `size < 5MB`라 딱 맞는 크기도 거절한다. 앱이 여기서 통과시키면
      // 매장은 다 올린 뒤에야 거절당한다.
      expect(
        productPhotoRejection(
          byteCount: productPhotoMaxBytes,
          contentType: 'image/jpeg',
        ),
        'tooLarge',
      );
      expect(
        productPhotoRejection(
          byteCount: productPhotoMaxBytes - 1,
          contentType: 'image/jpeg',
        ),
        isNull,
      );
    });

    test('빈 파일은 막는다', () {
      expect(
        productPhotoRejection(byteCount: 0, contentType: 'image/jpeg'),
        'empty',
      );
    });
  });
}
