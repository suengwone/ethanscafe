import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/firebase/firestore_converters.dart';
import '../../beans/domain/bean_models.dart';
import '../domain/bean_gifts_repository.dart';
import '../domain/gift_models.dart';

class FirestoreBeanGiftsRepository implements BeanGiftsRepository {
  FirestoreBeanGiftsRepository({
    required this.uid,
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final String uid;
  final FirebaseFirestore _firestore;

  static const collectionPath = 'gifts';

  DocumentReference<Map<String, dynamic>> get _doc =>
      _firestore.collection(collectionPath).doc(uid);

  @override
  Future<List<BeanGift>> load() async {
    final snapshot = await _doc.get();
    final data = snapshot.data();
    if (data == null) {
      return const [];
    }
    return beanGiftsFromFirestore(data);
  }

  @override
  Future<BeanGift> sendGift({
    required String beanId,
    required String beanName,
    required BeanWeight weight,
    required GrindOption grind,
    required int quantity,
    required int unitPrice,
    required String recipientName,
    required String recipientPhone,
    String message = '',
  }) async {
    if (recipientName.trim().isEmpty) {
      throw ArgumentError.value(
        recipientName,
        'recipientName',
        '받는 분 이름이 비어 있습니다.',
      );
    }
    if (recipientPhone.trim().isEmpty) {
      throw ArgumentError.value(
        recipientPhone,
        'recipientPhone',
        '받는 분 연락처가 비어 있습니다.',
      );
    }

    final gift = BeanGift(
      id: _generateId(),
      beanId: beanId,
      beanName: beanName,
      weight: weight,
      grind: grind,
      quantity: quantity,
      unitPrice: unitPrice,
      recipientName: recipientName.trim(),
      recipientPhone: recipientPhone.trim(),
      message: message.trim(),
      createdAt: DateTime.now(),
    );

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(_doc);
      final data = snapshot.data();
      final gifts =
          data != null ? beanGiftsFromFirestore(data) : const <BeanGift>[];
      transaction.set(_doc, beanGiftsToFirestore([gift, ...gifts]));
    });
    return gift;
  }

  String _generateId() =>
      '${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(0xFFFF)}';
}

List<BeanGift> beanGiftsFromFirestore(Map<String, dynamic> data) {
  return ((data['gifts'] as List<dynamic>?) ?? const [])
      .map((gift) => beanGiftFromFirestore(gift as Map<String, dynamic>))
      .toList();
}

BeanGift beanGiftFromFirestore(Map<String, dynamic> data) {
  return BeanGift(
    id: data['id'] as String? ?? '',
    beanId: data['beanId'] as String? ?? '',
    beanName: data['beanName'] as String? ?? '',
    weight: BeanWeight.values.asNameMap()[data['weight']] ?? BeanWeight.g200,
    grind:
        GrindOption.values.asNameMap()[data['grind']] ?? GrindOption.wholeBean,
    quantity: (data['quantity'] as num? ?? 1).toInt(),
    unitPrice: (data['unitPrice'] as num? ?? 0).toInt(),
    recipientName: data['recipientName'] as String? ?? '',
    recipientPhone: data['recipientPhone'] as String? ?? '',
    message: data['message'] as String? ?? '',
    status: BeanGiftStatus.values.asNameMap()[data['status']] ??
        BeanGiftStatus.sent,
    createdAt: firestoreDateTime(data['createdAt']),
  );
}

Map<String, dynamic> beanGiftsToFirestore(List<BeanGift> gifts) {
  return {'gifts': gifts.map(beanGiftToFirestore).toList()};
}

Map<String, dynamic> beanGiftToFirestore(BeanGift gift) {
  return {
    'id': gift.id,
    'beanId': gift.beanId,
    'beanName': gift.beanName,
    'weight': gift.weight.name,
    'grind': gift.grind.name,
    'quantity': gift.quantity,
    'unitPrice': gift.unitPrice,
    'recipientName': gift.recipientName,
    'recipientPhone': gift.recipientPhone,
    'message': gift.message,
    'status': gift.status.name,
    'createdAt': Timestamp.fromDate(gift.createdAt),
  };
}
