import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/beans/presentation/bean_labels.dart';
import '../../../l10n/app_localizations.dart';
import '../../beans/domain/bean_models.dart';
import '../domain/comma_list.dart';
import 'catalog_admin_providers.dart';

/// 원두 한 건을 등록하거나 고친다.
/// 200g·500g 가격은 주문 시 서버가 이 값과 대조하므로 바꾸면 곧바로 결제 금액이 바뀐다.
class BeanEditScreen extends ConsumerStatefulWidget {
  const BeanEditScreen({super.key, this.bean});

  /// 비어 있으면 새 원두를 만든다.
  final Bean? bean;

  @override
  ConsumerState<BeanEditScreen> createState() => _BeanEditScreenState();
}

class _BeanEditScreenState extends ConsumerState<BeanEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final Map<String, TextEditingController> _fields;
  late RoastLevel _roastLevel;
  late int _acidity;
  late int _body;
  late int _sweetness;
  late bool _isNew;
  late bool _soldOut;
  bool _busy = false;

  bool get _isCreating => widget.bean == null;

  @override
  void initState() {
    super.initState();
    final bean = widget.bean;
    _fields = {
      'name': TextEditingController(text: bean?.name ?? ''),
      'origin': TextEditingController(text: bean?.origin ?? ''),
      'description': TextEditingController(text: bean?.description ?? ''),
      'story': TextEditingController(text: bean?.story ?? ''),
      'process': TextEditingController(text: bean?.process ?? ''),
      'tastingNotes': TextEditingController(
        text: formatCommaList(bean?.tastingNotes ?? const []),
      ),
      'recommendedBrews': TextEditingController(
        text: formatCommaList(bean?.recommendedBrews ?? const []),
      ),
      'price200': TextEditingController(text: bean?.price200.toString() ?? ''),
      'price500': TextEditingController(text: bean?.price500.toString() ?? ''),
      'sortOrder': TextEditingController(text: '${bean?.sortOrder ?? 0}'),
    };
    _roastLevel = bean?.roastLevel ?? RoastLevel.medium;
    _acidity = bean?.acidity ?? 3;
    _body = bean?.body ?? 3;
    _sweetness = bean?.sweetness ?? 3;
    _isNew = bean?.isNew ?? false;
    _soldOut = bean?.soldOut ?? false;
  }

  @override
  void dispose() {
    for (final controller in _fields.values) {
      controller.dispose();
    }
    super.dispose();
  }

  String _text(String key) => _fields[key]!.text.trim();

  Future<void> _save() async {
    if (_busy || !(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    setState(() => _busy = true);
    final bean = Bean(
      id: widget.bean?.id ?? '',
      name: _text('name'),
      origin: _text('origin'),
      description: _text('description'),
      story: _text('story'),
      roastLevel: _roastLevel,
      process: _text('process'),
      tastingNotes: parseCommaList(_text('tastingNotes')),
      acidity: _acidity,
      body: _body,
      sweetness: _sweetness,
      recommendedBrews: parseCommaList(_text('recommendedBrews')),
      price200: int.parse(_text('price200')),
      price500: int.parse(_text('price500')),
      isNew: _isNew,
      soldOut: _soldOut,
      sortOrder: int.tryParse(_text('sortOrder')) ?? 0,
    );
    try {
      await ref.read(catalogAdminControllerProvider).saveBean(bean);
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
    final bean = widget.bean;
    if (bean == null || _busy) {
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).beanRemoveTitle),
        content: Text(AppLocalizations.of(context).beanRemoveBody(bean.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context).commonClose),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(AppLocalizations.of(context).beanRemoveAction),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      return;
    }
    setState(() => _busy = true);
    try {
      await ref.read(catalogAdminControllerProvider).deleteBean(bean.id);
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

  Widget _textField(
    String key,
    String label, {
    int maxLines = 1,
    String? helperText,
    bool required = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: _fields[key],
        decoration: InputDecoration(labelText: label, helperText: helperText),
        maxLines: maxLines,
        validator: required
            ? (value) => (value ?? '').trim().isEmpty
                  ? AppLocalizations.of(context).beanFieldRequired(label)
                  : null
            : null,
      ),
    );
  }

  Widget _priceField(String key, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: _fields[key],
        decoration: InputDecoration(labelText: label),
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
    );
  }

  /// 산미·바디·단맛은 상세 화면에서 5칸 막대로 보여주므로 1~5로 받는다.
  Widget _profileSlider(String label, int value, ValueChanged<int> onChanged) {
    return Row(
      children: [
        SizedBox(width: 52, child: Text(label)),
        Expanded(
          child: Slider(
            value: value.toDouble(),
            min: 1,
            max: 5,
            divisions: 4,
            label: '$value',
            onChanged: (next) => onChanged(next.round()),
          ),
        ),
        SizedBox(width: 20, child: Text('$value')),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isCreating
              ? AppLocalizations.of(context).beanCreateTitle
              : AppLocalizations.of(context).beanEditTitle,
        ),
        actions: [
          if (!_isCreating)
            IconButton(
              onPressed: _busy ? null : _delete,
              tooltip: AppLocalizations.of(context).beanRemoveAction,
              icon: const Icon(Icons.delete_outline),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _textField(
              'name',
              AppLocalizations.of(context).adminFieldName,
              required: true,
            ),
            _textField(
              'origin',
              AppLocalizations.of(context).beanFieldOriginLabel,
              required: true,
            ),
            _textField(
              'description',
              AppLocalizations.of(context).adminFieldDescription,
              maxLines: 2,
            ),
            _textField(
              'story',
              AppLocalizations.of(context).beanFieldStory,
              maxLines: 3,
            ),
            DropdownButtonFormField<RoastLevel>(
              initialValue: _roastLevel,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).beanFieldRoastLevel,
              ),
              items: [
                for (final level in RoastLevel.values)
                  DropdownMenuItem(
                    value: level,
                    child: Text(
                      AppLocalizations.of(context).roastLevelLabel(level),
                    ),
                  ),
              ],
              onChanged: (value) =>
                  setState(() => _roastLevel = value ?? _roastLevel),
            ),
            const SizedBox(height: 12),
            _textField(
              'process',
              AppLocalizations.of(context).beanFieldProcessLabel,
              helperText: AppLocalizations.of(context).beanFieldProcessHelper,
            ),
            _textField(
              'tastingNotes',
              AppLocalizations.of(context).beanFieldNotes,
              helperText: AppLocalizations.of(context).beanFieldNotesHelper,
            ),
            _textField(
              'recommendedBrews',
              AppLocalizations.of(context).beanFieldBrewsLabel,
              helperText: AppLocalizations.of(context).beanFieldBrewsHelper,
            ),
            const SizedBox(height: 4),
            _profileSlider(
              AppLocalizations.of(context).beanProfileAcidity,
              _acidity,
              (v) => setState(() => _acidity = v),
            ),
            _profileSlider(
              AppLocalizations.of(context).beanProfileBody,
              _body,
              (v) => setState(() => _body = v),
            ),
            _profileSlider(
              AppLocalizations.of(context).beanProfileSweetness,
              _sweetness,
              (v) => setState(() => _sweetness = v),
            ),
            const SizedBox(height: 12),
            _priceField(
              'price200',
              AppLocalizations.of(context).beanFieldPrice200,
            ),
            _priceField(
              'price500',
              AppLocalizations.of(context).beanFieldPrice500,
            ),
            _textField(
              'sortOrder',
              AppLocalizations.of(context).adminSortOrder,
              helperText: AppLocalizations.of(context).adminSortOrderHelper,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(AppLocalizations.of(context).beanFieldNewBadge),
              value: _isNew,
              onChanged: (value) => setState(() => _isNew = value),
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
                      _isCreating
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
