import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FcmTokenRepository {
  Future<void> saveToken(String token);

  Future<void> removeToken(String token);
}

class FirestoreFcmTokenRepository implements FcmTokenRepository {
  FirestoreFcmTokenRepository({required this.uid, FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final String uid;
  final FirebaseFirestore _firestore;

  static const collectionPath = 'fcmTokens';

  DocumentReference<Map<String, dynamic>> get _doc =>
      _firestore.collection(collectionPath).doc(uid);

  @override
  Future<void> saveToken(String token) {
    return _doc.set({
      'tokens': FieldValue.arrayUnion([token]),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  Future<void> removeToken(String token) {
    return _doc.set({
      'tokens': FieldValue.arrayRemove([token]),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
