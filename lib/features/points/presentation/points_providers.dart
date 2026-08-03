import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local_points_repository.dart';
import '../domain/points_models.dart';
import '../domain/points_repository.dart';

final pointsRepositoryProvider = Provider<PointsRepository>((ref) {
  return LocalPointsRepository();
});

final pointsControllerProvider =
    AsyncNotifierProvider<PointsController, PointsData>(PointsController.new);

class PointsController extends AsyncNotifier<PointsData> {
  @override
  Future<PointsData> build() {
    return ref.watch(pointsRepositoryProvider).load();
  }

  Future<void> recordPayment({
    required int paymentAmount,
    String description = '매장 결제',
  }) async {
    final repository = ref.read(pointsRepositoryProvider);
    state = await AsyncValue.guard(
      () => repository.recordPayment(
        paymentAmount: paymentAmount,
        description: description,
      ),
    );
  }

  Future<void> usePoints({
    required int amount,
    String description = '포인트 결제',
  }) async {
    final repository = ref.read(pointsRepositoryProvider);
    state = await AsyncValue.guard(
      () => repository.usePoints(amount: amount, description: description),
    );
  }
}
