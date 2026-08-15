import 'stamp_models.dart';

abstract class StampAdminRepository {
  Future<StampEarnResult> earnByMembershipId({
    required String membershipId,
    required int cups,
  });
}
