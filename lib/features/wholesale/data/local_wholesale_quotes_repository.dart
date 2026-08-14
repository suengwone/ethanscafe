import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/wholesale_models.dart';
import '../domain/wholesale_quotes_repository.dart';

class LocalWholesaleQuotesRepository implements WholesaleQuotesRepository {
  static const _storageKey = 'wholesale_quotes';

  @override
  Future<List<WholesaleQuote>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null) {
      return const [];
    }
    final data = jsonDecode(raw) as Map<String, dynamic>;
    return ((data['quotes'] as List<dynamic>?) ?? const [])
        .map((quote) => WholesaleQuote.fromJson(quote as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<WholesaleQuote> submitQuote({
    required String companyName,
    required List<WholesaleQuoteItem> items,
    String memo = '',
  }) async {
    validateQuoteRequest(companyName: companyName, items: items);

    final prefs = await SharedPreferences.getInstance();
    final quotes = await load();
    final quote = WholesaleQuote(
      id: _generateId(),
      companyName: companyName.trim(),
      items: items,
      memo: memo.trim(),
      createdAt: DateTime.now(),
    );

    await prefs.setString(
      _storageKey,
      jsonEncode({
        'quotes': [quote, ...quotes].map((quote) => quote.toJson()).toList(),
      }),
    );
    return quote;
  }

  String _generateId() =>
      '${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(0xFFFF)}';
}
