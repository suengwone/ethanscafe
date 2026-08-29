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
    throw ArgumentError.value(
      companyName,
      'companyName',
      'The company name is empty.',
    );
  }
  if (items.isEmpty) {
    throw ArgumentError.value(items, 'items', 'The quote has no beans in it.');
  }
  for (final item in items) {
    if (item.kg <= 0) {
      throw ArgumentError.value(item.kg, 'kg', 'Each line needs at least 1kg.');
    }
  }
}
