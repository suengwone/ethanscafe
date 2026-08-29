import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../l10n/app_localizations.dart';

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
        destinations: [
          NavigationDestination(
            icon: const Icon(LucideIcons.house),
            selectedIcon: const Icon(LucideIcons.house600),
            label: AppLocalizations.of(context).navHome,
          ),
          NavigationDestination(
            icon: const Icon(LucideIcons.coffee),
            selectedIcon: const Icon(LucideIcons.coffee600),
            label: AppLocalizations.of(context).navOrder,
          ),
          NavigationDestination(
            icon: const Icon(LucideIcons.qrCode),
            selectedIcon: const Icon(LucideIcons.qrCode600),
            label: AppLocalizations.of(context).navPay,
          ),
          NavigationDestination(
            icon: const Icon(LucideIcons.user),
            selectedIcon: const Icon(LucideIcons.user600),
            label: AppLocalizations.of(context).navProfile,
          ),
        ],
      ),
    );
  }
}
