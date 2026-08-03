import 'package:freezed_annotation/freezed_annotation.dart';

part 'bean_models.freezed.dart';

enum RoastLevel {
  light('라이트'),
  mediumLight('미디엄 라이트'),
  medium('미디엄'),
  mediumDark('미디엄 다크'),
  dark('다크');

  const RoastLevel(this.label);

  final String label;
}

enum BeanWeight {
  g200('200g'),
  g500('500g');

  const BeanWeight(this.label);

  final String label;
}

enum GrindOption {
  wholeBean('홀빈', '분쇄하지 않은 원두 그대로'),
  espresso('에스프레소', '가정용 에스프레소 머신용'),
  mokaPot('모카포트', '모카포트 추출용'),
  handDrip('핸드드립', '푸어오버·드리퍼용'),
  frenchPress('프렌치프레스', '침출식 추출용');

  const GrindOption(this.label, this.description);

  final String label;
  final String description;
}

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
  }) = _Bean;

  int priceOf(BeanWeight weight) =>
      weight == BeanWeight.g500 ? price500 : price200;
}
