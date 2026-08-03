import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/firestore_notices_repository.dart';
import '../data/local_notices_repository.dart';
import '../domain/notice_models.dart';
import '../domain/notices_repository.dart';

final noticesRepositoryProvider = Provider<NoticesRepository>((ref) {
  try {
    if (Firebase.apps.isNotEmpty) {
      return FirestoreNoticesRepository();
    }
  } catch (_) {}
  return LocalNoticesRepository();
});

final noticesProvider = FutureProvider<List<Notice>>((ref) {
  return ref.watch(noticesRepositoryProvider).loadNotices();
});
