import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/presentation/auth_providers.dart';
import '../data/firestore_points_repository.dart';
import '../data/firestore_qr_issue_repository.dart';
import '../data/firestore_qr_points_repository.dart';
import '../data/local_points_repository.dart';
import '../data/local_qr_issue_repository.dart';
import '../data/local_qr_points_repository.dart';
import '../domain/points_models.dart';
import '../domain/points_repository.dart';
import '../domain/qr_issue_repository.dart';
import '../domain/qr_points_repository.dart';

final pointsRepositoryProvider = Provider<PointsRepository>((ref) {
  try {
    if (Firebase.apps.isNotEmpty) {
      final user = ref.watch(authStateProvider).value;
      if (user != null) {
        return FirestorePointsRepository(uid: user.uid);
      }
    }
  } catch (_) {}
  return LocalPointsRepository();
});

final qrPointsRepositoryProvider = Provider<QrPointsRepository>((ref) {
  try {
    if (Firebase.apps.isNotEmpty) {
      final user = ref.watch(authStateProvider).value;
      if (user != null) {
        return FirestoreQrPointsRepository(uid: user.uid);
      }
    }
  } catch (_) {}
  return LocalQrPointsRepository(ref.watch(pointsRepositoryProvider));
});

final qrIssueRepositoryProvider = Provider<QrIssueRepository>((ref) {
  try {
    if (Firebase.apps.isNotEmpty) {
      final user = ref.watch(authStateProvider).value;
      if (user != null) {
        return FirestoreQrIssueRepository(uid: user.uid);
      }
    }
  } catch (_) {}
  return LocalQrIssueRepository();
});

final pointsControllerProvider =
    AsyncNotifierProvider<PointsController, PointsData>(PointsController.new);

class PointsController extends AsyncNotifier<PointsData> {
  @override
  Future<PointsData> build() {
    return ref.watch(pointsRepositoryProvider).load();
  }

  Future<void> usePoints({
    required int amount,
    String description = '포인트 결제',
  }) async {
    final repository = ref.read(pointsRepositoryProvider);
    state = await AsyncValue.guard(
      () => repository.usePoints(amount: amount, description: description),
    );
  }

  Future<QrEarnResult> earnFromQr(String code) async {
    final result = await ref.read(qrPointsRepositoryProvider).earnFromQr(code);
    state = await AsyncValue.guard(
      () => ref.read(pointsRepositoryProvider).load(),
    );
    return result;
  }
}
