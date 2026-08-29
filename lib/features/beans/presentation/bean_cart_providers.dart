import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../order/domain/order_models.dart';
import '../../profile/domain/delivery_address.dart';
import '../../store/domain/store_models.dart';
import '../domain/bean_cart_models.dart';
import '../domain/bean_models.dart';

const beanCartMaxQuantity = 9;

final beanCartProvider = NotifierProvider<BeanCartNotifier, List<BeanCartItem>>(
  BeanCartNotifier.new,
);

class BeanCartNotifier extends Notifier<List<BeanCartItem>> {
  @override
  List<BeanCartItem> build() => const [];

  void add({
    required Bean bean,
    required BeanWeight weight,
    required GrindOption grind,
    int quantity = 1,
  }) {
    final index = state.indexWhere(
      (item) => item.hasSameOption(bean: bean, weight: weight, grind: grind),
    );
    if (index >= 0) {
      final item = state[index];
      final merged = (item.quantity + quantity).clamp(1, beanCartMaxQuantity);
      state = [...state]..[index] = item.copyWith(quantity: merged);
      return;
    }
    state = [
      ...state,
      BeanCartItem(
        bean: bean,
        weight: weight,
        grind: grind,
        quantity: quantity.clamp(1, beanCartMaxQuantity),
      ),
    ];
  }

  void changeQuantity(int index, int quantity) {
    if (index < 0 || index >= state.length) return;
    if (quantity < 1 || quantity > beanCartMaxQuantity) return;
    state = [...state]..[index] = state[index].copyWith(quantity: quantity);
  }

  void removeAt(int index) {
    if (index < 0 || index >= state.length) return;
    state = [...state]..removeAt(index);
  }

  /// 실수로 지운 항목을 원래 자리에 되돌린다.
  void insertAt(int index, BeanCartItem item) {
    final position = index.clamp(0, state.length);
    state = [...state]..insert(position, item);
  }

  void clear() => state = const [];
}

final beanCartCountProvider = Provider<int>((ref) {
  return ref
      .watch(beanCartProvider)
      .fold(0, (sum, item) => sum + item.quantity);
});

final beanCartTotalProvider = Provider<int>((ref) {
  return ref
      .watch(beanCartProvider)
      .fold(0, (sum, item) => sum + item.totalPrice);
});

final beanFulfillmentMethodProvider =
    NotifierProvider<BeanFulfillmentMethodNotifier, BeanFulfillmentMethod>(
      BeanFulfillmentMethodNotifier.new,
    );

class BeanFulfillmentMethodNotifier extends Notifier<BeanFulfillmentMethod> {
  @override
  BeanFulfillmentMethod build() => BeanFulfillmentMethod.delivery;

  void select(BeanFulfillmentMethod method) => state = method;
}

final beanDeliveryAddressProvider =
    NotifierProvider<BeanDeliveryAddressNotifier, DeliveryAddress?>(
      BeanDeliveryAddressNotifier.new,
    );

class BeanDeliveryAddressNotifier extends Notifier<DeliveryAddress?> {
  @override
  DeliveryAddress? build() => null;

  void select(DeliveryAddress address) => state = address;
}

final beanPickupStoreProvider =
    NotifierProvider<BeanPickupStoreNotifier, CafeStore?>(
      BeanPickupStoreNotifier.new,
    );

class BeanPickupStoreNotifier extends Notifier<CafeStore?> {
  @override
  CafeStore? build() => null;

  void select(CafeStore store) => state = store;
}
