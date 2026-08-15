import '../domain/points_models.dart';
import '../domain/qr_issue_repository.dart';
import 'local_qr_points_repository.dart';

class LocalQrIssueRepository implements QrIssueRepository {
  static const tokenLifetime = Duration(minutes: 5);

  @override
  Future<IssuedQrToken> issue({
    required int paymentAmount,
    required String storeName,
  }) async {
    if (paymentAmount <= 0) {
      throw ArgumentError.value(
          paymentAmount, 'paymentAmount', '결제 금액은 0보다 커야 합니다.');
    }
    final trimmedStoreName = storeName.trim();
    if (trimmedStoreName.isEmpty) {
      throw ArgumentError.value(storeName, 'storeName', '매장명을 입력해주세요.');
    }

    return IssuedQrToken(
      code: '$qrPayCodePrefix$paymentAmount:$trimmedStoreName',
      storeName: trimmedStoreName,
      paymentAmount: paymentAmount,
      expiresAt: DateTime.now().add(tokenLifetime),
    );
  }
}
