import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../home/domain/banner_models.dart';
import '../../home/presentation/banner_icons.dart';
import 'catalog_admin_providers.dart';

/// 홈 이벤트 배너 한 건을 등록하거나 고친다.
/// 저장하면 곧바로 고객 홈 캐러셀에 반영된다.
class BannerEditScreen extends ConsumerStatefulWidget {
  const BannerEditScreen({super.key, this.banner});

  /// 비어 있으면 새 배너를 만든다.
  final EventBanner? banner;

  @override
  ConsumerState<BannerEditScreen> createState() => _BannerEditScreenState();
}

class _BannerEditScreenState extends ConsumerState<BannerEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _subtitle;
  late final TextEditingController _sortOrder;
  late String _icon;
  bool _busy = false;

  bool get _isNew => widget.banner == null;

  @override
  void initState() {
    super.initState();
    final banner = widget.banner;
    _title = TextEditingController(text: banner?.title ?? '');
    _subtitle = TextEditingController(text: banner?.subtitle ?? '');
    _sortOrder = TextEditingController(
      text: (banner?.sortOrder ?? 0).toString(),
    );
    // 표에 없는 아이콘 값이 저장돼 있으면 기본 아이콘으로 되돌린다.
    final icon = banner?.icon ?? defaultBannerIcon;
    _icon = bannerIconChoices.containsKey(icon) ? icon : defaultBannerIcon;
  }

  @override
  void dispose() {
    _title.dispose();
    _subtitle.dispose();
    _sortOrder.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_busy || !(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    setState(() => _busy = true);
    final banner = EventBanner(
      id: widget.banner?.id ?? '',
      title: _title.text.trim(),
      subtitle: _subtitle.text.trim(),
      icon: _icon,
      sortOrder: int.tryParse(_sortOrder.text.trim()) ?? 0,
    );
    try {
      await ref.read(catalogAdminControllerProvider).saveBanner(banner);
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
    final banner = widget.banner;
    if (banner == null || _busy) {
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).bannerRemoveTitle),
        content: Text(
          AppLocalizations.of(context).bannerRemoveBody(banner.title),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context).commonClose),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(AppLocalizations.of(context).bannerRemoveAction),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      return;
    }
    setState(() => _busy = true);
    try {
      await ref.read(catalogAdminControllerProvider).deleteBanner(banner.id);
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
              ? AppLocalizations.of(context).bannerCreateTitle
              : AppLocalizations.of(context).bannerEditTitle,
        ),
        actions: [
          if (!_isNew)
            IconButton(
              onPressed: _busy ? null : _delete,
              tooltip: AppLocalizations.of(context).bannerRemoveAction,
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
              controller: _subtitle,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).adminFieldDescription,
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _icon,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).adminFieldIcon,
              ),
              items: [
                for (final entry in bannerIconChoices.entries)
                  DropdownMenuItem(
                    value: entry.key,
                    child: Row(
                      children: [
                        Icon(entry.value, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          bannerIconLabel(
                            AppLocalizations.of(context),
                            entry.key,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
              onChanged: (value) => setState(() => _icon = value ?? _icon),
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
