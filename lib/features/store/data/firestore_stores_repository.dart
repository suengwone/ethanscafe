import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/store_models.dart';
import '../domain/stores_repository.dart';

class FirestoreStoresRepository implements StoresRepository {
  FirestoreStoresRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static const collectionPath = 'stores';

  @override
  Future<List<CafeStore>> loadStores() async {
    final snapshot = await _firestore
        .collection(collectionPath)
        .orderBy('sortOrder')
        .get();
    return snapshot.docs
        .map((doc) => storeFromFirestore(doc.id, doc.data()))
        .toList();
  }
}

CafeStore storeFromFirestore(String id, Map<String, dynamic> data) {
  return CafeStore(
    id: id,
    name: data['name'] as String? ?? '',
    address: data['address'] as String? ?? '',
    phone: data['phone'] as String? ?? '',
    latitude: (data['latitude'] as num? ?? 0).toDouble(),
    longitude: (data['longitude'] as num? ?? 0).toDouble(),
    weekdayHours: data['weekdayHours'] as String? ?? '',
    weekendHours: data['weekendHours'] as String? ?? '',
    services: (data['services'] as List<dynamic>? ?? const []).cast<String>(),
  );
}
