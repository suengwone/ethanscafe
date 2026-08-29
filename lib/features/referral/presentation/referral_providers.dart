import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/presentation/auth_providers.dart';
import '../../points/data/local_points_repository.dart';
import '../../points/presentation/points_providers.dart';
import '../data/cloud_functions_referral_repository.dart';
import '../data/local_referral_repository.dart';
import '../domain/referral_models.dart';
import '../domain/referral_repository.dart';

final referralRepositoryProvider = Provider<ReferralRepository>((ref) {
  try {
    if (Firebase.apps.isNotEmpty &&
        ref.watch(authStateProvider).value != null) {
      return CloudFunctionsReferralRepository();
    }
  } catch (_) {}
  final pointsRepository = ref.watch(pointsRepositoryProvider);
  return LocalReferralRepository(
    pointsRepository: pointsRepository is LocalPointsRepository
        ? pointsRepository
        : null,
  );
});

final referralControllerProvider =
    AsyncNotifierProvider<ReferralController, ReferralSummary>(
      ReferralController.new,
    );

class ReferralController extends AsyncNotifier<ReferralSummary> {
  @override
  Future<ReferralSummary> build() {
    return ref.watch(referralRepositoryProvider).load();
  }

  Future<ReferralRedeemResult> redeem(String code) async {
    final result = await ref.read(referralRepositoryProvider).redeem(code);
    state = AsyncData(result.summary);
    // 보상이 바로 잔액에 반영되므로 포인트 화면도 다시 읽게 한다.
    ref.invalidate(pointsControllerProvider);
    return result;
  }
}
