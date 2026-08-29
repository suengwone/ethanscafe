import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// 다크 팔레트 — 브랜드 기본값.
const Color foxtrotGold = Color(0xFFC9A24B);
const Color foxtrotGoldLight = Color(0xFFE8D9A8);
const Color foxtrotBlack = Color(0xFF0B0A09);
const Color foxtrotSurface = Color(0xFF131210);
const Color foxtrotCard = Color(0xFF221F1A);
const Color foxtrotBorder = Color(0xFF3A352C);
const Color foxtrotCream = Color(0xFFEDE8DD);
const Color foxtrotMuted = Color(0xFF9C9285);
const Color foxtrotDanger = Color(0xFFE57373);

/// 라이트 팔레트 — 같은 금색 브랜드를 밝은 배경에서 읽히도록 낮춘 값.
const Color _lightGold = Color(0xFF8A6A1C);
const Color _lightGoldDeep = Color(0xFF5E4710);
const Color _lightOnGold = Color(0xFFFFFCF4);
const Color _lightBackground = Color(0xFFF7F3E9);
const Color _lightSurface = Color(0xFFFFFDF6);
const Color _lightCard = Color(0xFFFFFFFF);
const Color _lightBorder = Color(0xFFE2D9C4);
const Color _lightInk = Color(0xFF241F17);
const Color _lightMuted = Color(0xFF776E5E);
const Color _lightDanger = Color(0xFFC0392B);

const double foxtrotRadiusXLarge = 28;
const double foxtrotRadiusLarge = 20;
const double foxtrotRadiusMedium = 14;
const double foxtrotRadiusSmall = 8;

const double foxtrotScreenHPadding = 20;
const EdgeInsets foxtrotListPadding = EdgeInsets.fromLTRB(
  foxtrotScreenHPadding,
  8,
  foxtrotScreenHPadding,
  24,
);

/// 화면이 참조하는 색 팔레트. 밝기에 따라 값이 달라지므로 위젯은 색 상수를
/// 직접 쓰지 않고 [BuildContextPalette.palette]로 읽는다.
@immutable
class FoxtrotPalette extends ThemeExtension<FoxtrotPalette> {
  const FoxtrotPalette({
    required this.accent,
    required this.accentSoft,
    required this.onAccent,
    required this.background,
    required this.surface,
    required this.card,
    required this.border,
    required this.ink,
    required this.muted,
    required this.danger,
    required this.cardShadow,
    required this.bannerGradients,
  });

  /// 금색 포인트. 버튼 배경·강조 아이콘·강조 텍스트에 쓴다.
  final Color accent;

  /// 제목처럼 한 단계 더 강조하는 자리에 쓰는 금색.
  final Color accentSoft;

  /// [accent] 위에 얹는 글자색.
  final Color onAccent;

  /// 화면 바탕.
  final Color background;

  /// 바탕 위에 한 겹 올라오는 면 (내비게이션 바·바텀시트).
  final Color surface;

  /// 카드 면.
  final Color card;

  /// 테두리·구분선.
  final Color border;

  /// 본문 글자색.
  final Color ink;

  /// 보조 글자색.
  final Color muted;

  /// 경고·삭제.
  final Color danger;

  /// 카드 그림자.
  final List<BoxShadow> cardShadow;

  /// 홈 이벤트 배너 그라데이션.
  final List<List<Color>> bannerGradients;

  static const FoxtrotPalette dark = FoxtrotPalette(
    accent: foxtrotGold,
    accentSoft: foxtrotGoldLight,
    onAccent: foxtrotBlack,
    background: foxtrotBlack,
    surface: foxtrotSurface,
    card: foxtrotCard,
    border: foxtrotBorder,
    ink: foxtrotCream,
    muted: foxtrotMuted,
    danger: foxtrotDanger,
    cardShadow: [
      BoxShadow(color: Color(0x59000000), blurRadius: 24, offset: Offset(0, 8)),
    ],
    bannerGradients: [
      [Color(0xFF8A6D2F), Color(0xFF4A3A17)],
      [Color(0xFF5C4433), Color(0xFF2B1E14)],
      [foxtrotCard, foxtrotSurface],
    ],
  );

  static const FoxtrotPalette light = FoxtrotPalette(
    accent: _lightGold,
    accentSoft: _lightGoldDeep,
    onAccent: _lightOnGold,
    background: _lightBackground,
    surface: _lightSurface,
    card: _lightCard,
    border: _lightBorder,
    ink: _lightInk,
    muted: _lightMuted,
    danger: _lightDanger,
    cardShadow: [
      BoxShadow(color: Color(0x1A6B5A2E), blurRadius: 24, offset: Offset(0, 8)),
    ],
    bannerGradients: [
      [Color(0xFFF3E4BE), Color(0xFFE4CD8F)],
      [Color(0xFFF0E1D3), Color(0xFFDFC7AE)],
      [_lightCard, Color(0xFFF1EADC)],
    ],
  );

  static FoxtrotPalette of(Brightness brightness) =>
      brightness == Brightness.dark ? dark : light;

  @override
  FoxtrotPalette copyWith({
    Color? accent,
    Color? accentSoft,
    Color? onAccent,
    Color? background,
    Color? surface,
    Color? card,
    Color? border,
    Color? ink,
    Color? muted,
    Color? danger,
    List<BoxShadow>? cardShadow,
    List<List<Color>>? bannerGradients,
  }) {
    return FoxtrotPalette(
      accent: accent ?? this.accent,
      accentSoft: accentSoft ?? this.accentSoft,
      onAccent: onAccent ?? this.onAccent,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      card: card ?? this.card,
      border: border ?? this.border,
      ink: ink ?? this.ink,
      muted: muted ?? this.muted,
      danger: danger ?? this.danger,
      cardShadow: cardShadow ?? this.cardShadow,
      bannerGradients: bannerGradients ?? this.bannerGradients,
    );
  }

  @override
  FoxtrotPalette lerp(ThemeExtension<FoxtrotPalette>? other, double t) {
    if (other is! FoxtrotPalette) {
      return this;
    }
    return FoxtrotPalette(
      accent: Color.lerp(accent, other.accent, t)!,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      card: Color.lerp(card, other.card, t)!,
      border: Color.lerp(border, other.border, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      // 목록형 값은 중간값이 의미가 없어 절반을 넘는 쪽을 그대로 쓴다.
      cardShadow: t < 0.5 ? cardShadow : other.cardShadow,
      bannerGradients: t < 0.5 ? bannerGradients : other.bannerGradients,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is FoxtrotPalette &&
        other.accent == accent &&
        other.accentSoft == accentSoft &&
        other.onAccent == onAccent &&
        other.background == background &&
        other.surface == surface &&
        other.card == card &&
        other.border == border &&
        other.ink == ink &&
        other.muted == muted &&
        other.danger == danger &&
        listEquals(other.cardShadow, cardShadow);
  }

  @override
  int get hashCode => Object.hash(
    accent,
    accentSoft,
    onAccent,
    background,
    surface,
    card,
    border,
    ink,
    muted,
    danger,
  );
}

extension BuildContextPalette on BuildContext {
  /// 테마에 실린 팔레트. 테마가 없는 위젯 트리에서도 다크 값으로 동작한다.
  FoxtrotPalette get palette =>
      Theme.of(this).extension<FoxtrotPalette>() ?? FoxtrotPalette.dark;
}

ThemeData buildAppTheme({Brightness brightness = Brightness.dark}) {
  final palette = FoxtrotPalette.of(brightness);
  final colorScheme = ColorScheme(
    brightness: brightness,
    primary: palette.accent,
    onPrimary: palette.onAccent,
    primaryContainer: palette.card,
    onPrimaryContainer: palette.accentSoft,
    secondary: palette.accentSoft,
    onSecondary: palette.onAccent,
    surface: palette.surface,
    onSurface: palette.ink,
    onSurfaceVariant: palette.muted,
    outline: palette.border,
    outlineVariant: palette.border,
    error: palette.danger,
    onError: palette.onAccent,
  );
  return ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    fontFamily: 'Pretendard',
    scaffoldBackgroundColor: palette.background,
    extensions: [palette],
    textTheme: TextTheme(
      headlineMedium: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.8,
        height: 1.15,
        color: palette.accentSoft,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.6,
        height: 1.2,
        color: palette.ink,
      ),
      titleLarge: TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
        height: 1.25,
        color: palette.ink,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
        color: palette.ink,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        color: palette.muted,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        height: 1.45,
        letterSpacing: -0.2,
        color: palette.ink,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        height: 1.4,
        letterSpacing: -0.1,
        color: palette.muted,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        color: palette.ink,
      ),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: palette.background,
      foregroundColor: palette.accentSoft,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: palette.surface,
      indicatorColor: palette.accent.withValues(alpha: 0.18),
      surfaceTintColor: Colors.transparent,
      height: 68,
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected)
              ? palette.accent
              : palette.muted,
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
              ? palette.accent
              : palette.muted,
        ),
      ),
    ),
    cardTheme: CardThemeData(
      color: palette.card,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(foxtrotRadiusLarge),
        side: BorderSide(color: palette.border.withValues(alpha: 0.7)),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: palette.accent,
        foregroundColor: palette.onAccent,
        minimumSize: const Size(64, 52),
        shape: const StadiumBorder(),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: palette.accent,
        side: BorderSide(color: palette.border),
        shape: const StadiumBorder(),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: palette.accent),
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
        borderSide: BorderSide(color: palette.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
        borderSide: BorderSide(color: palette.accent),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: palette.card,
      contentTextStyle: TextStyle(fontFamily: 'Pretendard', color: palette.ink),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: palette.surface,
      surfaceTintColor: Colors.transparent,
      showDragHandle: true,
      dragHandleColor: palette.border,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(foxtrotRadiusXLarge),
        ),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: palette.card,
      selectedColor: palette.accent.withValues(alpha: 0.18),
      side: BorderSide(color: palette.border),
      shape: const StadiumBorder(),
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: palette.accent,
      unselectedLabelColor: palette.muted,
      indicatorColor: palette.accent,
      dividerColor: palette.border,
    ),
    dividerColor: palette.border,
    listTileTheme: ListTileThemeData(
      iconColor: palette.muted,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: palette.card,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(foxtrotRadiusXLarge - 4),
      ),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: palette.accent),
  );
}
