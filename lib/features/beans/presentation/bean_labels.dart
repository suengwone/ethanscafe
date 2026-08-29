import '../../../l10n/app_localizations.dart';
import '../domain/bean_models.dart';

extension BeanLabels on AppLocalizations {
  String roastLevelLabel(RoastLevel level) => switch (level) {
    RoastLevel.light => roastLight,
    RoastLevel.mediumLight => roastMediumLight,
    RoastLevel.medium => roastMedium,
    RoastLevel.mediumDark => roastMediumDark,
    RoastLevel.dark => roastDark,
  };

  String grindLabel(GrindOption grind) => switch (grind) {
    GrindOption.wholeBean => grindWholeBean,
    GrindOption.espresso => grindEspresso,
    GrindOption.mokaPot => grindMokaPot,
    GrindOption.handDrip => grindHandDrip,
    GrindOption.frenchPress => grindFrenchPress,
  };

  String grindDescription(GrindOption grind) => switch (grind) {
    GrindOption.wholeBean => grindWholeBeanNote,
    GrindOption.espresso => grindEspressoNote,
    GrindOption.mokaPot => grindMokaPotNote,
    GrindOption.handDrip => grindHandDripNote,
    GrindOption.frenchPress => grindFrenchPressNote,
  };

  /// `200g · 핸드드립`처럼 무게와 분쇄도를 한 줄로 붙인다. 무게는 단위라 그대로
  /// 두고, 분쇄도만 언어를 탄다.
  String beanOption(BeanWeight weight, GrindOption grind) =>
      beanOptionLabel(weight.label, grindLabel(grind));
}
