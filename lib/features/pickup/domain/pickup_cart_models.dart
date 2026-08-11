import 'package:freezed_annotation/freezed_annotation.dart';

import '../../menu/domain/menu_models.dart';

part 'pickup_cart_models.freezed.dart';

@freezed
abstract class PickupCartItem with _$PickupCartItem {
  const PickupCartItem._();

  const factory PickupCartItem({
    required MenuItem menuItem,
    String? option,
    required int quantity,
  }) = _PickupCartItem;

  int get unitPrice => menuItem.price;

  int get totalPrice => unitPrice * quantity;

  String? get optionLabel => option;

  bool hasSameOption({required MenuItem menuItem, String? option}) =>
      this.menuItem.id == menuItem.id && this.option == option;
}
