import '../domain/points_models.dart';
import '../domain/points_repository.dart';
import '../domain/qr_points_repository.dart';

class LocalQrPointsRepository implements QrPointsRepository {
  LocalQrPointsRepository(this._pointsRepository);

  static const earnRate = 0.1;

  final PointsRepository _pointsRepository;

  @override
  Future<QrEarnResult> earnFromQr(String code) async {
    final payload = parseQrPayCode(code);
    if (payload == null) {
      throw const FormatException('지원하지 않는 QR 코드입니다.');
    }

    final updated = await _pointsRepository.recordPayment(
      paymentAmount: payload.paymentAmount,
      description: payload.storeName,
    );
    return QrEarnResult(
      storeName: payload.storeName,
      paymentAmount: payload.paymentAmount,
      earned: (payload.paymentAmount * earnRate).floor(),
      balance: updated.balance,
    );
  }
}

const qrPayCodePrefix = 'FOXTROT-PAY:';

({String storeName, int paymentAmount})? parseQrPayCode(String code) {
  final trimmed = code.trim();
  if (!trimmed.startsWith(qrPayCodePrefix)) {
    return null;
  }

  final body = trimmed.substring(qrPayCodePrefix.length);
  final separatorIndex = body.indexOf(':');
  if (separatorIndex <= 0) {
    return null;
  }

  final paymentAmount = int.tryParse(body.substring(0, separatorIndex));
  final storeName = body.substring(separatorIndex + 1).trim();
  if (paymentAmount == null || paymentAmount <= 0 || storeName.isEmpty) {
    return null;
  }

  return (storeName: storeName, paymentAmount: paymentAmount);
}
