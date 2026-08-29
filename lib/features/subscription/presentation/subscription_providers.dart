import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/presentation/auth_providers.dart';
import '../../beans/domain/bean_models.dart';
import '../data/firestore_bean_subscriptions_repository.dart';
import '../data/local_bean_subscriptions_repository.dart';
import '../domain/bean_subscriptions_repository.dart';
import '../domain/subscription_models.dart';

final beanSubscriptionsRepositoryProvider =
    Provider<BeanSubscriptionsRepository>((ref) {
      try {
        if (Firebase.apps.isNotEmpty) {
          final user = ref.watch(authStateProvider).value;
          if (user != null) {
            return FirestoreBeanSubscriptionsRepository(uid: user.uid);
          }
        }
      } catch (_) {}
      return LocalBeanSubscriptionsRepository();
    });

final beanSubscriptionsControllerProvider =
    AsyncNotifierProvider<BeanSubscriptionsController, List<BeanSubscription>>(
      BeanSubscriptionsController.new,
    );

final activeSubscriptionCountProvider = Provider<int>((ref) {
  final subscriptions =
      ref.watch(beanSubscriptionsControllerProvider).value ?? const [];
  return subscriptions
      .where((subscription) => !subscription.isCancelled)
      .length;
});

class BeanSubscriptionsController
    extends AsyncNotifier<List<BeanSubscription>> {
  @override
  Future<List<BeanSubscription>> build() {
    return ref.watch(beanSubscriptionsRepositoryProvider).load();
  }

  Future<BeanSubscription> subscribe({
    required Bean bean,
    required BeanWeight weight,
    required GrindOption grind,
    required int quantity,
    required SubscriptionCycle cycle,
  }) async {
    final subscription = await ref
        .read(beanSubscriptionsRepositoryProvider)
        .subscribe(
          beanId: bean.id,
          beanName: bean.name,
          weight: weight,
          grind: grind,
          quantity: quantity,
          cycle: cycle,
          unitPrice: bean.priceOf(weight),
        );
    state = AsyncValue.data([subscription, ...state.value ?? const []]);
    return subscription;
  }

  Future<void> pause(String id) => _updateStatus(id, SubscriptionStatus.paused);

  Future<void> resume(String id) =>
      _updateStatus(id, SubscriptionStatus.active);

  Future<void> cancel(String id) =>
      _updateStatus(id, SubscriptionStatus.cancelled);

  Future<void> _updateStatus(String id, SubscriptionStatus status) async {
    final updated = await ref
        .read(beanSubscriptionsRepositoryProvider)
        .updateStatus(id: id, status: status);
    state = AsyncValue.data([
      for (final subscription in state.value ?? const <BeanSubscription>[])
        subscription.id == id ? updated : subscription,
    ]);
  }
}
