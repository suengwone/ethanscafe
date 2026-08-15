import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/firebase/firestore_converters.dart';
import '../domain/stamp_models.dart';
import '../domain/stamps_repository.dart';

class FirestoreStampsRepository implements StampsRepository {
  FirestoreStampsRepository({
    required this.uid,
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  static const collectionPath = 'stamps';

  final String uid;
  final FirebaseFirestore _firestore;

  @override
  Future<StampData> load() async {
    final snapshot =
        await _firestore.collection(collectionPath).doc(uid).get();
    final data = snapshot.data();
    if (data == null) {
      return const StampData();
    }
    return stampDataFromFirestore(data);
  }
}

StampData stampDataFromFirestore(Map<String, dynamic> data) {
  return StampData(
    count: (data['count'] as num? ?? 0).toInt(),
    totalEarned: (data['totalEarned'] as num? ?? 0).toInt(),
    history: (data['history'] as List<dynamic>? ?? const [])
        .map((entry) =>
            stampHistoryEntryFromFirestore(entry as Map<String, dynamic>))
        .toList(),
  );
}

StampHistoryEntry stampHistoryEntryFromFirestore(Map<String, dynamic> data) {
  return StampHistoryEntry(
    id: data['id'] as String? ?? '',
    cups: (data['cups'] as num? ?? 0).toInt(),
    rewards: (data['rewards'] as num? ?? 0).toInt(),
    createdAt: firestoreDateTime(data['createdAt']),
  );
}

Map<String, dynamic> stampDataToFirestore(StampData data) {
  return {
    'count': data.count,
    'totalEarned': data.totalEarned,
    'history': data.history.map(stampHistoryEntryToFirestore).toList(),
  };
}

Map<String, dynamic> stampHistoryEntryToFirestore(StampHistoryEntry entry) {
  return {
    'id': entry.id,
    'cups': entry.cups,
    'rewards': entry.rewards,
    'createdAt': Timestamp.fromDate(entry.createdAt),
  };
}
