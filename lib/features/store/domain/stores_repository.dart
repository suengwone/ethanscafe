import 'store_models.dart';

abstract class StoresRepository {
  Future<List<CafeStore>> loadStores();
}
