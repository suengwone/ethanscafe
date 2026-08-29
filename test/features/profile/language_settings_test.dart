import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cafe_app/core/l10n/locale_providers.dart';
import 'package:cafe_app/core/theme/app_theme.dart';
import 'package:cafe_app/features/profile/presentation/language_settings_screen.dart';

import '../../support/localized_app.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<ProviderContainer> pumpScreen(
    WidgetTester tester, {
    Locale? stored,
  }) async {
    final container = ProviderContainer(
      overrides: [storedLocaleProvider.overrideWithValue(stored)],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: Consumer(
          builder: (context, ref, _) => MaterialApp(
            // 화면이 고른 언어를 그대로 따라가는지 보려면 하드코딩하면 안 된다.
            locale: ref.watch(localeProvider) ?? testLocale,
            localizationsDelegates: testLocalizationsDelegates,
            supportedLocales: testSupportedLocales,
            theme: buildAppTheme(),
            home: const LanguageSettingsScreen(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  testWidgets('저장된 언어가 선택된 상태로 열린다', (tester) async {
    await pumpScreen(tester, stored: const Locale('en'));

    final group = tester.widget<RadioGroup<String>>(
      find.byType(RadioGroup<String>),
    );
    expect(group.groupValue, 'en');
    expect(find.text('한국어'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
  });

  testWidgets('고른 언어가 없으면 기기 설정이 선택된다', (tester) async {
    await pumpScreen(tester);

    final group = tester.widget<RadioGroup<String>>(
      find.byType(RadioGroup<String>),
    );
    expect(group.groupValue, '');
  });

  testWidgets('영어를 고르면 화면 글이 영어로 바뀌고 기기에 저장된다', (tester) async {
    final container = await pumpScreen(tester);
    expect(find.text('언어'), findsOneWidget);

    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    expect(container.read(localeProvider), const Locale('en'));
    expect(find.text('Language'), findsOneWidget);
    expect(find.text('Choose a language'), findsOneWidget);
    // 언어 이름은 그 언어로 적으므로 영어 화면에서도 그대로다.
    expect(find.text('한국어'), findsOneWidget);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('locale'), 'en');
  });

  testWidgets('기기 설정으로 되돌리면 저장값을 지운다', (tester) async {
    SharedPreferences.setMockInitialValues({'locale': 'en'});
    final container = await pumpScreen(tester, stored: const Locale('en'));

    await tester.tap(find.text('System setting'));
    await tester.pumpAndSettle();

    expect(container.read(localeProvider), isNull);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('locale'), isNull);
  });

  test('저장된 문자열을 로케일로 되돌린다', () {
    expect(decodeLocale('ko'), const Locale('ko'));
    expect(decodeLocale('en'), const Locale('en'));
    expect(decodeLocale(null), isNull);
    expect(decodeLocale(''), isNull);
    // 지원하지 않는 언어는 기기 설정으로 본다.
    expect(decodeLocale('ja'), isNull);
  });

  test('저장된 값이 없으면 기기 설정으로 시작한다', () async {
    expect(await loadStoredLocale(), isNull);

    SharedPreferences.setMockInitialValues({'locale': 'en'});
    expect(await loadStoredLocale(), const Locale('en'));
  });

  test('언어 이름은 그 언어로 적는다', () {
    expect(localeName(const Locale('ko')), '한국어');
    expect(localeName(const Locale('en')), 'English');
  });
}
