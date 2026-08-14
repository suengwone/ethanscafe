import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/firebase/firestore_converters.dart';
import '../domain/wholesale_models.dart';
import '../domain/wholesale_quotes_repository.dart';

class FirestoreWholesaleQuotesRepository implements WholesaleQuotesRepository {
  FirestoreWholesaleQuotesRepository({
    required this.uid,
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final String uid;
  final FirebaseFirestore _firestore;

  static const collectionPath = 'wholesale_quotes';

  DocumentReference<Map<String, dynamic>> get _doc =>
      _firestore.collection(collectionPath).doc(uid);

  @override
  Future<List<WholesaleQuote>> load() async {
    final snapshot = await _doc.get();
    final data = snapshot.data();
    if (data == null) {
      return const [];
    }
    return wholesaleQuotesFromFirestore(data);
  }

  @override
  Future<WholesaleQuote> submitQuote({
    required String companyName,
    required List<WholesaleQuoteItem> items,
    String memo = '',
  }) async {
    validateQuoteRequest(companyName: companyName, items: items);

    final quote = WholesaleQuote(
      id: _generateId(),
      companyName: companyName.trim(),
      items: items,
      memo: memo.trim(),
      createdAt: DateTime.now(),
    );

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(_doc);
      final data = snapshot.data();
      final quotes = data != null
          ? wholesaleQuotesFromFirestore(data)
          : const <WholesaleQuote>[];
      transaction.set(_doc, wholesaleQuotesToFirestore([quote, ...quotes]));
    });
    return quote;
  }

  String _generateId() =>
      '${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(0xFFFF)}';
}

List<WholesaleQuote> wholesaleQuotesFromFirestore(Map<String, dynamic> data) {
  return ((data['quotes'] as List<dynamic>?) ?? const [])
      .map((quote) => wholesaleQuoteFromFirestore(quote as Map<String, dynamic>))
      .toList();
}

WholesaleQuote wholesaleQuoteFromFirestore(Map<String, dynamic> data) {
  return WholesaleQuote(
    id: data['id'] as String? ?? '',
    companyName: data['companyName'] as String? ?? '',
    items: ((data['items'] as List<dynamic>?) ?? const [])
        .map((item) => wholesaleQuoteItemFromFirestore(
            item as Map<String, dynamic>))
        .toList(),
    memo: data['memo'] as String? ?? '',
    status: WholesaleQuoteStatus.values.asNameMap()[data['status']] ??
        WholesaleQuoteStatus.requested,
    createdAt: firestoreDateTime(data['createdAt']),
  );
}

WholesaleQuoteItem wholesaleQuoteItemFromFirestore(Map<String, dynamic> data) {
  return WholesaleQuoteItem(
    beanId: data['beanId'] as String? ?? '',
    beanName: data['beanName'] as String? ?? '',
    kg: (data['kg'] as num? ?? 0).toInt(),
    pricePerKg: (data['pricePerKg'] as num? ?? 0).toInt(),
  );
}

Map<String, dynamic> wholesaleQuotesToFirestore(List<WholesaleQuote> quotes) {
  return {'quotes': quotes.map(wholesaleQuoteToFirestore).toList()};
}

Map<String, dynamic> wholesaleQuoteToFirestore(WholesaleQuote quote) {
  return {
    'id': quote.id,
    'companyName': quote.companyName,
    'items': [
      for (final item in quote.items)
        {
          'beanId': item.beanId,
          'beanName': item.beanName,
          'kg': item.kg,
          'pricePerKg': item.pricePerKg,
        },
    ],
    'memo': quote.memo,
    'status': quote.status.name,
    'createdAt': Timestamp.fromDate(quote.createdAt),
  };
}
