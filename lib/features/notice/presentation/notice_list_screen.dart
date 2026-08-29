import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/text_utils.dart';
import '../../../features/notice/presentation/notice_labels.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/notice_models.dart';
import 'notices_providers.dart';

final _dateFormat = DateFormat('yyyy.MM.dd');

class NoticeListScreen extends ConsumerWidget {
  const NoticeListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noticesState = ref.watch(noticesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).noticeListTitle)),
      body: noticesState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(AppLocalizations.of(context).noticeLoadFailed),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.invalidate(noticesProvider),
                child: Text(AppLocalizations.of(context).retry),
              ),
            ],
          ),
        ),
        data: (notices) {
          if (notices.isEmpty) {
            return const _EmptyNotices();
          }
          return ListView.builder(
            padding: foxtrotListPadding,
            itemCount: notices.length,
            itemBuilder: (context, index) =>
                _NoticeCard(notice: notices[index]),
          );
        },
      ),
    );
  }
}

class _EmptyNotices extends StatelessWidget {
  const _EmptyNotices();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.bellOff, size: 48, color: context.palette.muted),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context).noticeEmpty,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}

class _NoticeCard extends StatelessWidget {
  const _NoticeCard({required this.notice});

  final Notice notice;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          iconColor: context.palette.accent,
          collapsedIconColor: context.palette.muted,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CategoryBadge(category: notice.category),
              if (notice.isImportant) ...[
                const SizedBox(width: 6),
                const _ImportantBadge(),
              ],
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notice.title.keepWord, style: textTheme.labelLarge),
                const SizedBox(height: 4),
                Text(
                  _dateFormat.format(notice.createdAt),
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                notice.body.keepWord,
                style: textTheme.bodyMedium?.copyWith(height: 1.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.category});

  final NoticeCategory category;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: context.palette.accent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(foxtrotRadiusSmall),
      ),
      child: Text(
        AppLocalizations.of(context).noticeCategoryLabel(category),
        style: TextStyle(fontSize: 11, color: context.palette.accentSoft),
      ),
    );
  }
}

class _ImportantBadge extends StatelessWidget {
  const _ImportantBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: context.palette.accent,
        borderRadius: BorderRadius.circular(foxtrotRadiusSmall),
      ),
      child: Text(
        AppLocalizations.of(context).noticeImportant,
        style: TextStyle(
          fontSize: 11,
          color: context.palette.onAccent,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
