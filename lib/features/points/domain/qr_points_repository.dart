import 'points_models.dart';

abstract class QrPointsRepository {
  Future<QrEarnResult> earnFromQr(String code);
}
