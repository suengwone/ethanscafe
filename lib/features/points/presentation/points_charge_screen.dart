import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../payment/domain/payment_models.dart';
import '../domain/charge_plans.dart';
import 'points_providers.dart';

final _amountFormat = NumberFormat('#,###');

class PointsChargeScreen extends ConsumerStatefulWidget {
  const PointsChargeScreen({super.key});

  @override
  ConsumerState<PointsChargeScreen> createState() => _PointsChargeScreenState();
}

class _PointsChargeScreenState extends ConsumerState<PointsChargeScreen> {
  ChargePlan _selected = chargePlans[1];
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    final pointsState = ref.watch(pointsControllerProvider);
    final balance = pointsState.value?.balance ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).pointsChargeTitle),
      ),
      body: SingleChildScrollView(
        padding: foxtrotListPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CurrentBalanceCard(balance: balance),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                AppLocalizations.of(context).pointsChargeChoose,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            for (final plan in chargePlans) ...[
              _ChargePlanCard(
                plan: plan,
                selected: plan == _selected,
                onTap: () => setState(() => _selected = plan),
              ),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 14),
            _ChargeSummaryCard(plan: _selected, balance: balance),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _submitting ? null : _charge,
              icon: const Icon(LucideIcons.creditCard, size: 18),
              label: Text(
                _submitting
                    ? AppLocalizations.of(context).pointsChargePaying
                    : AppLocalizations.of(
                        context,
                      ).pointsChargePay(_amountFormat.format(_selected.amount)),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context).pointsChargeRefundNotice,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _charge() async {
    final plan = _selected;
    setState(() => _submitting = true);
    try {
      final payment = await ref
          .read(pointsChargeGatewayProvider)
          .pay(
            context,
            PaymentRequest(
              orderId: generateChargeOrderId(),
              orderName: AppLocalizations.of(context).pointsChargeOrderName(
                chargeDescription,
                _amountFormat.format(plan.amount),
              ),
              amount: plan.amount,
            ),
          );
      if (!mounted) {
        return;
      }
      if (payment == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context).beanCartPaymentIncomplete,
            ),
          ),
        );
        return;
      }

      ref.invalidate(pointsControllerProvider);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              plan.bonus > 0
                  ? AppLocalizations.of(context).pointsChargedWithBonus(
                      _amountFormat.format(plan.totalPoints),
                      _amountFormat.format(plan.bonus),
                    )
                  : AppLocalizations.of(
                      context,
                    ).pointsCharged(_amountFormat.format(plan.totalPoints)),
            ),
          ),
        );
      Navigator.of(context).maybePop();
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }
}

class _CurrentBalanceCard extends StatelessWidget {
  const _CurrentBalanceCard({required this.balance});

  final int balance;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Text(
                AppLocalizations.of(context).pointsCurrentBalance,
                style: textTheme.titleSmall,
              ),
            ),
            Text(
              '${_amountFormat.format(balance)}P',
              style: textTheme.headlineMedium?.copyWith(fontSize: 22),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChargePlanCard extends StatelessWidget {
  const _ChargePlanCard({
    required this.plan,
    required this.selected,
    required this.onTap,
  });

  final ChargePlan plan;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected
              ? context.palette.accent.withValues(alpha: 0.12)
              : context.palette.card,
          borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
          border: Border.all(
            color: selected ? context.palette.accent : context.palette.border,
            width: selected ? 1.4 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected ? LucideIcons.circleCheck : LucideIcons.circle,
              size: 20,
              color: selected ? context.palette.accent : context.palette.border,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(
                      context,
                    ).pointsChargePlan(_amountFormat.format(plan.amount)),
                    style: textTheme.labelLarge,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    plan.bonus > 0
                        ? AppLocalizations.of(
                            context,
                          ).pointsChargeBonus(_amountFormat.format(plan.bonus))
                        : AppLocalizations.of(context).pointsChargeNoBonus,
                    style: textTheme.bodySmall?.copyWith(
                      color: plan.bonus > 0 ? context.palette.accentSoft : null,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '${_amountFormat.format(plan.totalPoints)}P',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
                color: context.palette.accentSoft,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChargeSummaryCard extends StatelessWidget {
  const _ChargeSummaryCard({required this.plan, required this.balance});

  final ChargePlan plan;
  final int balance;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SummaryRow(
              label: AppLocalizations.of(context).pointsChargeAmount,
              value: AppLocalizations.of(
                context,
              ).priceWon(_amountFormat.format(plan.amount)),
            ),
            const SizedBox(height: 8),
            _SummaryRow(
              label: AppLocalizations.of(context).pointsChargePoints,
              value: '${_amountFormat.format(plan.amount)}P',
            ),
            if (plan.bonus > 0) ...[
              const SizedBox(height: 8),
              _SummaryRow(
                label: AppLocalizations.of(context).pointsChargeBonusLabel,
                value: '+${_amountFormat.format(plan.bonus)}P',
                highlight: true,
              ),
            ],
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    AppLocalizations.of(context).pointsChargeExpected,
                    style: textTheme.labelLarge,
                  ),
                ),
                Text(
                  '${_amountFormat.format(balance + plan.totalPoints)}P',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                    color: context.palette.accentSoft,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Expanded(child: Text(label, style: textTheme.bodySmall)),
        Text(
          value,
          style: textTheme.bodySmall?.copyWith(
            color: highlight ? context.palette.accent : null,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
