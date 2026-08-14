import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/presentation/auth_providers.dart';
import '../data/firestore_wholesale_quotes_repository.dart';
import '../data/local_wholesale_beans_repository.dart';
import '../data/local_wholesale_quotes_repository.dart';
import '../domain/wholesale_beans_repository.dart';
import '../domain/wholesale_models.dart';
import '../domain/wholesale_quotes_repository.dart';

final wholesaleBeansRepositoryProvider =
    Provider<WholesaleBeansRepository>((ref) {
  return LocalWholesaleBeansRepository();
});

final wholesaleBeansProvider = FutureProvider<List<WholesaleBean>>((ref) {
  return ref.watch(wholesaleBeansRepositoryProvider).loadWholesaleBeans();
});

final wholesaleQuotesRepositoryProvider =
    Provider<WholesaleQuotesRepository>((ref) {
  try {
    if (Firebase.apps.isNotEmpty) {
      final user = ref.watch(authStateProvider).value;
      if (user != null) {
        return FirestoreWholesaleQuotesRepository(uid: user.uid);
      }
    }
  } catch (_) {}
  return LocalWholesaleQuotesRepository();
});

final wholesaleQuotesControllerProvider =
    AsyncNotifierProvider<WholesaleQuotesController, List<WholesaleQuote>>(
  WholesaleQuotesController.new,
);

class WholesaleQuotesController extends AsyncNotifier<List<WholesaleQuote>> {
  @override
  Future<List<WholesaleQuote>> build() {
    return ref.watch(wholesaleQuotesRepositoryProvider).load();
  }

  Future<WholesaleQuote> submitQuote({
    required String companyName,
    required List<WholesaleQuoteItem> items,
    String memo = '',
  }) async {
    final quote = await ref.read(wholesaleQuotesRepositoryProvider).submitQuote(
          companyName: companyName,
          items: items,
          memo: memo,
        );
    state = AsyncValue.data([quote, ...state.value ?? const []]);
    return quote;
  }
}
