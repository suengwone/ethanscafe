import '../domain/points_admin_repository.dart';
import '../domain/points_models.dart';
import '../domain/points_repository.dart';

class LocalPointsAdminRepository implements PointsAdminRepository {
  LocalPointsAdminRepository(this._points);

  final PointsRepository _points;

  @override
  Future<PointsEarnResult> earnByMembershipId({
    required String membershipId,
    required int paymentAmount,
  }) async {
    final trimmed = membershipId.trim();
    if (trimmed.isEmpty) {
      throw const FormatException('회원 QR 코드가 올바르지 않습니다.');
    }
    if (paymentAmount <= 0) {
      throw ArgumentError.value(
        paymentAmount,
        'paymentAmount',
        '결제 금액은 0보다 커야 합니다.',
      );
    }

    final before = await _points.load();
    if (before.membershipId != trimmed) {
      throw const FormatException('등록되지 않은 회원 QR 코드입니다.');
    }

    final updated = await _points.recordPayment(paymentAmount: paymentAmount);
    return PointsEarnResult(
      membershipId: trimmed,
      paymentAmount: paymentAmount,
      earned: updated.balance - before.balance,
      balance: updated.balance,
    );
  }
}
