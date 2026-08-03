import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/firebase/firestore_converters.dart';
import '../domain/coupon_models.dart';
import '../domain/coupons_repository.dart';

class FirestoreCouponsRepository implements CouponsRepository {
  FirestoreCouponsRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static const collectionPath = 'coupons';

  @override
  Future<List<Coupon>> loadCoupons() async {
    final snapshot = await _firestore
        .collection(collectionPath)
        .orderBy('expiresAt')
        .get();
    return snapshot.docs
        .map((doc) => couponFromFirestore(doc.id, doc.data()))
        .toList();
  }
}

Coupon couponFromFirestore(String id, Map<String, dynamic> data) {
  return Coupon(
    id: id,
    title: data['title'] as String? ?? '',
    description: data['description'] as String? ?? '',
    expiresAt: firestoreDateTime(data['expiresAt']),
    isUsed: data['isUsed'] as bool? ?? false,
  );
}
