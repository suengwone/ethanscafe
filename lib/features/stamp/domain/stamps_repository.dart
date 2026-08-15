import 'stamp_models.dart';

abstract class StampsRepository {
  Future<StampData> load();
}
