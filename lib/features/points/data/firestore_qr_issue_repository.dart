import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/points_models.dart';
import '../domain/qr_issue_repository.dart';
import 'firestore_qr_points_repository.dart';

class FirestoreQrIssueRepository implements QrIssueRepository {
  FirestoreQrIssueRepository({
    required this.uid,
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  static const tokenLifetime = Duration(minutes: 5);

  final String uid;
  final FirebaseFirestore _firestore;

  @override
  Future<IssuedQrToken> issue({
    required int paymentAmount,
    required String storeName,
  }) async {
    if (paymentAmount <= 0) {
      throw ArgumentError.value(
          paymentAmount, 'paymentAmount', '결제 금액은 0보다 커야 합니다.');
    }
    final trimmedStoreName = storeName.trim();
    if (trimmedStoreName.isEmpty) {
      throw ArgumentError.value(storeName, 'storeName', '매장명을 입력해주세요.');
    }

    final code = generateQrTokenCode();
    final expiresAt = DateTime.now().add(tokenLifetime);
    await _firestore
        .collection(FirestoreQrPointsRepository.tokenCollectionPath)
        .doc(code)
        .set({
      'storeName': trimmedStoreName,
      'paymentAmount': paymentAmount,
      'used': false,
      'issuedBy': uid,
      'createdAt': FieldValue.serverTimestamp(),
      'expiresAt': Timestamp.fromDate(expiresAt),
    });

    return IssuedQrToken(
      code: code,
      storeName: trimmedStoreName,
      paymentAmount: paymentAmount,
      expiresAt: expiresAt,
    );
  }
}

String generateQrTokenCode() {
  const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  final random = Random.secure();
  final body =
      List.generate(20, (_) => chars[random.nextInt(chars.length)]).join();
  return 'FOXTROT-TKN-$body';
}
