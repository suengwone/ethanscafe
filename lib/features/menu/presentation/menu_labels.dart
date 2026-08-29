import '../../../l10n/app_localizations.dart';
import '../domain/menu_models.dart';

/// 카테고리 이름과 값 표기는 읽는 사람의 언어를 탄다. 모델에 박아 둘 수 없어
/// 화면이 자기 l10n으로 꺼내 쓴다.
extension MenuLabels on AppLocalizations {
  String menuCategoryLabel(MenuCategory category) => switch (category) {
    MenuCategory.drip => menuCategoryDrip,
    MenuCategory.espresso => menuCategoryEspresso,
    MenuCategory.beverage => menuCategoryBeverage,
    MenuCategory.tea => menuCategoryTea,
    MenuCategory.dessert => menuCategoryDessert,
  };

  /// 카테고리마다 붙는 안내. 디저트처럼 없는 것도 있다.
  String? menuCategoryNote(MenuCategory category) => switch (category) {
    MenuCategory.drip => menuCategoryDripNote,
    MenuCategory.espresso => menuCategoryEspressoNote,
    MenuCategory.beverage => menuCategoryBeverageNote,
    MenuCategory.tea => menuCategoryTeaNote,
    MenuCategory.dessert => null,
  };

  String menuPriceLabel(MenuItem item) => item.priceFrom
      ? priceWonFrom(item.formattedPrice)
      : priceWon(item.formattedPrice);
}
