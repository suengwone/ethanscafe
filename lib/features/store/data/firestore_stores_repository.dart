import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/firebase/firestore_converters.dart';
import '../domain/store_models.dart';
import '../domain/stores_repository.dart';

class FirestoreStoresRepository implements StoresRepository {
  FirestoreStoresRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static const collectionPath = 'stores';
  static const activityCollectionPath = 'store_activity';

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

  @override
  Future<Map<String, StoreActivity>> loadActivity() async {
    final snapshot = await _firestore.collection(activityCollectionPath).get();
    return {
      for (final doc in snapshot.docs)
        doc.id: storeActivityFromFirestore(doc.id, doc.data()),
    };
  }
}

StoreActivity storeActivityFromFirestore(String id, Map<String, dynamic> data) {
  return StoreActivity(
    storeId: id,
    activeOrders: (data['activeOrders'] as num? ?? 0).toInt(),
    congestion:
        StoreCongestion.values.asNameMap()[data['congestion']] ??
        StoreCongestion.unknown,
    updatedAt: data['updatedAt'] == null
        ? DateTime.fromMillisecondsSinceEpoch(0)
        : firestoreDateTime(data['updatedAt']),
  );
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
    sortOrder: (data['sortOrder'] as num? ?? 0).toInt(),
    notice: data['notice'] as String? ?? '',
    congestion:
        StoreCongestion.values.asNameMap()[data['congestion']] ??
        StoreCongestion.unknown,
    congestionUpdatedAt: data['congestionUpdatedAt'] == null
        ? null
        : firestoreDateTime(data['congestionUpdatedAt']),
  );
}

Map<String, dynamic> storeToFirestore(CafeStore store) {
  return {
    'name': store.name,
    'address': store.address,
    'phone': store.phone,
    'latitude': store.latitude,
    'longitude': store.longitude,
    'weekdayHours': store.weekdayHours,
    'weekendHours': store.weekendHours,
    'services': store.services,
    'sortOrder': store.sortOrder,
    'notice': store.notice,
    'congestion': store.congestion.name,
    'congestionUpdatedAt': store.congestionUpdatedAt == null
        ? null
        : Timestamp.fromDate(store.congestionUpdatedAt!),
  };
}
