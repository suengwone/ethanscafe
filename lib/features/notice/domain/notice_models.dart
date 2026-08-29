import 'package:freezed_annotation/freezed_annotation.dart';

part 'notice_models.freezed.dart';

/// 이름은 `notice_labels.dart`의 확장이 l10n에서 꺼내 온다.
enum NoticeCategory { event, notice, benefit }

@freezed
abstract class Notice with _$Notice {
  const factory Notice({
    required String id,
    required String title,
    required String body,
    required NoticeCategory category,
    required DateTime createdAt,
    @Default(false) bool isImportant,
  }) = _Notice;
}
