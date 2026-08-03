import 'package:flutter/material.dart';

const Color foxtrotGold = Color(0xFFC9A24B);
const Color foxtrotGoldLight = Color(0xFFE8D9A8);
const Color foxtrotBlack = Color(0xFF0B0A09);
const Color foxtrotSurface = Color(0xFF131210);
const Color foxtrotCard = Color(0xFF221F1A);
const Color foxtrotBorder = Color(0xFF3A352C);
const Color foxtrotCream = Color(0xFFEDE8DD);
const Color foxtrotMuted = Color(0xFF9C9285);

ThemeData buildAppTheme() {
  const colorScheme = ColorScheme.dark(
    primary: foxtrotGold,
    onPrimary: foxtrotBlack,
    primaryContainer: foxtrotCard,
    onPrimaryContainer: foxtrotGoldLight,
    secondary: foxtrotGoldLight,
    onSecondary: foxtrotBlack,
    surface: foxtrotSurface,
    onSurface: foxtrotCream,
    onSurfaceVariant: foxtrotMuted,
    outline: foxtrotBorder,
    outlineVariant: foxtrotBorder,
  );
  return ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    scaffoldBackgroundColor: foxtrotBlack,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: foxtrotBlack,
      foregroundColor: foxtrotGoldLight,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: foxtrotSurface,
      indicatorColor: foxtrotGold.withValues(alpha: 0.18),
      surfaceTintColor: Colors.transparent,
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected)
              ? foxtrotGold
              : foxtrotMuted,
        ),
      ),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          fontSize: 12,
          color: states.contains(WidgetState.selected)
              ? foxtrotGold
              : foxtrotMuted,
        ),
      ),
    ),
    cardTheme: CardThemeData(
      color: foxtrotCard,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: foxtrotBorder),
      ),
    ),
    tabBarTheme: const TabBarThemeData(
      labelColor: foxtrotGold,
      unselectedLabelColor: foxtrotMuted,
      indicatorColor: foxtrotGold,
      dividerColor: foxtrotBorder,
    ),
    dividerColor: foxtrotBorder,
    listTileTheme: const ListTileThemeData(
      iconColor: foxtrotMuted,
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: foxtrotCard,
      surfaceTintColor: Colors.transparent,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: foxtrotGold,
    ),
  );
}
