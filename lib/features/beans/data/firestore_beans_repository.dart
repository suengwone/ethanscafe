import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/bean_models.dart';
import '../domain/beans_repository.dart';

class FirestoreBeansRepository implements BeansRepository {
  FirestoreBeansRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static const collectionPath = 'beans';

  @override
  Future<List<Bean>> loadBeans() async {
    final snapshot = await _firestore
        .collection(collectionPath)
        .orderBy('sortOrder')
        .get();
    return snapshot.docs
        .map((doc) => beanFromFirestore(doc.id, doc.data()))
        .toList();
  }
}

Bean beanFromFirestore(String id, Map<String, dynamic> data) {
  return Bean(
    id: id,
    name: data['name'] as String? ?? '',
    origin: data['origin'] as String? ?? '',
    description: data['description'] as String? ?? '',
    story: data['story'] as String? ?? '',
    roastLevel: RoastLevel.values.asNameMap()[data['roastLevel']] ??
        RoastLevel.medium,
    process: data['process'] as String? ?? '',
    tastingNotes: _stringList(data['tastingNotes']),
    acidity: (data['acidity'] as num? ?? 0).toInt(),
    body: (data['body'] as num? ?? 0).toInt(),
    sweetness: (data['sweetness'] as num? ?? 0).toInt(),
    recommendedBrews: _stringList(data['recommendedBrews']),
    price200: (data['price200'] as num? ?? 0).toInt(),
    price500: (data['price500'] as num? ?? 0).toInt(),
    isNew: data['isNew'] as bool? ?? false,
    soldOut: data['soldOut'] as bool? ?? false,
  );
}

List<String> _stringList(Object? value) =>
    (value as List<dynamic>? ?? const []).cast<String>();
