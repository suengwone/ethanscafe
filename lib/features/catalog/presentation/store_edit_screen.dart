import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
          SnackBar(content: Text('저장하지 못했습니다: $e')),
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
        title: const Text('매장을 내릴까요?'),
        content: Text('${store.name}을(를) 매장 찾기에서 지웁니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('닫기'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('매장 내리기'),
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
          SnackBar(content: Text('내리지 못했습니다: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isNew ? '매장 등록' : '매장 수정'),
        actions: [
          if (!_isNew)
            IconButton(
              onPressed: _busy ? null : _delete,
              tooltip: '매장 내리기',
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
              decoration: const InputDecoration(labelText: '매장 이름'),
              validator: (value) =>
                  (value ?? '').trim().isEmpty ? '매장 이름을 입력해 주세요.' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _address,
              decoration: const InputDecoration(labelText: '주소'),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phone,
              decoration: const InputDecoration(labelText: '전화번호'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            _CoordinateField(
              controller: _latitude,
              label: '위도',
              helperText: '-90 ~ 90',
              limit: 90,
            ),
            const SizedBox(height: 12),
            _CoordinateField(
              controller: _longitude,
              label: '경도',
              helperText: '-180 ~ 180',
              limit: 180,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _weekdayHours,
              decoration: const InputDecoration(
                labelText: '평일 영업시간',
                hintText: '09:00 - 21:00',
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _weekendHours,
              decoration: const InputDecoration(
                labelText: '주말 영업시간',
                hintText: '10:00 - 19:00',
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _services,
              decoration: const InputDecoration(
                labelText: '편의시설',
                helperText: '쉼표로 구분 (예: 무료주차 2시간, 테라스)',
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notice,
              decoration: const InputDecoration(
                labelText: '매장 공지',
                helperText: '매장 상세 맨 위에 걸립니다. 비우면 안 보입니다.',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            const Text('현재 혼잡도'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: StoreCongestion.values
                  .map(
                    (congestion) => ChoiceChip(
                      label: Text(congestion.label),
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
              '고른 지 ${CafeStore.congestionFreshness.inHours}시간이 지나면 고객 화면에서 자동으로 숨깁니다.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _sortOrder,
              decoration: const InputDecoration(
                labelText: '노출 순서',
                helperText: '작을수록 먼저 보입니다.',
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
                  : Text(_isNew ? '등록' : '저장'),
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
          return '$label를 $helperText 사이 숫자로 입력해 주세요.';
        }
        return null;
      },
    );
  }
}
