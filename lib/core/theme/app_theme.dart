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

const double foxtrotRadiusXLarge = 28;
const double foxtrotRadiusLarge = 20;
const double foxtrotRadiusMedium = 14;
const double foxtrotRadiusSmall = 8;

List<BoxShadow> foxtrotCardShadow = [
  BoxShadow(
    color: Colors.black.withValues(alpha: 0.35),
    blurRadius: 24,
    offset: const Offset(0, 8),
  ),
];

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
        fontWeight: FontWeight.w800,
        letterSpacing: -0.8,
        height: 1.15,
        color: foxtrotGoldLight,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.6,
        height: 1.2,
        color: foxtrotCream,
      ),
      titleLarge: TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
        height: 1.25,
        color: foxtrotCream,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
        color: foxtrotCream,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        color: foxtrotMuted,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        height: 1.45,
        letterSpacing: -0.2,
        color: foxtrotCream,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        height: 1.4,
        letterSpacing: -0.1,
        color: foxtrotMuted,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        color: foxtrotCream,
      ),
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: foxtrotBlack,
      foregroundColor: foxtrotGoldLight,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: foxtrotSurface,
      indicatorColor: foxtrotGold.withValues(alpha: 0.18),
      surfaceTintColor: Colors.transparent,
      height: 68,
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected)
              ? foxtrotGold
              : foxtrotMuted,
        ),
      ),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          fontSize: 11,
          letterSpacing: -0.1,
          fontWeight: states.contains(WidgetState.selected)
              ? FontWeight.w700
              : FontWeight.w500,
          color: states.contains(WidgetState.selected)
              ? foxtrotGold
              : foxtrotMuted,
        ),
      ),
    ),
    cardTheme: CardThemeData(
      color: foxtrotCard,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(foxtrotRadiusLarge),
        side: BorderSide(color: foxtrotBorder.withValues(alpha: 0.7)),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: foxtrotGold,
        foregroundColor: foxtrotBlack,
        minimumSize: const Size(64, 52),
        shape: const StadiumBorder(),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: foxtrotGold,
        side: const BorderSide(color: foxtrotBorder),
        shape: const StadiumBorder(),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: foxtrotGold),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(64, 52),
        shape: const StadiumBorder(),
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
    snackBarTheme: SnackBarThemeData(
      backgroundColor: foxtrotCard,
      contentTextStyle: const TextStyle(color: foxtrotCream),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: foxtrotSurface,
      surfaceTintColor: Colors.transparent,
      showDragHandle: true,
      dragHandleColor: foxtrotBorder,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(foxtrotRadiusXLarge),
        ),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: foxtrotCard,
      selectedColor: foxtrotGold.withValues(alpha: 0.18),
      side: const BorderSide(color: foxtrotBorder),
      shape: const StadiumBorder(),
    ),
    tabBarTheme: const TabBarThemeData(
      labelColor: foxtrotGold,
      unselectedLabelColor: foxtrotMuted,
      indicatorColor: foxtrotGold,
      dividerColor: foxtrotBorder,
    ),
    dividerColor: foxtrotBorder,
    listTileTheme: ListTileThemeData(
      iconColor: foxtrotMuted,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: foxtrotCard,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(foxtrotRadiusXLarge - 4),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: foxtrotGold,
    ),
  );
}
