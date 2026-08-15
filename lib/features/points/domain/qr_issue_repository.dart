import 'points_models.dart';

abstract class QrIssueRepository {
  Future<IssuedQrToken> issue({
    required int paymentAmount,
    required String storeName,
  });
}
