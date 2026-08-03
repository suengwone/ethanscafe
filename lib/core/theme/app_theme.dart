import 'package:flutter/material.dart';

const Color foxtrotGold = Color(0xFFC9A24B);
const Color foxtrotGoldLight = Color(0xFFE8D9A8);
const Color foxtrotBlack = Color(0xFF0B0A09);
const Color foxtrotSurface = Color(0xFF131210);
const Color foxtrotCard = Color(0xFF221F1A);
const Color foxtrotBorder = Color(0xFF3A352C);
const Color foxtrotCream = Color(0xFFEDE8DD);
const Color foxtrotMuted = Color(0xFF9C9285);
const Color foxtrotDanger = Color(0xFFE57373);

const double foxtrotRadiusLarge = 16;
const double foxtrotRadiusMedium = 12;
const double foxtrotRadiusSmall = 4;

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
    error: foxtrotDanger,
    onError: foxtrotBlack,
  );
  return ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    scaffoldBackgroundColor: foxtrotBlack,
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: foxtrotGoldLight,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: foxtrotCream,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: foxtrotCream,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: foxtrotCream,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: foxtrotMuted,
      ),
      bodyMedium: TextStyle(fontSize: 14, color: foxtrotCream),
      bodySmall: TextStyle(fontSize: 12, color: foxtrotMuted),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: foxtrotCream,
      ),
    ),
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
        borderRadius: BorderRadius.circular(foxtrotRadiusLarge),
        side: const BorderSide(color: foxtrotBorder),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: foxtrotGold,
        foregroundColor: foxtrotBlack,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: foxtrotGold,
        side: const BorderSide(color: foxtrotBorder),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: foxtrotGold),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
        borderSide: const BorderSide(color: foxtrotBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
        borderSide: const BorderSide(color: foxtrotGold),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: foxtrotCard,
      contentTextStyle: TextStyle(color: foxtrotCream),
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
    dialogTheme: DialogThemeData(
      backgroundColor: foxtrotCard,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(foxtrotRadiusLarge),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: foxtrotGold,
    ),
  );
}
