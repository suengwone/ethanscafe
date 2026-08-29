import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/text_utils.dart';
import '../../../features/beans/presentation/bean_labels.dart';
import '../../../l10n/app_localizations.dart';
import '../../beans/domain/bean_models.dart';
import '../../beans/presentation/beans_providers.dart';
import 'gift_providers.dart';

final _priceFormat = NumberFormat('#,###');

class BeanGiftScreen extends ConsumerWidget {
  const BeanGiftScreen({super.key, required this.beanId});

  final String beanId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final beanState = ref.watch(beanProvider(beanId));

    return Scaffold(
      appBar: AppBar(title: const Text('원두 선물하기')),
      body: beanState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('원두 정보를 불러오지 못했습니다.'),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.invalidate(beanProvider(beanId)),
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
        data: (bean) => _BeanGiftForm(bean: bean),
      ),
    );
  }
}

class _BeanGiftForm extends ConsumerStatefulWidget {
  const _BeanGiftForm({required this.bean});

  final Bean bean;

  @override
  ConsumerState<_BeanGiftForm> createState() => _BeanGiftFormState();
}

class _BeanGiftFormState extends ConsumerState<_BeanGiftForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();

  BeanWeight _weight = BeanWeight.g200;
  GrindOption _grind = GrindOption.wholeBean;
  int _quantity = 1;
  bool _sending = false;

  int get _totalPrice => widget.bean.priceOf(_weight) * _quantity;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (_sending || !(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    setState(() => _sending = true);
    try {
      await ref.read(beanGiftsControllerProvider.notifier).sendGift(
            bean: widget.bean,
            weight: _weight,
            grind: _grind,
            quantity: _quantity,
            recipientName: _nameController.text,
            recipientPhone: _phoneController.text,
            message: _messageController.text,
          );
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${_nameController.text.trim()}님께 ${widget.bean.name} 선물을 보냈습니다.',
          ),
          action: SnackBarAction(
            label: '선물 내역',
            onPressed: () => context.push('/profile/gifts'),
          ),
        ),
      );
      context.pop();
    } finally {
      if (mounted) {
        setState(() => _sending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Expanded(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                foxtrotScreenHPadding,
                16,
                foxtrotScreenHPadding,
                24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _BeanSummaryCard(bean: widget.bean),
                  const SizedBox(height: 16),
                  _SectionCard(
                    title: '옵션 선택',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: BeanWeight.values
                              .map(
                                (weight) => Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      right: weight == BeanWeight.values.last
                                          ? 0
                                          : 8,
                                    ),
                                    child: _WeightOption(
                                      weight: weight,
                                      price: widget.bean.priceOf(weight),
                                      selected: _weight == weight,
                                      onTap: () =>
                                          setState(() => _weight = weight),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: GrindOption.values
                              .map(
                                (grind) => ChoiceChip(
                                  label: Text(AppLocalizations.of(context).grindLabel(grind)),
                                  selected: _grind == grind,
                                  onSelected: (_) =>
                                      setState(() => _grind = grind),
                                  selectedColor:
                                      context.palette.accent.withValues(alpha: 0.25),
                                  labelStyle: TextStyle(
                                    fontSize: 13,
                                    color: _grind == grind
                                        ? context.palette.accentSoft
                                        : context.palette.ink,
                                  ),
                                  side: BorderSide(
                                    color: _grind == grind
                                        ? context.palette.accent
                                        : context.palette.border,
                                  ),
                                  backgroundColor: context.palette.surface,
                                  showCheckmark: false,
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Text('수량', style: textTheme.titleSmall),
                            const Spacer(),
                            _QuantityButton(
                              icon: LucideIcons.minus,
                              enabled: _quantity > 1,
                              onTap: () => setState(() => _quantity--),
                            ),
                            SizedBox(
                              width: 44,
                              child: Text(
                                '$_quantity',
                                textAlign: TextAlign.center,
                                style: textTheme.titleMedium,
                              ),
                            ),
                            _QuantityButton(
                              icon: LucideIcons.plus,
                              enabled: _quantity < 9,
                              onTap: () => setState(() => _quantity++),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SectionCard(
                    title: '받는 분',
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: '이름',
                            hintText: '받는 분 이름',
                          ),
                          validator: (value) =>
                              (value == null || value.trim().isEmpty)
                                  ? '받는 분 이름을 입력해 주세요.'
                                  : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: '연락처',
                            hintText: '010-0000-0000',
                          ),
                          validator: (value) =>
                              (value == null || value.trim().isEmpty)
                                  ? '받는 분 연락처를 입력해 주세요.'
                                  : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _messageController,
                          maxLines: 3,
                          maxLength: 100,
                          decoration: const InputDecoration(
                            labelText: '선물 메시지 (선택)',
                            hintText: '마음을 전하는 메시지를 남겨보세요.',
                            alignLabelWithHint: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        _GiftBar(
          totalPrice: _totalPrice,
          sending: _sending,
          onSend: _send,
        ),
      ],
    );
  }
}

class _BeanSummaryCard extends StatelessWidget {
  const _BeanSummaryCard({required this.bean});

  final Bean bean;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: context.palette.surface,
                shape: BoxShape.circle,
                border: Border.all(color: context.palette.accent, width: 1.5),
              ),
              child: Icon(
                LucideIcons.gift,
                color: context.palette.accent,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(bean.name.keepWord, style: textTheme.labelLarge),
                  const SizedBox(height: 4),
                  Text(
                    AppLocalizations.of(context)
                        .beansRoastOf(
                          bean.origin,
                          AppLocalizations.of(context).roastLevelLabel(bean.roastLevel),
                        )
                        .keepWord,
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

class _GiftBar extends StatelessWidget {
  const _GiftBar({
    required this.totalPrice,
    required this.sending,
    required this.onSend,
  });

  final int totalPrice;
  final bool sending;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.palette.surface,
        border: Border(top: BorderSide(color: context.palette.border)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '선물 금액',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      '${_priceFormat.format(totalPrice)}원',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: context.palette.accentSoft,
                      ),
                    ),
                  ],
                ),
              ),
              FilledButton.icon(
                onPressed: sending ? null : onSend,
                icon: const Icon(LucideIcons.gift, size: 18),
                label: Text(sending ? '보내는 중...' : '선물 보내기'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _WeightOption extends StatelessWidget {
  const _WeightOption({
    required this.weight,
    required this.price,
    required this.selected,
    required this.onTap,
  });

  final BeanWeight weight;
  final int price;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? context.palette.accent.withValues(alpha: 0.15)
              : context.palette.surface,
          borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
          border: Border.all(
            color: selected ? context.palette.accent : context.palette.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              weight.label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: selected ? context.palette.accentSoft : context.palette.ink,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${_priceFormat.format(price)}원',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
      onTap: enabled ? onTap : null,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: context.palette.surface,
          borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
          border: Border.all(color: context.palette.border),
        ),
        child: Icon(
          icon,
          size: 18,
          color: enabled ? context.palette.accent : context.palette.muted,
        ),
      ),
    );
  }
}
