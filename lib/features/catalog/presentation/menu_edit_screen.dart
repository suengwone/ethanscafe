import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/menu/presentation/menu_labels.dart';
import '../../../l10n/app_localizations.dart';
import '../../menu/domain/menu_models.dart';
import 'catalog_admin_providers.dart';

/// 메뉴 한 건을 등록하거나 고친다.
/// 가격은 주문 시 서버가 이 값과 대조하므로 여기서 바꾸면 곧바로 결제 금액이 바뀐다.
class MenuEditScreen extends ConsumerStatefulWidget {
  const MenuEditScreen({super.key, this.item});

  /// 비어 있으면 새 메뉴를 만든다.
  final MenuItem? item;

  @override
  ConsumerState<MenuEditScreen> createState() => _MenuEditScreenState();
}

class _MenuEditScreenState extends ConsumerState<MenuEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _description;
  late final TextEditingController _price;
  late final TextEditingController _detail;
  late final TextEditingController _sortOrder;
  late MenuCategory _category;
  late MenuBadge _badge;
  late bool _priceFrom;
  late bool _isRecommended;
  late bool _soldOut;
  bool _busy = false;

  bool get _isNew => widget.item == null;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _name = TextEditingController(text: item?.name ?? '');
    _description = TextEditingController(text: item?.description ?? '');
    _price = TextEditingController(text: item?.price.toString() ?? '');
    _detail = TextEditingController(text: item?.detail ?? '');
    _sortOrder = TextEditingController(text: (item?.sortOrder ?? 0).toString());
    _category = item?.category ?? MenuCategory.beverage;
    _badge = item?.badge ?? MenuBadge.none;
    _priceFrom = item?.priceFrom ?? false;
    _isRecommended = item?.isRecommended ?? false;
    _soldOut = item?.soldOut ?? false;
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _price.dispose();
    _detail.dispose();
    _sortOrder.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_busy || !(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    setState(() => _busy = true);
    final detail = _detail.text.trim();
    final item = MenuItem(
      id: widget.item?.id ?? '',
      name: _name.text.trim(),
      description: _description.text.trim(),
      category: _category,
      price: int.parse(_price.text.trim()),
      priceFrom: _priceFrom,
      badge: _badge,
      servingOptions: widget.item?.servingOptions ?? const [],
      detail: detail.isEmpty ? null : detail,
      isRecommended: _isRecommended,
      soldOut: _soldOut,
      sortOrder: int.tryParse(_sortOrder.text.trim()) ?? 0,
    );
    try {
      await ref.read(catalogAdminControllerProvider).saveMenuItem(item);
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _busy = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).adminSaveFailed('$e')),
          ),
        );
      }
    }
  }

  Future<void> _delete() async {
    final item = widget.item;
    if (item == null || _busy) {
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).menuRemoveTitle),
        content: Text(AppLocalizations.of(context).menuRemoveBody(item.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context).commonClose),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(AppLocalizations.of(context).menuRemoveAction),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      return;
    }
    setState(() => _busy = true);
    try {
      await ref.read(catalogAdminControllerProvider).deleteMenuItem(item.id);
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _busy = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).adminRemoveFailed('$e')),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isNew
              ? AppLocalizations.of(context).menuCreateTitle
              : AppLocalizations.of(context).menuEditTitle,
        ),
        actions: [
          if (!_isNew)
            IconButton(
              onPressed: _busy ? null : _delete,
              tooltip: AppLocalizations.of(context).menuRemoveAction,
              icon: const Icon(Icons.delete_outline),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _name,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).adminFieldName,
              ),
              validator: (value) => (value ?? '').trim().isEmpty
                  ? AppLocalizations.of(context).adminFieldNameRequired
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _description,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).adminFieldDescription,
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<MenuCategory>(
              initialValue: _category,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).menuFieldCategoryLabel,
              ),
              items: [
                for (final category in MenuCategory.values)
                  DropdownMenuItem(
                    value: category,
                    child: Text(
                      AppLocalizations.of(context).menuCategoryLabel(category),
                    ),
                  ),
              ],
              onChanged: (value) =>
                  setState(() => _category = value ?? _category),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _price,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).menuFieldPrice,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                final price = int.tryParse((value ?? '').trim());
                if (price == null || price < 0) {
                  return AppLocalizations.of(context).adminPriceInvalid;
                }
                return null;
              },
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(AppLocalizations.of(context).menuFieldPriceFrom),
              subtitle: Text(
                AppLocalizations.of(context).menuFieldPriceFromHelper,
              ),
              value: _priceFrom,
              onChanged: (value) => setState(() => _priceFrom = value),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<MenuBadge>(
              initialValue: _badge,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).menuFieldBadge,
              ),
              items: [
                DropdownMenuItem(
                  value: MenuBadge.none,
                  child: Text(AppLocalizations.of(context).menuBadgeNone),
                ),
                const DropdownMenuItem(
                  value: MenuBadge.isNew,
                  child: Text('NEW'),
                ),
                const DropdownMenuItem(
                  value: MenuBadge.hit,
                  child: Text('HIT'),
                ),
              ],
              onChanged: (value) => setState(() => _badge = value ?? _badge),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _detail,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).menuFieldDetail,
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _sortOrder,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).adminSortOrder,
                helperText: AppLocalizations.of(context).adminSortOrderHelper,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(AppLocalizations.of(context).menuFieldRecommended),
              value: _isRecommended,
              onChanged: (value) => setState(() => _isRecommended = value),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(AppLocalizations.of(context).menuFieldSoldOut),
              value: _soldOut,
              onChanged: (value) => setState(() => _soldOut = value),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _busy ? null : _save,
              child: _busy
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      _isNew
                          ? AppLocalizations.of(context).adminCreate
                          : AppLocalizations.of(context).adminSave,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
