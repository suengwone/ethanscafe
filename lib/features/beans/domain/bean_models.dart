import 'package:freezed_annotation/freezed_annotation.dart';

part 'bean_models.freezed.dart';

/// 이름은 `bean_labels.dart`의 확장이 l10n에서 꺼내 온다.
enum RoastLevel { light, mediumLight, medium, mediumDark, dark }

enum BeanWeight {
  g200('200g'),
  g500('500g');

  const BeanWeight(this.label);

  final String label;
}

/// 이름과 설명은 `bean_labels.dart`의 확장이 l10n에서 꺼내 온다.
enum GrindOption { wholeBean, espresso, mokaPot, handDrip, frenchPress }

@freezed
abstract class Bean with _$Bean {
  const Bean._();

  const factory Bean({
    required String id,
    required String name,
    required String origin,
    required String description,
    required String story,
    required RoastLevel roastLevel,
    required String process,
    required List<String> tastingNotes,
    required int acidity,
    required int body,
    required int sweetness,
    required List<String> recommendedBrews,
    required int price200,
    required int price500,
    @Default(false) bool isNew,
    @Default(false) bool soldOut,
    @Default(0) int sortOrder,
  }) = _Bean;

  int priceOf(BeanWeight weight) =>
      weight == BeanWeight.g500 ? price500 : price200;

  bool get isDecaf => process.contains('디카페인');

  bool get isAcidic => acidity >= 4;
}
