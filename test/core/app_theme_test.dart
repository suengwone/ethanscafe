import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cafe_app/core/theme/app_theme.dart';

import '../support/localized_app.dart';

void main() {
  test('밝기에 맞는 팔레트를 테마에 싣는다', () {
    final dark = buildAppTheme();
    final light = buildAppTheme(brightness: Brightness.light);

    expect(dark.extension<FoxtrotPalette>(), FoxtrotPalette.dark);
    expect(light.extension<FoxtrotPalette>(), FoxtrotPalette.light);
    expect(dark.scaffoldBackgroundColor, FoxtrotPalette.dark.background);
    expect(light.scaffoldBackgroundColor, FoxtrotPalette.light.background);
    expect(light.colorScheme.brightness, Brightness.light);
  });

  test('라이트 팔레트는 밝은 배경 위에서 읽히는 값을 쓴다', () {
    final light = FoxtrotPalette.light;

    // 배경이 글자보다 밝아야 라이트 테마다.
    expect(
      light.background.computeLuminance(),
      greaterThan(light.ink.computeLuminance()),
    );
    // 금색 포인트는 카드 위에서 본문만큼은 아니어도 충분히 읽혀야 한다.
    expect(light.accent.computeLuminance(), lessThan(0.3));
    expect(
      light.onAccent.computeLuminance(),
      greaterThan(light.accent.computeLuminance()),
    );
  });

  testWidgets('위젯은 테마에 실린 팔레트를 읽는다', (tester) async {
    late FoxtrotPalette seen;
    await tester.pumpWidget(
      MaterialApp(
        locale: testLocale,
        localizationsDelegates: testLocalizationsDelegates,
        supportedLocales: testSupportedLocales,
        theme: buildAppTheme(brightness: Brightness.light),
        home: Builder(
          builder: (context) {
            seen = context.palette;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(seen, FoxtrotPalette.light);
  });

  testWidgets('테마가 없으면 다크 팔레트로 되돌아간다', (tester) async {
    late FoxtrotPalette seen;
    await tester.pumpWidget(
      MaterialApp(
        locale: testLocale,
        localizationsDelegates: testLocalizationsDelegates,
        supportedLocales: testSupportedLocales,
        home: Builder(
          builder: (context) {
            seen = context.palette;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(seen, FoxtrotPalette.dark);
  });
}
