import '../../beans/domain/bean_cart_models.dart';
import '../../beans/domain/bean_models.dart';
import '../../menu/domain/menu_models.dart';
import '../../pickup/domain/pickup_cart_models.dart';
import '../../pickup/domain/pickup_order_models.dart';
import 'order_models.dart';

class ReorderResult<T> {
  const ReorderResult({required this.items, required this.missingNames});

  final List<T> items;
  final List<String> missingNames;

  bool get hasItems => items.isNotEmpty;

  bool get hasMissing => missingNames.isNotEmpty;
}

ReorderResult<BeanCartItem> buildBeanReorder({
  required BeanOrder order,
  required List<Bean> beans,
}) {
  final beansById = {for (final bean in beans) bean.id: bean};
  final items = <BeanCartItem>[];
  final missingNames = <String>[];

  for (final item in order.items) {
    final bean = beansById[item.beanId];
    if (bean == null) {
      missingNames.add(item.beanName);
      continue;
    }
    items.add(
      BeanCartItem(
        bean: bean,
        weight: item.weight,
        grind: item.grind,
        quantity: item.quantity,
      ),
    );
  }

  return ReorderResult(items: items, missingNames: missingNames);
}

ReorderResult<PickupCartItem> buildPickupReorder({
  required PickupOrder order,
  required List<MenuItem> menuItems,
}) {
  final menuById = {for (final menu in menuItems) menu.id: menu};
  final items = <PickupCartItem>[];
  final missingNames = <String>[];

  for (final item in order.items) {
    final menu = menuById[item.menuId];
    if (menu == null) {
      missingNames.add(item.menuName);
      continue;
    }
    items.add(
      PickupCartItem(
        menuItem: menu,
        option: item.option,
        quantity: item.quantity,
      ),
    );
  }

  return ReorderResult(items: items, missingNames: missingNames);
}
