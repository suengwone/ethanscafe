import 'bean_models.dart';

abstract class BeansRepository {
  Future<List<Bean>> loadBeans();
}
