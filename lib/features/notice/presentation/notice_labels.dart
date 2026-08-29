import '../../../l10n/app_localizations.dart';
import '../domain/notice_models.dart';

extension NoticeLabels on AppLocalizations {
  String noticeCategoryLabel(NoticeCategory category) => switch (category) {
    NoticeCategory.event => noticeCategoryEvent,
    NoticeCategory.notice => noticeCategoryNotice,
    NoticeCategory.benefit => noticeCategoryBenefit,
  };
}
