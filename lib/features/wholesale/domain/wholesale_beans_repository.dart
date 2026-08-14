import 'wholesale_models.dart';

abstract class WholesaleBeansRepository {
  Future<List<WholesaleBean>> loadWholesaleBeans();
}
