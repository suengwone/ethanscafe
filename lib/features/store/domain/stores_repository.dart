import 'store_models.dart';

abstract class StoresRepository {
  Future<List<CafeStore>> loadStores();

  /// 매장 ID로 찾을 수 있게 담은 자동 집계 혼잡도. 집계가 없는 매장은 빠진다.
  Future<Map<String, StoreActivity>> loadActivity();
}
