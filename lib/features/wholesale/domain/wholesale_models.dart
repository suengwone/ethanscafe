import 'package:freezed_annotation/freezed_annotation.dart';

import '../../beans/domain/bean_models.dart';

part 'wholesale_models.freezed.dart';
part 'wholesale_models.g.dart';

enum WholesaleQuoteStatus { requested, quoted, confirmed }

@freezed
abstract class WholesalePriceTier with _$WholesalePriceTier {
  const factory WholesalePriceTier({
    required int minKg,
    required int pricePerKg,
  }) = _WholesalePriceTier;
}

@freezed
abstract class WholesaleBean with _$WholesaleBean {
  const WholesaleBean._();

  const factory WholesaleBean({
    required String id,
    required String name,
    required String origin,
    required RoastLevel roastLevel,
    required String process,
    required List<String> tastingNotes,
    required int minOrderKg,
    required List<WholesalePriceTier> tiers,
    @Default(false) bool isBest,
  }) = _WholesaleBean;

  int get basePricePerKg => tiers.first.pricePerKg;

  int unitPriceFor(int kg) {
    var price = basePricePerKg;
    for (final tier in tiers) {
      if (kg >= tier.minKg) {
        price = tier.pricePerKg;
      }
    }
    return price;
  }

  int totalPriceFor(int kg) => unitPriceFor(kg) * kg;
}

@freezed
abstract class WholesaleQuoteItem with _$WholesaleQuoteItem {
  const WholesaleQuoteItem._();

  const factory WholesaleQuoteItem({
    required String beanId,
    required String beanName,
    required int kg,
    required int pricePerKg,
  }) = _WholesaleQuoteItem;

  factory WholesaleQuoteItem.fromJson(Map<String, dynamic> json) =>
      _$WholesaleQuoteItemFromJson(json);

  int get totalPrice => pricePerKg * kg;
}

@freezed
abstract class WholesaleQuote with _$WholesaleQuote {
  const WholesaleQuote._();

  const factory WholesaleQuote({
    required String id,
    required String companyName,
    required List<WholesaleQuoteItem> items,
    @Default('') String memo,
    @Default(WholesaleQuoteStatus.requested) WholesaleQuoteStatus status,
    required DateTime createdAt,
  }) = _WholesaleQuote;

  factory WholesaleQuote.fromJson(Map<String, dynamic> json) =>
      _$WholesaleQuoteFromJson(json);

  int get totalKg => items.fold(0, (sum, item) => sum + item.kg);

  int get totalAmount => items.fold(0, (sum, item) => sum + item.totalPrice);

  /// 목록에 보이는 대표 상품. 나머지 개수는 화면이 언어에 맞게 붙인다.
  String get firstItemName => items.isEmpty ? '' : items.first.beanName;
}
