import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/text_utils.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/presentation/account_providers.dart';
import '../../auth/presentation/auth_providers.dart';
import '../domain/wholesale_models.dart';
import 'wholesale_providers.dart';

final _priceFormat = NumberFormat('#,###');

class WholesaleQuoteScreen extends ConsumerStatefulWidget {
  const WholesaleQuoteScreen({super.key, this.initialBeanId});

  final String? initialBeanId;

  @override
  ConsumerState<WholesaleQuoteScreen> createState() =>
      _WholesaleQuoteScreenState();
}

class _WholesaleQuoteScreenState extends ConsumerState<WholesaleQuoteScreen> {
  final Map<String, int> _quantities = {};
  final _memoController = TextEditingController();
  var _initialApplied = false;
  var _submitting = false;

  @override
  void dispose() {
    _memoController.dispose();
    super.dispose();
  }

  void _applyInitialBean(List<WholesaleBean> beans) {
    if (_initialApplied) {
      return;
    }
    _initialApplied = true;
    final initialBeanId = widget.initialBeanId;
    if (initialBeanId == null) {
      return;
    }
    for (final bean in beans) {
      if (bean.id == initialBeanId) {
        _quantities[bean.id] = bean.minOrderKg;
      }
    }
  }

  void _increase(WholesaleBean bean) {
    setState(() {
      final current = _quantities[bean.id] ?? 0;
      _quantities[bean.id] = current == 0 ? bean.minOrderKg : current + 5;
    });
  }

  void _decrease(WholesaleBean bean) {
    setState(() {
      final current = _quantities[bean.id] ?? 0;
      final next = current - 5;
      if (next < bean.minOrderKg) {
        _quantities.remove(bean.id);
      } else {
        _quantities[bean.id] = next;
      }
    });
  }

  List<WholesaleQuoteItem> _buildItems(List<WholesaleBean> beans) {
    return [
      for (final bean in beans)
        if ((_quantities[bean.id] ?? 0) > 0)
          WholesaleQuoteItem(
            beanId: bean.id,
            beanName: bean.name,
            kg: _quantities[bean.id]!,
            pricePerKg: bean.unitPriceFor(_quantities[bean.id]!),
          ),
    ];
  }

  Future<void> _submit(List<WholesaleBean> beans) async {
    final items = _buildItems(beans);
    if (items.isEmpty || _submitting) {
      return;
    }
    final business = ref.read(accountProfileControllerProvider).value?.business;
    final user = ref.read(authStateProvider).value;
    final companyName =
        business?.companyName ??
        user?.displayLabel ??
        AppLocalizations.of(context).wholesaleMemberFallback;

    setState(() => _submitting = true);
    try {
      await ref
          .read(wholesaleQuotesControllerProvider.notifier)
          .submitQuote(
            companyName: companyName,
            items: items,
            memo: _memoController.text,
          );
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).wholesaleQuoteSubmitted),
        ),
      );
      context.pushReplacement('/wholesale/quotes');
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).wholesaleQuoteFailed('$error'),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final beansState = ref.watch(wholesaleBeansProvider);
    final business = ref
        .watch(accountProfileControllerProvider)
        .value
        ?.business;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).wholesaleQuoteTitle),
      ),
      body: beansState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(AppLocalizations.of(context).wholesaleBeansLoadFailed),
        ),
        data: (beans) {
          _applyInitialBean(beans);
          final items = _buildItems(beans);
          final totalKg = items.fold(0, (sum, item) => sum + item.kg);
          final totalAmount = items.fold(
            0,
            (sum, item) => sum + item.totalPrice,
          );

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: foxtrotListPadding,
                  children: [
                    if (business != null) ...[
                      _CompanyCard(
                        companyName: business.companyName,
                        businessNumber: business.businessNumber,
                      ),
                      const SizedBox(height: 16),
                    ],
                    Text(
                      AppLocalizations.of(context).wholesaleSectionBeans,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    for (final bean in beans)
                      _QuoteBeanTile(
                        bean: bean,
                        kg: _quantities[bean.id] ?? 0,
                        onIncrease: () => _increase(bean),
                        onDecrease: () => _decrease(bean),
                      ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context).wholesaleSectionNotes,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _memoController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(
                          context,
                        ).wholesaleNotesHint,
                      ),
                    ),
                  ],
                ),
              ),
              _QuoteBottomBar(
                totalKg: totalKg,
                totalAmount: totalAmount,
                enabled: items.isNotEmpty && !_submitting,
                onSubmit: () => _submit(beans),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CompanyCard extends StatelessWidget {
  const _CompanyCard({required this.companyName, required this.businessNumber});

  final String companyName;
  final String businessNumber;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              LucideIcons.building2,
              color: context.palette.accent,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(companyName, style: textTheme.labelLarge),
                  const SizedBox(height: 2),
                  Text(
                    AppLocalizations.of(
                      context,
                    ).wholesaleBusinessNumber(businessNumber),
                    style: textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuoteBeanTile extends StatelessWidget {
  const _QuoteBeanTile({
    required this.bean,
    required this.kg,
    required this.onIncrease,
    required this.onDecrease,
  });

  final WholesaleBean bean;
  final int kg;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final selected = kg > 0;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(bean.name.keepWord, style: textTheme.labelLarge),
                      const SizedBox(height: 2),
                      Text(
                        AppLocalizations.of(context).wholesalePricePerKg(
                          _priceFormat.format(bean.basePricePerKg),
                          bean.minOrderKg,
                        ),
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                _StepperButton(
                  icon: LucideIcons.minus,
                  tooltip: AppLocalizations.of(context).wholesaleDecreaseKg,
                  onPressed: selected ? onDecrease : null,
                ),
                SizedBox(
                  width: 52,
                  child: Text(
                    '${kg}kg',
                    textAlign: TextAlign.center,
                    style: textTheme.labelLarge?.copyWith(
                      color: selected
                          ? context.palette.accent
                          : context.palette.muted,
                    ),
                  ),
                ),
                _StepperButton(
                  icon: LucideIcons.plus,
                  onPressed: onIncrease,
                  tooltip: AppLocalizations.of(context).wholesaleIncreaseKg,
                ),
              ],
            ),
            if (selected) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: context.palette.surface,
                  borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
                  border: Border.all(color: context.palette.border),
                ),
                child: Text(
                  AppLocalizations.of(context).wholesaleAppliedPrice(
                    _priceFormat.format(bean.unitPriceFor(kg)),
                    _priceFormat.format(bean.totalPriceFor(kg)),
                  ),
                  style: textTheme.bodySmall?.copyWith(
                    color: context.palette.ink,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: context.palette.surface,
        shape: CircleBorder(side: BorderSide(color: context.palette.border)),
        minimumSize: const Size(36, 36),
      ),
      icon: Icon(icon, size: 16, color: context.palette.ink),
    );
  }
}

class _QuoteBottomBar extends StatelessWidget {
  const _QuoteBottomBar({
    required this.totalKg,
    required this.totalAmount,
    required this.enabled,
    required this.onSubmit,
  });

  final int totalKg;
  final int totalAmount;
  final bool enabled;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: context.palette.surface,
        border: Border(top: BorderSide(color: context.palette.border)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context).wholesaleTotalKg(totalKg),
                      style: textTheme.bodySmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AppLocalizations.of(
                        context,
                      ).wholesaleEstimate(_priceFormat.format(totalAmount)),
                      style: textTheme.titleMedium?.copyWith(
                        color: context.palette.accent,
                      ),
                    ),
                  ],
                ),
              ),
              FilledButton(
                onPressed: enabled ? onSubmit : null,
                child: Text(AppLocalizations.of(context).wholesaleSubmit),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
