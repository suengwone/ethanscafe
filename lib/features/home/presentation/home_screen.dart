import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ethan\'s Cafe'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          _MenuCard(
            icon: Icons.coffee,
            title: '메뉴',
            color: Colors.brown,
            onTap: () => context.go('/menu'),
          ),
          _MenuCard(
            icon: Icons.payments,
            title: '포인트',
            color: Colors.purple,
            onTap: () => context.go('/points'),
          ),
          _MenuCard(
            icon: Icons.store,
            title: '매장 찾기',
            color: Colors.green,
            onTap: () {},
          ),
          _MenuCard(
            icon: Icons.notifications,
            title: '알림',
            color: Colors.orange,
            onTap: () {},
          ),
          _MenuCard(
            icon: Icons.shopping_cart,
            title: '원두 쇼핑',
            color: Colors.blue,
            onTap: () {},
          ),
          _MenuCard(
            icon: Icons.person,
            title: '내 정보',
            color: Colors.teal,
            onTap: () => context.go('/profile'),
          ),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}