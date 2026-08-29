import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/store/presentation/store_labels.dart';
import '../../../l10n/app_localizations.dart';
import '../../store/domain/store_models.dart';
import '../../store/presentation/stores_providers.dart';
import '../domain/comma_list.dart';
import 'catalog_admin_providers.dart';

/// 매장 한 곳을 등록하거나 고친다.
/// 좌표는 매장 찾기의 거리 정렬에 그대로 쓰이므로 잘못 넣으면 순서가 뒤집힌다.
class StoreEditScreen extends ConsumerStatefulWidget {
  const StoreEditScreen({super.key, this.store});

  /// 비어 있으면 새 매장을 만든다.
  final CafeStore? store;

  @override
  ConsumerState<StoreEditScreen> createState() => _StoreEditScreenState();
}

class _StoreEditScreenState extends ConsumerState<StoreEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _address;
  late final TextEditingController _phone;
  late final TextEditingController _latitude;
  late final TextEditingController _longitude;
  late final TextEditingController _weekdayHours;
  late final TextEditingController _weekendHours;
  late final TextEditingController _services;
  late final TextEditingController _sortOrder;
  late final TextEditingController _notice;
  late StoreCongestion _congestion;

  /// 같은 혼잡도를 다시 골라도 시각을 새로 찍어 준다.
  bool _congestionTouched = false;
  bool _busy = false;

  bool get _isNew => widget.store == null;

  @override
  void initState() {
    super.initState();
    final store = widget.store;
    _name = TextEditingController(text: store?.name ?? '');
    _address = TextEditingController(text: store?.address ?? '');
    _phone = TextEditingController(text: store?.phone ?? '');
    _latitude = TextEditingController(text: store?.latitude.toString() ?? '');
    _longitude = TextEditingController(text: store?.longitude.toString() ?? '');
    _weekdayHours = TextEditingController(text: store?.weekdayHours ?? '');
    _weekendHours = TextEditingController(text: store?.weekendHours ?? '');
    _services = TextEditingController(
      text: formatCommaList(store?.services ?? const []),
    );
    _sortOrder = TextEditingController(
      text: (store?.sortOrder ?? 0).toString(),
    );
    _notice = TextEditingController(text: store?.notice ?? '');
    _congestion = store?.congestion ?? StoreCongestion.unknown;
  }

  @override
  void dispose() {
    _name.dispose();
    _address.dispose();
    _phone.dispose();
    _latitude.dispose();
    _longitude.dispose();
    _weekdayHours.dispose();
    _weekendHours.dispose();
    _services.dispose();
    _sortOrder.dispose();
    _notice.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_busy || !(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    setState(() => _busy = true);
    final store = CafeStore(
      id: widget.store?.id ?? '',
      name: _name.text.trim(),
      address: _address.text.trim(),
      phone: _phone.text.trim(),
      latitude: double.parse(_latitude.text.trim()),
      longitude: double.parse(_longitude.text.trim()),
      weekdayHours: _weekdayHours.text.trim(),
      weekendHours: _weekendHours.text.trim(),
      services: parseCommaList(_services.text),
      sortOrder: int.tryParse(_sortOrder.text.trim()) ?? 0,
      notice: _notice.text.trim(),
      congestion: _congestion,
      congestionUpdatedAt: _congestionUpdatedAt,
    );
    try {
      await ref.read(catalogAdminControllerProvider).saveStore(store);
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

  /// 혼잡도는 올린 시각이 함께 있어야 오래된 값을 걸러 낼 수 있다.
  DateTime? get _congestionUpdatedAt {
    if (_congestion == StoreCongestion.unknown) {
      return null;
    }
    if (_congestionTouched) {
      return ref.read(storeClockProvider)();
    }
    return widget.store?.congestionUpdatedAt;
  }

  Future<void> _delete() async {
    final store = widget.store;
    if (store == null || _busy) {
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).storeRemoveTitle),
        content: Text(AppLocalizations.of(context).storeRemoveBody(store.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context).commonClose),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(AppLocalizations.of(context).storeRemoveAction),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      return;
    }
    setState(() => _busy = true);
    try {
      await ref.read(catalogAdminControllerProvider).deleteStore(store.id);
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
              ? AppLocalizations.of(context).storeCreateTitle
              : AppLocalizations.of(context).storeEditTitle,
        ),
        actions: [
          if (!_isNew)
            IconButton(
              onPressed: _busy ? null : _delete,
              tooltip: AppLocalizations.of(context).storeRemoveAction,
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
                labelText: AppLocalizations.of(context).storeFieldName,
              ),
              validator: (value) => (value ?? '').trim().isEmpty
                  ? AppLocalizations.of(context).storeFieldNameRequired
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _address,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).storeFieldAddress,
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phone,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).storeFieldPhone,
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            _CoordinateField(
              controller: _latitude,
              label: AppLocalizations.of(context).storeFieldLatitude,
              helperText: '-90 ~ 90',
              limit: 90,
            ),
            const SizedBox(height: 12),
            _CoordinateField(
              controller: _longitude,
              label: AppLocalizations.of(context).storeFieldLongitude,
              helperText: '-180 ~ 180',
              limit: 180,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _weekdayHours,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).storeFieldWeekdayHours,
                hintText: '09:00 - 21:00',
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _weekendHours,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).storeFieldWeekendHours,
                hintText: '10:00 - 19:00',
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _services,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).storeFieldFacilities,
                helperText: AppLocalizations.of(
                  context,
                ).storeFieldFacilitiesHelper,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notice,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).storeFieldNotice,
                helperText: AppLocalizations.of(context).storeFieldNoticeHelper,
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            Text(AppLocalizations.of(context).storeFieldCongestion),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: StoreCongestion.values
                  .map(
                    (congestion) => ChoiceChip(
                      label: Text(
                        AppLocalizations.of(
                          context,
                        ).congestionLabel(congestion),
                      ),
                      selected: _congestion == congestion,
                      // 같은 값을 다시 눌러도 시각만 새로 찍는다.
                      onSelected: (_) => setState(() {
                        _congestion = congestion;
                        _congestionTouched = true;
                      }),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 4),
            Text(
              AppLocalizations.of(
                context,
              ).storeCongestionHelper(CafeStore.congestionFreshness.inHours),
              style: Theme.of(context).textTheme.bodySmall,
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

class _CoordinateField extends StatelessWidget {
  const _CoordinateField({
    required this.controller,
    required this.label,
    required this.helperText,
    required this.limit,
  });

  final TextEditingController controller;
  final String label;
  final String helperText;
  final double limit;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label, helperText: helperText),
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
        signed: true,
      ),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.-]'))],
      validator: (value) {
        final coordinate = double.tryParse((value ?? '').trim());
        if (coordinate == null || coordinate.abs() > limit) {
          return AppLocalizations.of(
            context,
          ).storeNumberInvalid(label, helperText);
        }
        return null;
      },
    );
  }
}
