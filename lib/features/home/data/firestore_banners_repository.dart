import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/banner_models.dart';
import '../domain/banners_repository.dart';

class FirestoreBannersRepository implements BannersRepository {
  FirestoreBannersRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static const collectionPath = 'banners';

  @override
  Future<List<EventBanner>> loadBanners() async {
    final snapshot = await _firestore
        .collection(collectionPath)
        .orderBy('sortOrder')
        .get();
    return snapshot.docs
        .map((doc) => bannerFromFirestore(doc.id, doc.data()))
        .toList();
  }
}

EventBanner bannerFromFirestore(String id, Map<String, dynamic> data) {
  return EventBanner(
    id: id,
    title: data['title'] as String? ?? '',
    subtitle: data['subtitle'] as String? ?? '',
    icon: data['icon'] as String? ?? 'sparkles',
  );
}
