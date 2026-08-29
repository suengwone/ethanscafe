import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

import '../domain/product_photos_repository.dart';

class FirebaseProductPhotosRepository implements ProductPhotosRepository {
  FirebaseProductPhotosRepository({FirebaseStorage? storage})
    : _storage = storage ?? FirebaseStorage.instance;

  final FirebaseStorage _storage;

  @override
  Future<String> upload({
    required String productType,
    required String productId,
    required Uint8List bytes,
    required String contentType,
  }) async {
    // 파일 이름에 시각을 붙인다. 같은 이름으로 덮어쓰면 앱과 CDN이 옛 사진을
    // 한동안 계속 보여 준다.
    final stamp = DateTime.now().millisecondsSinceEpoch;
    final ref = _storage.ref('products/$productType/$productId-$stamp.jpg');
    await ref.putData(bytes, SettableMetadata(contentType: contentType));
    return ref.getDownloadURL();
  }

  @override
  Future<void> delete(String downloadUrl) async {
    try {
      await _storage.refFromURL(downloadUrl).delete();
    } catch (_) {
      // 이미 지워졌거나 우리 버킷이 아닌 주소다. 사진 한 장 때문에 상품 수정이
      // 막히면 안 된다.
    }
  }
}
