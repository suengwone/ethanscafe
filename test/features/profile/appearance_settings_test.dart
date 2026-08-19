import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cafe_app/core/theme/app_theme.dart';
import 'package:cafe_app/core/theme/theme_mode_providers.dart';
import 'package:cafe_app/features/profile/presentation/appearance_settings_screen.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<ProviderContainer> pumpScreen(
    WidgetTester tester, {
    ThemeMode stored = ThemeMode.system,
  }) async {
    final container = ProviderContainer(
      overrides: [storedThemeModeProvider.overrideWithValue(stored)],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: Consumer(
          builder: (context, ref, _) => MaterialApp(
            theme: buildAppTheme(brightness: Brightness.light),
            darkTheme: buildAppTheme(),
            themeMode: ref.watch(themeModeProvider),
            home: const AppearanceSettingsScreen(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  testWidgets('저장된 테마가 선택된 상태로 열린다', (tester) async {
    await pumpScreen(tester, stored: ThemeMode.light);

    final selected = tester.widget<RadioGroup<ThemeMode>>(
      find.byType(RadioGroup<ThemeMode>),
    );
    expect(selected.groupValue, ThemeMode.light);
    expect(find.text('시스템 설정'), findsOneWidget);
    expect(find.text('라이트'), findsOneWidget);
    expect(find.text('다크'), findsOneWidget);
  });

  testWidgets('테마를 고르면 화면 색이 바뀌고 기기에 저장된다', (tester) async {
    final container = await pumpScreen(tester);

    await tester.tap(find.text('라이트'));
    await tester.pumpAndSettle();

    expect(container.read(themeModeProvider), ThemeMode.light);

    final context = tester.element(find.byType(AppearanceSettingsScreen));
    expect(context.palette, FoxtrotPalette.light);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('theme_mode'), 'light');
  });

  testWidgets('다크를 고르면 다크 팔레트로 돌아온다', (tester) async {
    final container = await pumpScreen(tester, stored: ThemeMode.light);

    await tester.tap(find.text('다크'));
    await tester.pumpAndSettle();

    expect(container.read(themeModeProvider), ThemeMode.dark);
    expect(
      tester.element(find.byType(AppearanceSettingsScreen)).palette,
      FoxtrotPalette.dark,
    );
  });

  test('저장된 문자열을 테마 모드로 되돌린다', () {
    expect(decodeThemeMode('light'), ThemeMode.light);
    expect(decodeThemeMode('dark'), ThemeMode.dark);
    expect(decodeThemeMode('system'), ThemeMode.system);
    expect(decodeThemeMode(null), ThemeMode.system);
    expect(decodeThemeMode('sepia'), ThemeMode.system);
  });

  test('저장된 값이 없으면 시스템 설정으로 시작한다', () async {
    expect(await loadStoredThemeMode(), ThemeMode.system);

    SharedPreferences.setMockInitialValues({'theme_mode': 'dark'});
    expect(await loadStoredThemeMode(), ThemeMode.dark);
  });
}
