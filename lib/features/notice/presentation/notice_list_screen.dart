import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/text_utils.dart';
import '../domain/notice_models.dart';
import 'notices_providers.dart';

final _dateFormat = DateFormat('yyyy.MM.dd');

class NoticeListScreen extends ConsumerWidget {
  const NoticeListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noticesState = ref.watch(noticesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('알림')),
      body: noticesState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('알림을 불러오지 못했습니다.'),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.invalidate(noticesProvider),
                child: const Text('다시 시도'),
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
            '새로운 알림이 없어요',
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
        category.label,
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
        '중요',
        style: TextStyle(
          fontSize: 11,
          color: context.palette.background,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
