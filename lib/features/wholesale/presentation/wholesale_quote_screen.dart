import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/text_utils.dart';
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
    final business =
        ref.read(accountProfileControllerProvider).value?.business;
    final user = ref.read(authStateProvider).value;
    final companyName =
        business?.companyName ?? user?.displayLabel ?? '사업자 회원';

    setState(() => _submitting = true);
    try {
      await ref.read(wholesaleQuotesControllerProvider.notifier).submitQuote(
            companyName: companyName,
            items: items,
            memo: _memoController.text,
          );
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('견적 요청이 접수되었습니다. 담당자가 곧 연락드릴게요.')),
      );
      context.pushReplacement('/wholesale/quotes');
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('견적 요청에 실패했습니다: $error')),
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
    final business =
        ref.watch(accountProfileControllerProvider).value?.business;

    return Scaffold(
      appBar: AppBar(title: const Text('도매 견적 요청')),
      body: beansState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            const Center(child: Text('도매 원두를 불러오지 못했습니다.')),
        data: (beans) {
          _applyInitialBean(beans);
          final items = _buildItems(beans);
          final totalKg = items.fold(0, (sum, item) => sum + item.kg);
          final totalAmount =
              items.fold(0, (sum, item) => sum + item.totalPrice);

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
                      '원두 선택',
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
                      '요청 사항',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _memoController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: '납품 주기, 희망 일정, 분쇄도 등 요청 사항을 적어주세요',
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
  const _CompanyCard({
    required this.companyName,
    required this.businessNumber,
  });

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
            Icon(LucideIcons.building2, color: context.palette.accent, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(companyName, style: textTheme.labelLarge),
                  const SizedBox(height: 2),
                  Text(
                    '사업자등록번호 $businessNumber',
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
                        'kg당 ${_priceFormat.format(bean.basePricePerKg)}원~ · 최소 ${bean.minOrderKg}kg',
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                _StepperButton(
                  icon: LucideIcons.minus,
                  onPressed: selected ? onDecrease : null,
                ),
                SizedBox(
                  width: 52,
                  child: Text(
                    '${kg}kg',
                    textAlign: TextAlign.center,
                    style: textTheme.labelLarge?.copyWith(
                      color: selected ? context.palette.accent : context.palette.muted,
                    ),
                  ),
                ),
                _StepperButton(
                  icon: LucideIcons.plus,
                  onPressed: onIncrease,
                ),
              ],
            ),
            if (selected) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: context.palette.surface,
                  borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
                  border: Border.all(color: context.palette.border),
                ),
                child: Text(
                  '적용 단가 kg당 ${_priceFormat.format(bean.unitPriceFor(kg))}원 · '
                  '합계 ${_priceFormat.format(bean.totalPriceFor(kg))}원',
                  style: textTheme.bodySmall?.copyWith(color: context.palette.ink),
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
  const _StepperButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
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
                    Text('총 ${totalKg}kg', style: textTheme.bodySmall),
                    const SizedBox(height: 2),
                    Text(
                      '예상 ${_priceFormat.format(totalAmount)}원',
                      style:
                          textTheme.titleMedium?.copyWith(color: context.palette.accent),
                    ),
                  ],
                ),
              ),
              FilledButton(
                onPressed: enabled ? onSubmit : null,
                child: const Text('견적 요청하기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
