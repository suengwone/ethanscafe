import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/notification_settings.dart';

class FirestoreNotificationSettingsRepository
    implements NotificationSettingsRepository {
  FirestoreNotificationSettingsRepository({
    required this.uid,
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final String uid;
  final FirebaseFirestore _firestore;

  static const collectionPath = 'notificationSettings';

  DocumentReference<Map<String, dynamic>> get _doc =>
      _firestore.collection(collectionPath).doc(uid);

  @override
  Future<NotificationSettings> load() async {
    final snapshot = await _doc.get();
    final data = snapshot.data();
    if (data == null) {
      return const NotificationSettings();
    }
    return NotificationSettings.fromJson(data);
  }

  @override
  Future<void> save(NotificationSettings settings) {
    return _doc.set(settings.toJson());
  }
}
