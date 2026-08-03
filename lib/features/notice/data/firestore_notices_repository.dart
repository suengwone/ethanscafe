import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/firebase/firestore_converters.dart';
import '../domain/notice_models.dart';
import '../domain/notices_repository.dart';

class FirestoreNoticesRepository implements NoticesRepository {
  FirestoreNoticesRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static const collectionPath = 'notices';

  @override
  Future<List<Notice>> loadNotices() async {
    final snapshot = await _firestore
        .collection(collectionPath)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => noticeFromFirestore(doc.id, doc.data()))
        .toList();
  }
}

Notice noticeFromFirestore(String id, Map<String, dynamic> data) {
  return Notice(
    id: id,
    title: data['title'] as String? ?? '',
    body: data['body'] as String? ?? '',
    category: NoticeCategory.values.asNameMap()[data['category']] ??
        NoticeCategory.notice,
    createdAt: firestoreDateTime(data['createdAt']),
    isImportant: data['isImportant'] as bool? ?? false,
  );
}
