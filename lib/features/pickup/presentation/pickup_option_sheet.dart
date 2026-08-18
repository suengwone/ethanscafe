import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/text_utils.dart';
import '../../menu/domain/menu_models.dart';
import 'pickup_cart_providers.dart';

final _priceFormat = NumberFormat('#,###');

class PickupOptionSelection {
  const PickupOptionSelection({this.option, required this.quantity});

  final String? option;
  final int quantity;
}

Future<PickupOptionSelection?> showPickupOptionSheet(
  BuildContext context,
  MenuItem item,
) {
  return showModalBottomSheet<PickupOptionSelection>(
    context: context,
    isScrollControlled: true,
    backgroundColor: foxtrotCard,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => PickupOptionSheet(item: item),
  );
}

class PickupOptionSheet extends StatefulWidget {
  const PickupOptionSheet({super.key, required this.item});

  final MenuItem item;

  @override
  State<PickupOptionSheet> createState() => _PickupOptionSheetState();
}

class _PickupOptionSheetState extends State<PickupOptionSheet> {
  String? _option;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _option = widget.item.servingOptions.isEmpty
        ? null
        : widget.item.servingOptions.first;
  }

  int get _totalPrice => widget.item.price * _quantity;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final item = widget.item;

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
            Text(item.name.keepWord, style: textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(item.description.keepWord, style: textTheme.bodySmall),
            if (item.servingOptions.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text('옵션', style: textTheme.titleSmall),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: item.servingOptions
                    .map(
                      (option) => ChoiceChip(
                        label: Text(option),
                        selected: _option == option,
                        onSelected: (_) => setState(() => _option = option),
                        selectedColor: foxtrotGold.withValues(alpha: 0.25),
                        labelStyle: TextStyle(
                          fontSize: 13,
                          color: _option == option
                              ? foxtrotGoldLight
                              : foxtrotCream,
                        ),
                        side: BorderSide(
                          color:
                              _option == option ? foxtrotGold : foxtrotBorder,
                        ),
                        backgroundColor: foxtrotSurface,
                        showCheckmark: false,
                      ),
                    )
                    .toList(),
              ),
            ],
            const SizedBox(height: 20),
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
                  enabled: _quantity < pickupCartMaxQuantity,
                  onTap: () => setState(() => _quantity++),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 12),
            Row(
              children: [
                Text('총 주문 금액', style: textTheme.bodyMedium),
                const Spacer(),
                Text(
                  '${_priceFormat.format(_totalPrice)}원',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: foxtrotGoldLight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => Navigator.of(context).pop(
                  PickupOptionSelection(option: _option, quantity: _quantity),
                ),
                icon: const Icon(LucideIcons.shoppingBag, size: 18),
                label: const Text('장바구니 담기'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
              ),
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
