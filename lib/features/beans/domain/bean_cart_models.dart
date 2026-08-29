import 'package:freezed_annotation/freezed_annotation.dart';

import 'bean_models.dart';

part 'bean_cart_models.freezed.dart';

@freezed
abstract class BeanCartItem with _$BeanCartItem {
  const BeanCartItem._();

  const factory BeanCartItem({
    required Bean bean,
    required BeanWeight weight,
    required GrindOption grind,
    required int quantity,
  }) = _BeanCartItem;

  int get unitPrice => bean.priceOf(weight);

  int get totalPrice => unitPrice * quantity;

  bool hasSameOption({
    required Bean bean,
    required BeanWeight weight,
    required GrindOption grind,
  }) => this.bean.id == bean.id && this.weight == weight && this.grind == grind;
}
