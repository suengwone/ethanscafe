import 'points_models.dart';

enum MembershipTier {
  green('그린', 0, 10),
  gold('골드', 300000, 12),
  platinum('플래티넘', 1000000, 15);

  const MembershipTier(this.label, this.threshold, this.earnRatePercent);

  final String label;
  final int threshold;
  final int earnRatePercent;

  int earnPoints(int paymentAmount) => paymentAmount * earnRatePercent ~/ 100;

  MembershipTier? get next => index + 1 < MembershipTier.values.length
      ? MembershipTier.values[index + 1]
      : null;
}

int cumulativeSpending(List<PointHistoryEntry> history) => history
    .where((entry) => entry.isEarn && entry.paymentAmount != null)
    .fold(0, (sum, entry) => sum + (entry.paymentAmount ?? 0));

MembershipTier membershipTierForSpending(int spending) {
  var tier = MembershipTier.green;
  for (final candidate in MembershipTier.values) {
    if (spending >= candidate.threshold) {
      tier = candidate;
    }
  }
  return tier;
}

MembershipTier membershipTierOf(List<PointHistoryEntry> history) =>
    membershipTierForSpending(cumulativeSpending(history));

extension PointsDataMembershipTier on PointsData {
  int get cumulativePayment => cumulativeSpending(history);

  MembershipTier get tier => membershipTierOf(history);

  int? get remainingToNextTier {
    final next = tier.next;
    if (next == null) {
      return null;
    }
    return next.threshold - cumulativePayment;
  }
}
