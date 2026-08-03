import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/new_badge.dart';

class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('메뉴'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '커피'),
              Tab(text: '논커피'),
              Tab(text: '디저트'),
              Tab(text: '원두'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _MenuList(category: 'coffee'),
            _MenuList(category: 'non-coffee'),
            _MenuList(category: 'dessert'),
            _MenuList(category: 'beans'),
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
    // 임시 메뉴 데이터
    final menuItems = _getMenuItems(category);
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final item = menuItems[index];
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
              child: const Icon(Icons.coffee, color: foxtrotGold),
            ),
            title: Text(
              item['name']!,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            subtitle: Text(
              item['description']!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  item['price']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (item['isNew'] == 'true') const NewBadge(),
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

  List<Map<String, String>> _getMenuItems(String category) {
    switch (category) {
      case 'coffee':
        return [
          {'name': '아메리카노', 'description': '진한 에스프레소의 깔끔한 맛', 'price': '4,500원', 'isNew': 'false'},
          {'name': '카페라떼', 'description': '부드러운 우유와 에스프레소', 'price': '5,000원', 'isNew': 'false'},
          {'name': '카푸치노', 'description': '풍성한 우유 거품', 'price': '5,000원', 'isNew': 'false'},
          {'name': '플랫화이트', 'description': '진한 커피와 마이크로폼', 'price': '5,500원', 'isNew': 'true'},
        ];
      case 'non-coffee':
        return [
          {'name': '녹차 라떼', 'description': '고급 말차 파우더', 'price': '5,500원', 'isNew': 'false'},
          {'name': '초코 라떼', 'description': '진한 벨기에 초콜릿', 'price': '5,500원', 'isNew': 'false'},
          {'name': '토피넛 라떼', 'description': '고소한 토피넛 시럽', 'price': '5,500원', 'isNew': 'true'},
        ];
      case 'dessert':
        return [
          {'name': '크로플', 'description': '바삭한 크로와상 와플', 'price': '6,500원', 'isNew': 'false'},
          {'name': '티라미수', 'description': '이탈리아 정통 디저트', 'price': '7,000원', 'isNew': 'false'},
          {'name': '치즈케이크', 'description': '뉴욕 스타일', 'price': '6,500원', 'isNew': 'false'},
        ];
      case 'beans':
        return [
          {'name': '에티오피아 예가체프', 'description': '플로럴한 향과 과일향', 'price': '18,000원', 'isNew': 'false'},
          {'name': '콜롬비아 수프레모', 'description': '균형잡힌 바디감', 'price': '15,000원', 'isNew': 'false'},
          {'name': '브라질 산토스', 'description': '너츠향과 초콜릿향', 'price': '14,000원', 'isNew': 'true'},
        ];
      default:
        return [];
    }
  }
}