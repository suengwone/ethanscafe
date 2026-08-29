import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/firebase_product_photos_repository.dart';
import '../domain/product_photos_repository.dart';

/// Firebase가 없으면 사진 올리기도 없다. 화면은 이 값이 null이면 버튼을 감춘다.
final productPhotosRepositoryProvider = Provider<ProductPhotosRepository?>((
  ref,
) {
  try {
    if (Firebase.apps.isNotEmpty) {
      return FirebaseProductPhotosRepository();
    }
  } catch (_) {}
  return null;
});
