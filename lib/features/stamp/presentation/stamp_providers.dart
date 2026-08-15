import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/presentation/auth_providers.dart';
import '../../coupon/presentation/coupons_providers.dart';
import '../../points/presentation/points_providers.dart';
import '../data/firestore_stamp_admin_repository.dart';
import '../data/firestore_stamps_repository.dart';
import '../data/local_stamp_admin_repository.dart';
import '../data/local_stamps_repository.dart';
import '../domain/stamp_admin_repository.dart';
import '../domain/stamp_models.dart';
import '../domain/stamps_repository.dart';

final _localStampsRepositoryProvider =
    Provider<LocalStampsRepository>((ref) => LocalStampsRepository());

final stampsRepositoryProvider = Provider<StampsRepository>((ref) {
  try {
    if (Firebase.apps.isNotEmpty) {
      final user = ref.watch(authStateProvider).value;
      if (user != null) {
        return FirestoreStampsRepository(uid: user.uid);
      }
    }
  } catch (_) {}
  return ref.watch(_localStampsRepositoryProvider);
});

final stampAdminRepositoryProvider = Provider<StampAdminRepository>((ref) {
  try {
    if (Firebase.apps.isNotEmpty) {
      final user = ref.watch(authStateProvider).value;
      if (user != null) {
        return FirestoreStampAdminRepository();
      }
    }
  } catch (_) {}
  return LocalStampAdminRepository(
    ref.watch(_localStampsRepositoryProvider),
    ref.watch(pointsRepositoryProvider),
    ref.watch(couponsRepositoryProvider),
  );
});

final stampControllerProvider =
    AsyncNotifierProvider<StampController, StampData>(StampController.new);

class StampController extends AsyncNotifier<StampData> {
  @override
  Future<StampData> build() {
    return ref.watch(stampsRepositoryProvider).load();
  }

  Future<StampEarnResult> earnByMembershipId({
    required String membershipId,
    required int cups,
  }) async {
    final result =
        await ref.read(stampAdminRepositoryProvider).earnByMembershipId(
              membershipId: membershipId,
              cups: cups,
            );
    ref.invalidateSelf();
    ref.invalidate(couponsControllerProvider);
    return result;
  }
}
