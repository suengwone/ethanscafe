import 'package:cloud_functions/cloud_functions.dart';

import '../domain/points_admin_repository.dart';
import '../domain/points_models.dart';

class CloudFunctionsPointsAdminRepository implements PointsAdminRepository {
  CloudFunctionsPointsAdminRepository({FirebaseFunctions? functions})
    : _functions = functions ?? FirebaseFunctions.instanceFor(region: _region);

  static const _region = 'asia-northeast3';
  static const earnCallableName = 'earnPointsByMembership';

  final FirebaseFunctions _functions;

  @override
  Future<PointsEarnResult> earnByMembershipId({
    required String membershipId,
    required int paymentAmount,
  }) async {
    final trimmed = membershipId.trim();
    final result = await _functions
        .httpsCallable(earnCallableName)
        .call<Object?>({
          'membershipId': trimmed,
          'paymentAmount': paymentAmount,
        });
    final data = Map<String, dynamic>.from(result.data as Map);
    return PointsEarnResult(
      membershipId: data['membershipId'] as String? ?? trimmed,
      paymentAmount: (data['paymentAmount'] as num? ?? paymentAmount).toInt(),
      earned: (data['earned'] as num? ?? 0).toInt(),
      balance: (data['balance'] as num? ?? 0).toInt(),
    );
  }
}
