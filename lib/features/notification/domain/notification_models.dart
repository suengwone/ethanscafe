import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_models.freezed.dart';

/// 이름은 `notification_labels.dart`의 확장이 l10n에서 꺼내 온다.
///
/// 서버가 만들어 주는 분류만 둔다. 선물은 받는 사람이 계정이 아니라 이름·연락처로
/// 남고, 이벤트는 회원 전체에 뿌리는 일이라 둘 다 아직 알림을 만들 곳이 없다.
enum AppNotificationCategory { order, points }

/// 서버가 보낸 푸시 한 건이 앱 안에 남긴 자국.
///
/// [route]는 알림을 눌렀을 때 갈 곳이다. 서버가 적어 주지 않았거나 앱이 모르는
/// 경로면 비어 있고, 그때는 눌러도 읽음 표시만 된다.
@freezed
abstract class AppNotification with _$AppNotification {
  const factory AppNotification({
    required String id,
    required String title,
    required String body,
    required AppNotificationCategory category,
    required DateTime createdAt,
    @Default(false) bool isRead,
    String? route,
  }) = _AppNotification;
}
