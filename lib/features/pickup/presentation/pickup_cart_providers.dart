import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../menu/domain/menu_models.dart';
import '../../store/domain/store_models.dart';
import '../domain/pickup_cart_models.dart';

const pickupCartMaxQuantity = 9;

final pickupCartProvider =
    NotifierProvider<PickupCartNotifier, List<PickupCartItem>>(
      PickupCartNotifier.new,
    );

class PickupCartNotifier extends Notifier<List<PickupCartItem>> {
  @override
  List<PickupCartItem> build() => const [];

  void add({required MenuItem menuItem, String? option, int quantity = 1}) {
    final index = state.indexWhere(
      (item) => item.hasSameOption(menuItem: menuItem, option: option),
    );
    if (index >= 0) {
      final item = state[index];
      final merged = (item.quantity + quantity).clamp(
        1,
        pickupCartMaxQuantity,
      );
      state = [...state]..[index] = item.copyWith(quantity: merged);
      return;
    }
    state = [
      ...state,
      PickupCartItem(
        menuItem: menuItem,
        option: option,
        quantity: quantity.clamp(1, pickupCartMaxQuantity),
      ),
    ];
  }

  void changeQuantity(int index, int quantity) {
    if (index < 0 || index >= state.length) return;
    if (quantity < 1 || quantity > pickupCartMaxQuantity) return;
    state = [...state]..[index] = state[index].copyWith(quantity: quantity);
  }

  void removeAt(int index) {
    if (index < 0 || index >= state.length) return;
    state = [...state]..removeAt(index);
  }

  /// 실수로 지운 항목을 원래 자리에 되돌린다.
  void insertAt(int index, PickupCartItem item) {
    final position = index.clamp(0, state.length);
    state = [...state]..insert(position, item);
  }

  void clear() => state = const [];
}

final pickupCartCountProvider = Provider<int>((ref) {
  return ref
      .watch(pickupCartProvider)
      .fold(0, (sum, item) => sum + item.quantity);
});

final pickupCartTotalProvider = Provider<int>((ref) {
  return ref
      .watch(pickupCartProvider)
      .fold(0, (sum, item) => sum + item.totalPrice);
});

final pickupStoreProvider = NotifierProvider<PickupStoreNotifier, CafeStore?>(
  PickupStoreNotifier.new,
);

class PickupStoreNotifier extends Notifier<CafeStore?> {
  @override
  CafeStore? build() => null;

  void select(CafeStore store) => state = store;
}
