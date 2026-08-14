import '../../beans/domain/bean_models.dart';
import 'subscription_models.dart';

abstract class BeanSubscriptionsRepository {
  Future<List<BeanSubscription>> load();

  Future<BeanSubscription> subscribe({
    required String beanId,
    required String beanName,
    required BeanWeight weight,
    required GrindOption grind,
    required int quantity,
    required SubscriptionCycle cycle,
    required int unitPrice,
  });

  Future<BeanSubscription> updateStatus({
    required String id,
    required SubscriptionStatus status,
  });
}
