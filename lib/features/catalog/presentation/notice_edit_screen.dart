import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../features/notice/presentation/notice_labels.dart';
import '../../../l10n/app_localizations.dart';
import '../../notice/domain/notice_models.dart';
import 'catalog_admin_providers.dart';

final _dateFormat = DateFormat('yyyy.MM.dd');

/// 공지 한 건을 등록하거나 고친다.
/// 알림 목록은 게시일 내림차순으로 읽으므로, 게시일이 곧 노출 순서다.
class NoticeEditScreen extends ConsumerStatefulWidget {
  const NoticeEditScreen({super.key, this.notice});

  /// 비어 있으면 새 공지를 만든다.
  final Notice? notice;

  @override
  ConsumerState<NoticeEditScreen> createState() => _NoticeEditScreenState();
}

class _NoticeEditScreenState extends ConsumerState<NoticeEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _body;
  late NoticeCategory _category;
  late DateTime _createdAt;
  late bool _isImportant;
  bool _busy = false;

  bool get _isNew => widget.notice == null;

  @override
  void initState() {
    super.initState();
    final notice = widget.notice;
    _title = TextEditingController(text: notice?.title ?? '');
    _body = TextEditingController(text: notice?.body ?? '');
    _category = notice?.category ?? NoticeCategory.notice;
    _createdAt = notice?.createdAt ?? DateTime.now();
    _isImportant = notice?.isImportant ?? false;
  }

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _createdAt,
      firstDate: DateTime(2020),
      lastDate: DateTime(_createdAt.year + 5),
    );
    if (picked == null) {
      return;
    }
    // 날짜만 바꾸고 시각은 유지해, 같은 날 올린 공지끼리의 순서를 지킨다.
    setState(() {
      _createdAt = DateTime(
        picked.year,
        picked.month,
        picked.day,
        _createdAt.hour,
        _createdAt.minute,
      );
    });
  }

  Future<void> _save() async {
    if (_busy || !(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    setState(() => _busy = true);
    final notice = Notice(
      id: widget.notice?.id ?? '',
      title: _title.text.trim(),
      body: _body.text.trim(),
      category: _category,
      createdAt: _createdAt,
      isImportant: _isImportant,
    );
    try {
      await ref.read(catalogAdminControllerProvider).saveNotice(notice);
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _busy = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('저장하지 못했습니다: $e')));
      }
    }
  }

  Future<void> _delete() async {
    final notice = widget.notice;
    if (notice == null || _busy) {
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('공지를 내릴까요?'),
        content: Text('${notice.title}을(를) 알림 목록에서 지웁니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('닫기'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('공지 내리기'),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      return;
    }
    setState(() => _busy = true);
    try {
      await ref.read(catalogAdminControllerProvider).deleteNotice(notice.id);
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _busy = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('내리지 못했습니다: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isNew ? '공지 등록' : '공지 수정'),
        actions: [
          if (!_isNew)
            IconButton(
              onPressed: _busy ? null : _delete,
              tooltip: '공지 내리기',
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
              controller: _title,
              decoration: const InputDecoration(labelText: '제목'),
              validator: (value) =>
                  (value ?? '').trim().isEmpty ? '제목을 입력해 주세요.' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _body,
              decoration: const InputDecoration(labelText: '본문'),
              maxLines: 6,
              validator: (value) =>
                  (value ?? '').trim().isEmpty ? '본문을 입력해 주세요.' : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<NoticeCategory>(
              initialValue: _category,
              decoration: const InputDecoration(labelText: '분류'),
              items: [
                for (final category in NoticeCategory.values)
                  DropdownMenuItem(
                    value: category,
                    child: Text(
                      AppLocalizations.of(context).noticeCategoryLabel(category),
                    ),
                  ),
              ],
              onChanged: (value) =>
                  setState(() => _category = value ?? _category),
            ),
            const SizedBox(height: 12),
            InputDecorator(
              decoration: const InputDecoration(
                labelText: '게시일',
                helperText: '최근 날짜일수록 목록 위에 보입니다.',
              ),
              child: Row(
                children: [
                  Expanded(child: Text(_dateFormat.format(_createdAt))),
                  TextButton(
                    onPressed: _busy ? null : _pickDate,
                    child: const Text('날짜 선택'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('중요 공지'),
              subtitle: const Text('목록에서 중요 뱃지를 붙입니다.'),
              value: _isImportant,
              onChanged: (value) => setState(() => _isImportant = value),
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
