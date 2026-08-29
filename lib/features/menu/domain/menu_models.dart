import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'menu_models.freezed.dart';

final _menuPriceFormat = NumberFormat('#,###');

/// 이름과 설명은 읽는 사람의 언어를 타므로 여기 두지 않는다. `menu_labels.dart`
/// 의 확장이 l10n에서 꺼내 온다.
enum MenuCategory {
  drip,
  espresso,
  beverage,
  tea,
  dessert;

  String get imageAsset => 'assets/images/menu/$name.png';
}

enum MenuBadge { none, isNew, hit }

@freezed
abstract class MenuItem with _$MenuItem {
  const MenuItem._();

  const factory MenuItem({
    required String id,
    required String name,
    required String description,
    required MenuCategory category,
    required int price,
    @Default(false) bool priceFrom,
    @Default(MenuBadge.none) MenuBadge badge,
    @Default(<String>[]) List<String> servingOptions,
    String? detail,
    @Default(false) bool isRecommended,
    @Default(false) bool soldOut,
    @Default(0) int sortOrder,
    String? imageUrl,
  }) = _MenuItem;

  /// 통화 표기가 언어를 타므로 화면은 `menu_labels.dart`의 확장을 쓴다.
  String get formattedPrice => _menuPriceFormat.format(price);

  /// 매장이 올린 사진이 없으면 카테고리 사진으로 대신한다. 카테고리 사진은
  /// 같은 분류의 메뉴가 전부 똑같이 보이므로 자리를 채우는 용도일 뿐이다.
  String get imageAsset => category.imageAsset;

  bool get hasPhoto => imageUrl != null && imageUrl!.isNotEmpty;
}
