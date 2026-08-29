import '../../../l10n/app_localizations.dart';
import '../domain/subscription_models.dart';

extension SubscriptionLabels on AppLocalizations {
  String subscriptionCycleLabel(SubscriptionCycle cycle) => switch (cycle) {
    SubscriptionCycle.weekly => subscriptionCycleWeekly,
    SubscriptionCycle.biweekly => subscriptionCycleBiweekly,
    SubscriptionCycle.monthly => subscriptionCycleMonthly,
  };

  String subscriptionStatusLabel(SubscriptionStatus status) => switch (status) {
    SubscriptionStatus.active => subscriptionStatusActive,
    SubscriptionStatus.paused => subscriptionStatusPaused,
    SubscriptionStatus.cancelled => subscriptionStatusCancelled,
  };
}
