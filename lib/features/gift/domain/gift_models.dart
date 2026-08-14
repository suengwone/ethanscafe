import 'package:freezed_annotation/freezed_annotation.dart';

import '../../beans/domain/bean_models.dart';

part 'gift_models.freezed.dart';
part 'gift_models.g.dart';

enum BeanGiftStatus {
  sent('선물 전송'),
  redeemed('수령 완료');

  const BeanGiftStatus(this.label);

  final String label;
}

@freezed
abstract class BeanGift with _$BeanGift {
  const BeanGift._();

  const factory BeanGift({
    required String id,
    required String beanId,
    required String beanName,
    required BeanWeight weight,
    required GrindOption grind,
    required int quantity,
    required int unitPrice,
    required String recipientName,
    required String recipientPhone,
    @Default('') String message,
    @Default(BeanGiftStatus.sent) BeanGiftStatus status,
    required DateTime createdAt,
  }) = _BeanGift;

  factory BeanGift.fromJson(Map<String, dynamic> json) =>
      _$BeanGiftFromJson(json);

  int get totalPrice => unitPrice * quantity;

  String get optionLabel => '${weight.label} · ${grind.label}';

  String get summary => quantity == 1 ? beanName : '$beanName $quantity개';
}
