import 'package:freezed_annotation/freezed_annotation.dart';

part 'notice_models.freezed.dart';

enum NoticeCategory {
  event('이벤트'),
  notice('공지'),
  benefit('혜택');

  const NoticeCategory(this.label);

  final String label;
}

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
