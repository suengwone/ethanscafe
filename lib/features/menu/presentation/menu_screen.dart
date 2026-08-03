import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/new_badge.dart';
import '../../beans/presentation/beans_list_view.dart';

enum _MenuBadge { none, isNew, hit }

class _MenuItem {
  final String name;
  final String description;
  final String price;
  final _MenuBadge badge;

  const _MenuItem({
    required this.name,
    required this.description,
    required this.price,
    this.badge = _MenuBadge.none,
  });
}

class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('메뉴'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: '드립 커피'),
              Tab(text: '에스프레소'),
              Tab(text: '음료'),
              Tab(text: '티'),
              Tab(text: '디저트'),
              Tab(text: '원두'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _MenuList(category: 'drip'),
            _MenuList(category: 'espresso'),
            _MenuList(category: 'beverage'),
            _MenuList(category: 'tea'),
            _MenuList(category: 'dessert'),
            BeansListView(),
          ],
        ),
      ),
    );
  }
}

class _MenuList extends StatelessWidget {
  final String category;

  const _MenuList({required this.category});

  @override
  Widget build(BuildContext context) {
    final menuItems = _getMenuItems(category);
    final note = _categoryNote(category);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: menuItems.length + (note == null ? 0 : 1),
      itemBuilder: (context, index) {
        if (note != null && index == 0) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 12),
            child: Text(
              note,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          );
        }
        final item = menuItems[note == null ? index : index - 1];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: foxtrotSurface,
                borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
                border: Border.all(color: foxtrotBorder),
              ),
              child: Icon(
                _categoryIcon(category),
                color: foxtrotGold,
                size: 26,
              ),
            ),
            title: Text(
              item.name,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            subtitle: Text(
              item.description,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  item.price,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (item.badge == _MenuBadge.isNew) const NewBadge(),
                if (item.badge == _MenuBadge.hit) const HitBadge(),
              ],
            ),
            onTap: () {
              // 메뉴 상세 페이지로 이동
            },
          ),
        );
      },
    );
  }

  String? _categoryNote(String category) {
    switch (category) {
      case 'drip':
        return '싱글 오리진 원두 9종 · 매주 변경되는 시즌 컬렉션';
      case 'espresso':
        return '우유 변경 오트·아몬드·소이 +0.5 · 락토프리·저지방 +0.3\n'
            '시럽 추가 바닐라·카라멜·헤이즐넛·라벤더 +0.3';
      case 'beverage':
        return '샷 추가 딸기라떼·발로나초코라떼·말차라떼·복숭아아이스티 +0.5';
      case 'tea':
        return '타바론(Tavalon) 프리미엄 티 컬렉션';
      default:
        return null;
    }
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'drip':
        return LucideIcons.bean;
      case 'espresso':
        return LucideIcons.coffee;
      case 'beverage':
        return LucideIcons.cupSoda;
      case 'tea':
        return LucideIcons.leaf;
      case 'dessert':
        return LucideIcons.croissant;
      default:
        return LucideIcons.coffee;
    }
  }

  List<_MenuItem> _getMenuItems(String category) {
    switch (category) {
      case 'drip':
        return const [
          _MenuItem(
            name: '니카라과 핀카 리브레 게이샤',
            description: '자스민, 레몬그라스, 복숭아, 청포도, 허니, 다즐링',
            price: '6,800원',
            badge: _MenuBadge.isNew,
          ),
          _MenuItem(
            name: '케냐 무랑가 탕가이니 AA TOP 워시드',
            description: '실론티, 메이플 시럽, 오렌지, 베리, 미디엄 헤비 바디',
            price: '6,300원',
            badge: _MenuBadge.isNew,
          ),
          _MenuItem(
            name: '페루 엘 바바코 버번 워시드',
            description: '토피, 감귤류, 누룽지캔디',
            price: '6,300원',
          ),
          _MenuItem(
            name: '인도네시아 만델링 G1 TP',
            description: '갈색 설탕, 브랜디, 건포도, 초코 시럽',
            price: '5,800원',
          ),
          _MenuItem(
            name: '콜롬비아 퀸디오 라 프라데라 레드베리즈',
            description: '체리, 체리 콜라, 석류, 쥬시, 와인, 크림',
            price: '6,300원',
            badge: _MenuBadge.hit,
          ),
          _MenuItem(
            name: '브라질 몬테 벨로 옐로우버본 펄프드내추럴',
            description: '아몬드, 바닐라, 카라멜, 사탕수수, 화이트초콜릿',
            price: '5,300원',
            badge: _MenuBadge.hit,
          ),
          _MenuItem(
            name: '과테말라 안티구아 라 글로리아 SHB 워시드',
            description: '월넛, 바닐라, 페퍼민트, 브라운 슈가, 스모크, 초콜릿',
            price: '5,300원',
          ),
          _MenuItem(
            name: '에티오피아 예가체프 아리차 에이미 G1 내추럴',
            description: '스트로베리, 체리, 피치, 브라운 슈가, 포도, 캔디',
            price: '5,300원',
          ),
          _MenuItem(
            name: '디카페인 과테말라 SHB EP 마운틴 워터',
            description: '호박, 브라운 슈가, 초콜렛, 몰트',
            price: '5,800원',
          ),
        ];
      case 'espresso':
        return const [
          _MenuItem(
            name: '아메리카노',
            description: 'Americano',
            price: '5,000원',
          ),
          _MenuItem(
            name: '카페 라떼',
            description: 'Cafe Latte',
            price: '5,500원',
            badge: _MenuBadge.hit,
          ),
          _MenuItem(
            name: '플랫 화이트',
            description: 'Flat White',
            price: '5,500원',
            badge: _MenuBadge.hit,
          ),
          _MenuItem(
            name: '카푸치노',
            description: 'Cappuccino',
            price: '5,500원',
          ),
          _MenuItem(
            name: '카페모카',
            description: 'Cafe Mocha',
            price: '5,500원',
          ),
          _MenuItem(
            name: '바닐라 라떼',
            description: 'Vanilla Latte',
            price: '5,800원',
            badge: _MenuBadge.hit,
          ),
          _MenuItem(
            name: '카라멜 라떼',
            description: 'Caramel Latte',
            price: '5,800원',
          ),
          _MenuItem(
            name: '헤이즐넛 라떼',
            description: 'Hazelnut Latte',
            price: '5,800원',
          ),
          _MenuItem(
            name: '돌체 라떼',
            description: 'Dolce Latte',
            price: '5,800원',
          ),
          _MenuItem(
            name: '하겐다즈 아포가토',
            description: '기본 6.8 · 말차 7.3 · 발로나 7.8',
            price: '6,800원~',
            badge: _MenuBadge.hit,
          ),
        ];
      case 'beverage':
        return const [
          _MenuItem(
            name: '발로나 초코라떼',
            description: 'Valrhona Chocolate Latte',
            price: '7,500원',
            badge: _MenuBadge.hit,
          ),
          _MenuItem(
            name: '딸기 라떼',
            description: 'Strawberry Latte',
            price: '6,000원',
            badge: _MenuBadge.hit,
          ),
          _MenuItem(
            name: '말차 라떼',
            description: 'Matcha Latte',
            price: '6,500원',
            badge: _MenuBadge.hit,
          ),
          _MenuItem(
            name: '오렌지 몽블랑',
            description: 'Orange Mont Blanc',
            price: '7,300원',
          ),
          _MenuItem(
            name: '과일 주스',
            description: '수박 · 오렌지 · 토마토',
            price: '6,000원',
            badge: _MenuBadge.isNew,
          ),
          _MenuItem(
            name: '수제 복숭아 아이스티',
            description: 'Handmade Peach Ice Tea',
            price: '6,000원',
          ),
          _MenuItem(
            name: '수제청 에이드',
            description: '레몬 · 자몽 · 오미자 · 매실',
            price: '6,000원',
          ),
          _MenuItem(
            name: '수제청 차',
            description: '레몬 · 자몽 · 오미자 · 매실',
            price: '6,000원',
          ),
          _MenuItem(
            name: '밀크티',
            description: '로얄 · 얼그레이',
            price: '6,000원',
          ),
        ];
      case 'tea':
        return const [
          _MenuItem(
            name: '자스민 펄',
            description: 'Jasmine Pearls',
            price: '6,000원',
          ),
          _MenuItem(
            name: '망고 멜랑',
            description: 'Mango Melange',
            price: '6,000원',
          ),
          _MenuItem(
            name: '쿨민트',
            description: 'Cool Mint',
            price: '6,000원',
          ),
          _MenuItem(
            name: '후르츠 드림',
            description: 'Fruits Dream',
            price: '6,000원',
          ),
          _MenuItem(
            name: '피치 우롱',
            description: 'Peach Oolong',
            price: '6,000원',
          ),
          _MenuItem(
            name: '캐모마일',
            description: 'Chamomile',
            price: '6,000원',
          ),
          _MenuItem(
            name: '얼그레이 리저브',
            description: 'Earl Grey Reserve',
            price: '6,000원',
          ),
          _MenuItem(
            name: '루이보스 빌베리',
            description: 'Rooibos Bilberry',
            price: '6,000원',
          ),
          _MenuItem(
            name: '세러니티',
            description: 'Serenity',
            price: '6,000원',
          ),
        ];
      case 'dessert':
        return const [
          _MenuItem(
            name: '얼그레이 케이크',
            description: 'Earl Grey Cake',
            price: '7,000원',
          ),
          _MenuItem(
            name: '휘낭시에',
            description: 'Financier',
            price: '4,500원',
          ),
          _MenuItem(
            name: '르뱅 쿠키',
            description: 'Levain Cookie',
            price: '4,500원',
          ),
        ];
      default:
        return const [];
    }
  }
}
