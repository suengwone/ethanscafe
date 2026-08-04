import 'package:cloud_functions/cloud_functions.dart';

import '../domain/points_models.dart';
import '../domain/qr_points_repository.dart';

class FunctionsQrPointsRepository implements QrPointsRepository {
  FunctionsQrPointsRepository({FirebaseFunctions? functions})
      : _functions =
            functions ?? FirebaseFunctions.instanceFor(region: region);

  static const region = 'asia-northeast3';
  static const callableName = 'earnPointsFromQr';

  final FirebaseFunctions _functions;

  @override
  Future<QrEarnResult> earnFromQr(String code) async {
    final result = await _functions
        .httpsCallable(callableName)
        .call<Map<Object?, Object?>>({'code': code});
    return qrEarnResultFromCallable(result.data);
  }
}

QrEarnResult qrEarnResultFromCallable(Map<Object?, Object?> data) {
  return QrEarnResult(
    storeName: data['storeName'] as String? ?? '매장 결제',
    paymentAmount: (data['paymentAmount'] as num? ?? 0).toInt(),
    earned: (data['earned'] as num? ?? 0).toInt(),
    balance: (data['balance'] as num? ?? 0).toInt(),
  );
}
