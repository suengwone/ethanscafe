import 'package:freezed_annotation/freezed_annotation.dart';

import '../../beans/domain/bean_models.dart';

part 'gift_models.freezed.dart';
part 'gift_models.g.dart';

/// 이름은 `gift_labels.dart`의 확장이 l10n에서 꺼내 온다.
enum BeanGiftStatus { sent, redeemed }

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


}
