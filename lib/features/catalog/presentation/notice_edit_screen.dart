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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).adminSaveFailed('$e')),
          ),
        );
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
        title: Text(AppLocalizations.of(context).noticeRemoveTitle),
        content: Text(
          AppLocalizations.of(context).noticeRemoveBody(notice.title),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context).commonClose),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(AppLocalizations.of(context).noticeRemoveAction),
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
              ? AppLocalizations.of(context).noticeCreateTitle
              : AppLocalizations.of(context).noticeEditTitle,
        ),
        actions: [
          if (!_isNew)
            IconButton(
              onPressed: _busy ? null : _delete,
              tooltip: AppLocalizations.of(context).noticeRemoveAction,
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
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).adminFieldTitle,
              ),
              validator: (value) => (value ?? '').trim().isEmpty
                  ? AppLocalizations.of(context).adminFieldTitleRequired
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _body,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).noticeFieldBody,
              ),
              maxLines: 6,
              validator: (value) => (value ?? '').trim().isEmpty
                  ? AppLocalizations.of(context).noticeFieldBodyRequired
                  : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<NoticeCategory>(
              initialValue: _category,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).noticeFieldCategory,
              ),
              items: [
                for (final category in NoticeCategory.values)
                  DropdownMenuItem(
                    value: category,
                    child: Text(
                      AppLocalizations.of(
                        context,
                      ).noticeCategoryLabel(category),
                    ),
                  ),
              ],
              onChanged: (value) =>
                  setState(() => _category = value ?? _category),
            ),
            const SizedBox(height: 12),
            InputDecorator(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).noticeFieldDate,
                helperText: AppLocalizations.of(context).noticeFieldDateHelper,
              ),
              child: Row(
                children: [
                  Expanded(child: Text(_dateFormat.format(_createdAt))),
                  TextButton(
                    onPressed: _busy ? null : _pickDate,
                    child: Text(AppLocalizations.of(context).noticeChooseDate),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(AppLocalizations.of(context).noticeFieldImportant),
              subtitle: Text(
                AppLocalizations.of(context).noticeFieldImportantHelper,
              ),
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
