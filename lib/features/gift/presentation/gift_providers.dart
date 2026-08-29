import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/presentation/auth_providers.dart';
import '../../beans/domain/bean_models.dart';
import '../data/firestore_bean_gifts_repository.dart';
import '../data/local_bean_gifts_repository.dart';
import '../domain/bean_gifts_repository.dart';
import '../domain/gift_models.dart';

final beanGiftsRepositoryProvider = Provider<BeanGiftsRepository>((ref) {
  try {
    if (Firebase.apps.isNotEmpty) {
      final user = ref.watch(authStateProvider).value;
      if (user != null) {
        return FirestoreBeanGiftsRepository(uid: user.uid);
      }
    }
  } catch (_) {}
  return LocalBeanGiftsRepository();
});

final beanGiftsControllerProvider =
    AsyncNotifierProvider<BeanGiftsController, List<BeanGift>>(
      BeanGiftsController.new,
    );

class BeanGiftsController extends AsyncNotifier<List<BeanGift>> {
  @override
  Future<List<BeanGift>> build() {
    return ref.watch(beanGiftsRepositoryProvider).load();
  }

  Future<BeanGift> sendGift({
    required Bean bean,
    required BeanWeight weight,
    required GrindOption grind,
    required int quantity,
    required String recipientName,
    required String recipientPhone,
    String message = '',
  }) async {
    final gift = await ref
        .read(beanGiftsRepositoryProvider)
        .sendGift(
          beanId: bean.id,
          beanName: bean.name,
          weight: weight,
          grind: grind,
          quantity: quantity,
          unitPrice: bean.priceOf(weight),
          recipientName: recipientName,
          recipientPhone: recipientPhone,
          message: message,
        );
    state = AsyncValue.data([gift, ...state.value ?? const []]);
    return gift;
  }
}
