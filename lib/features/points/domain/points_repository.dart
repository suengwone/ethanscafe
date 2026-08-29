import 'points_models.dart';

abstract class PointsRepository {
  Future<PointsData> load();

  Future<PointsData> recordPayment({
    required int paymentAmount,
    String description,
  });

  Future<PointsData> usePoints({required int amount, String description});

  Future<PointsData> refundOrderPoints({
    int usedPoints,
    int earnedPoints,
    String description,
  });
}
