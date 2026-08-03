import 'menu_models.dart';

abstract class MenuRepository {
  Future<List<MenuItem>> loadMenuItems();
}
