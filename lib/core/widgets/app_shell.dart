import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: const [
          NavigationDestination(
            icon: Icon(LucideIcons.house),
            selectedIcon: Icon(LucideIcons.house600),
            label: '홈',
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.coffee),
            selectedIcon: Icon(LucideIcons.coffee600),
            label: '주문',
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.qrCode),
            selectedIcon: Icon(LucideIcons.qrCode600),
            label: '페이',
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.user),
            selectedIcon: Icon(LucideIcons.user600),
            label: '마이',
          ),
        ],
      ),
    );
  }
}
