import '../../../l10n/app_localizations.dart';
import '../domain/notification_models.dart';

extension AppNotificationLabels on AppLocalizations {
  String notificationCategoryLabel(AppNotificationCategory category) =>
      switch (category) {
        AppNotificationCategory.order => notificationCategoryOrder,
        AppNotificationCategory.points => notificationCategoryPoints,
        AppNotificationCategory.gift => notificationCategoryGift,
        AppNotificationCategory.event => notificationCategoryEvent,
      };

  /// 받은 지 얼마 안 된 알림은 "3분 전"처럼, 일주일이 넘으면 날짜로 적는다.
  String notificationTimeLabel(DateTime createdAt, DateTime now) {
    final elapsed = now.difference(createdAt);
    if (elapsed.inMinutes < 1) {
      return notificationTimeJustNow;
    }
    if (elapsed.inHours < 1) {
      return notificationTimeMinutesAgo(elapsed.inMinutes);
    }
    if (elapsed.inDays < 1) {
      return notificationTimeHoursAgo(elapsed.inHours);
    }
    if (elapsed.inDays < 7) {
      return notificationTimeDaysAgo(elapsed.inDays);
    }
    return notificationTimeOn(createdAt);
  }
}
