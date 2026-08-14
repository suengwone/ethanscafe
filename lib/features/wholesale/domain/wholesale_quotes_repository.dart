import 'wholesale_models.dart';

abstract class WholesaleQuotesRepository {
  Future<List<WholesaleQuote>> load();

  Future<WholesaleQuote> submitQuote({
    required String companyName,
    required List<WholesaleQuoteItem> items,
    String memo,
  });
}

void validateQuoteRequest({
  required String companyName,
  required List<WholesaleQuoteItem> items,
}) {
  if (companyName.trim().isEmpty) {
    throw ArgumentError.value(companyName, 'companyName', '상호명이 비어 있습니다.');
  }
  if (items.isEmpty) {
    throw ArgumentError.value(items, 'items', '견적을 요청할 원두가 없습니다.');
  }
  for (final item in items) {
    if (item.kg <= 0) {
      throw ArgumentError.value(item.kg, 'kg', '주문 수량은 1kg 이상이어야 합니다.');
    }
  }
}
