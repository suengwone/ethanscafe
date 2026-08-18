import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
          SnackBar(content: Text('저장하지 못했습니다: $e')),
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
        title: const Text('원두를 내릴까요?'),
        content: Text('${bean.name}을(를) 카탈로그에서 지웁니다. 지난 주문 내역은 그대로 남습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('닫기'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('원두 내리기'),
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
          SnackBar(content: Text('내리지 못했습니다: $e')),
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
            ? (value) => (value ?? '').trim().isEmpty ? '$label을(를) 입력해 주세요.' : null
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
            return '가격을 숫자로 입력해 주세요.';
          }
          return null;
        },
      ),
    );
  }

  /// 산미·바디·단맛은 상세 화면에서 5칸 막대로 보여주므로 1~5로 받는다.
  Widget _profileSlider(
    String label,
    int value,
    ValueChanged<int> onChanged,
  ) {
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
        title: Text(_isCreating ? '원두 등록' : '원두 수정'),
        actions: [
          if (!_isCreating)
            IconButton(
              onPressed: _busy ? null : _delete,
              tooltip: '원두 내리기',
              icon: const Icon(Icons.delete_outline),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _textField('name', '이름', required: true),
            _textField('origin', '산지', required: true),
            _textField('description', '설명', maxLines: 2),
            _textField('story', '스토리', maxLines: 3),
            DropdownButtonFormField<RoastLevel>(
              initialValue: _roastLevel,
              decoration: const InputDecoration(labelText: '로스팅 정도'),
              items: [
                for (final level in RoastLevel.values)
                  DropdownMenuItem(value: level, child: Text(level.label)),
              ],
              onChanged: (value) => setState(
                () => _roastLevel = value ?? _roastLevel,
              ),
            ),
            const SizedBox(height: 12),
            _textField('process', '가공 방식', helperText: '워시드, 내추럴, 디카페인 등'),
            _textField(
              'tastingNotes',
              '테이스팅 노트',
              helperText: '쉼표로 구분 (예: 자몽, 자스민, 흑설탕)',
            ),
            _textField(
              'recommendedBrews',
              '추천 추출법',
              helperText: '쉼표로 구분 (예: 핸드드립, 에스프레소)',
            ),
            const SizedBox(height: 4),
            _profileSlider('산미', _acidity, (v) => setState(() => _acidity = v)),
            _profileSlider('바디', _body, (v) => setState(() => _body = v)),
            _profileSlider('단맛', _sweetness, (v) => setState(() => _sweetness = v)),
            const SizedBox(height: 12),
            _priceField('price200', '200g 가격 (원)'),
            _priceField('price500', '500g 가격 (원)'),
            _textField('sortOrder', '노출 순서', helperText: '작을수록 먼저 보입니다.'),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('NEW 뱃지'),
              value: _isNew,
              onChanged: (value) => setState(() => _isNew = value),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('품절'),
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
                  : Text(_isCreating ? '등록' : '저장'),
            ),
          ],
        ),
      ),
    );
  }
}
