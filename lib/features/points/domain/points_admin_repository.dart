import 'points_models.dart';

abstract class PointsAdminRepository {
  Future<PointsEarnResult> earnByMembershipId({
    required String membershipId,
    required int paymentAmount,
  });
}
