import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'menu_models.freezed.dart';

final _menuPriceFormat = NumberFormat('#,###');

enum MenuCategory {
  drip('드립 커피', '싱글 오리진 원두 9종 · 매주 변경되는 시즌 컬렉션'),
  espresso(
    '에스프레소',
    '우유 변경 오트·아몬드·소이 +0.5 · 락토프리·저지방 +0.3\n'
        '시럽 추가 바닐라·카라멜·헤이즐넛·라벤더 +0.3',
  ),
  beverage('음료', '샷 추가 딸기라떼·발로나초코라떼·말차라떼·복숭아아이스티 +0.5'),
  tea('티', '타바론(Tavalon) 프리미엄 티 컬렉션'),
  dessert('디저트', null);

  const MenuCategory(this.label, this.note);

  final String label;
  final String? note;
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
  }) = _MenuItem;

  String get priceLabel =>
      '${_menuPriceFormat.format(price)}원${priceFrom ? '~' : ''}';
}
