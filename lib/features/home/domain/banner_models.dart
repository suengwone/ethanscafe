import 'package:freezed_annotation/freezed_annotation.dart';

part 'banner_models.freezed.dart';

@freezed
abstract class EventBanner with _$EventBanner {
  const factory EventBanner({
    required String id,
    required String title,
    required String subtitle,
    @Default('sparkles') String icon,
  }) = _EventBanner;
}
