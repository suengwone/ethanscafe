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

  @override
  Future<bool> issueCoupon(Coupon coupon) {
    final doc = _firestore.collection(collectionPath).doc(coupon.id);
    return _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(doc);
      if (snapshot.exists) {
        return false;
      }
      transaction.set(doc, couponToFirestore(coupon));
      return true;
    });
  }

  @override
  Future<void> markUsed(String couponId) {
    return _firestore
        .collection(collectionPath)
        .doc(couponId)
        .update({'isUsed': true});
  }

  @override
  Future<void> markUnused(String couponId) {
    return _firestore
        .collection(collectionPath)
        .doc(couponId)
        .update({'isUsed': false});
  }
}

Map<String, dynamic> couponToFirestore(Coupon coupon) {
  return {
    'title': coupon.title,
    'description': coupon.description,
    'expiresAt': Timestamp.fromDate(coupon.expiresAt),
    'isUsed': coupon.isUsed,
    'discountAmount': coupon.discountAmount,
    'discountRate': coupon.discountRate,
    'minOrderAmount': coupon.minOrderAmount,
    'isStackable': coupon.isStackable,
  };
}

Coupon couponFromFirestore(String id, Map<String, dynamic> data) {
  return Coupon(
    id: id,
    title: data['title'] as String? ?? '',
    description: data['description'] as String? ?? '',
    expiresAt: firestoreDateTime(data['expiresAt']),
    isUsed: data['isUsed'] as bool? ?? false,
    discountAmount: (data['discountAmount'] as num? ?? 0).toInt(),
    discountRate: (data['discountRate'] as num? ?? 0).toInt(),
    minOrderAmount: (data['minOrderAmount'] as num? ?? 0).toInt(),
    isStackable: data['isStackable'] as bool? ?? false,
  );
}
