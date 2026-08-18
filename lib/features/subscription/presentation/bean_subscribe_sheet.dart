import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/text_utils.dart';
import '../../auth/presentation/login_required.dart';
import '../../beans/domain/bean_models.dart';
import '../domain/subscription_models.dart';
import 'subscription_providers.dart';

final _priceFormat = NumberFormat('#,###');

Future<void> showBeanSubscribeSheet(
  BuildContext context,
  WidgetRef ref, {
  required Bean bean,
}) async {
  if (!requireLogin(context, ref, message: '원두 구독은 로그인 후 이용할 수 있어요.')) {
    return;
  }

  final selection = await showModalBottomSheet<BeanSubscribeSelection>(
    context: context,
    isScrollControlled: true,
    backgroundColor: foxtrotCard,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => BeanSubscribeSheet(bean: bean),
  );
  if (selection == null || !context.mounted) {
    return;
  }

  await ref.read(beanSubscriptionsControllerProvider.notifier).subscribe(
        bean: bean,
        weight: selection.weight,
        grind: selection.grind,
        quantity: selection.quantity,
        cycle: selection.cycle,
      );
  if (!context.mounted) {
    return;
  }
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        '${bean.name} ${selection.cycle.label} 정기구독이 시작되었습니다.',
      ),
      action: SnackBarAction(
        label: '구독 관리',
        onPressed: () => context.push('/profile/subscriptions'),
      ),
    ),
  );
}

class BeanSubscribeSelection {
  const BeanSubscribeSelection({
    required this.weight,
    required this.grind,
    required this.quantity,
    required this.cycle,
  });

  final BeanWeight weight;
  final GrindOption grind;
  final int quantity;
  final SubscriptionCycle cycle;
}

class BeanSubscribeSheet extends StatefulWidget {
  const BeanSubscribeSheet({super.key, required this.bean});

  final Bean bean;

  @override
  State<BeanSubscribeSheet> createState() => _BeanSubscribeSheetState();
}

class _BeanSubscribeSheetState extends State<BeanSubscribeSheet> {
  BeanWeight _weight = BeanWeight.g200;
  GrindOption _grind = GrindOption.wholeBean;
  SubscriptionCycle _cycle = SubscriptionCycle.monthly;
  int _quantity = 1;

  int get _pricePerDelivery => widget.bean.priceOf(_weight) * _quantity;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(LucideIcons.repeat, size: 18, color: foxtrotGold),
                const SizedBox(width: 8),
                Text('원두 정기구독', style: textTheme.titleLarge),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${widget.bean.name} · ${widget.bean.roastLevel.label} 로스팅'
                  .keepWord,
              style: textTheme.bodySmall,
            ),
            const SizedBox(height: 20),
            Text('배송 주기', style: textTheme.titleSmall),
            const SizedBox(height: 8),
            Row(
              children: SubscriptionCycle.values
                  .map(
                    (cycle) => Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right:
                              cycle == SubscriptionCycle.values.last ? 0 : 8,
                        ),
                        child: _CycleOption(
                          cycle: cycle,
                          selected: _cycle == cycle,
                          onTap: () => setState(() => _cycle = cycle),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 20),
            Text('용량', style: textTheme.titleSmall),
            const SizedBox(height: 8),
            Row(
              children: BeanWeight.values
                  .map(
                    (weight) => Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: weight == BeanWeight.values.last ? 0 : 8,
                        ),
                        child: _WeightOption(
                          weight: weight,
                          price: widget.bean.priceOf(weight),
                          selected: _weight == weight,
                          onTap: () => setState(() => _weight = weight),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 20),
            Text('분쇄도', style: textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: GrindOption.values
                  .map(
                    (grind) => ChoiceChip(
                      label: Text(grind.label),
                      selected: _grind == grind,
                      onSelected: (_) => setState(() => _grind = grind),
                      selectedColor: foxtrotGold.withValues(alpha: 0.25),
                      labelStyle: TextStyle(
                        fontSize: 13,
                        color: _grind == grind
                            ? foxtrotGoldLight
                            : foxtrotCream,
                      ),
                      side: BorderSide(
                        color: _grind == grind ? foxtrotGold : foxtrotBorder,
                      ),
                      backgroundColor: foxtrotSurface,
                      showCheckmark: false,
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text('회당 수량', style: textTheme.titleSmall),
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
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 12),
            Row(
              children: [
                Text('회당 결제 금액', style: textTheme.bodyMedium),
                const Spacer(),
                Text(
                  '${_priceFormat.format(_pricePerDelivery)}원',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: foxtrotGoldLight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '${_cycle.label} 로스팅한 원두를 배송해 드려요. 언제든 일시정지·해지할 수 있어요.'.keepWord,
              style: textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => Navigator.of(context).pop(
                  BeanSubscribeSelection(
                    weight: _weight,
                    grind: _grind,
                    quantity: _quantity,
                    cycle: _cycle,
                  ),
                ),
                icon: const Icon(LucideIcons.repeat, size: 18),
                label: Text('${_cycle.label} 구독 시작하기'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CycleOption extends StatelessWidget {
  const _CycleOption({
    required this.cycle,
    required this.selected,
    required this.onTap,
  });

  final SubscriptionCycle cycle;
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
              ? foxtrotGold.withValues(alpha: 0.15)
              : foxtrotSurface,
          borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
          border: Border.all(
            color: selected ? foxtrotGold : foxtrotBorder,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              cycle.label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: selected ? foxtrotGoldLight : foxtrotCream,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${cycle.days}일마다',
              style: Theme.of(context).textTheme.bodySmall,
            ),
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
              ? foxtrotGold.withValues(alpha: 0.15)
              : foxtrotSurface,
          borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
          border: Border.all(
            color: selected ? foxtrotGold : foxtrotBorder,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              weight.label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: selected ? foxtrotGoldLight : foxtrotCream,
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
          color: foxtrotSurface,
          borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
          border: Border.all(color: foxtrotBorder),
        ),
        child: Icon(
          icon,
          size: 18,
          color: enabled ? foxtrotGold : foxtrotMuted,
        ),
      ),
    );
  }
}
