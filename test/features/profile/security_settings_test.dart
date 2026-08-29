import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cafe_app/core/services/points_lock_providers.dart';
import 'package:cafe_app/core/services/points_lock_service.dart';
import 'package:cafe_app/core/theme/app_theme.dart';
import 'package:cafe_app/core/utils/text_utils.dart';
import 'package:cafe_app/features/profile/presentation/security_settings_screen.dart';

import '../../support/localized_app.dart';

class _Authenticator implements DeviceAuthenticator {
  _Authenticator({required this.supported});

  final bool supported;

  @override
  Future<bool> isSupported() async => supported;

  @override
  Future<DeviceAuthResult> authenticate(String reason) async =>
      DeviceAuthResult.passed;
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<void> pumpScreen(WidgetTester tester, {bool deviceLock = true}) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          deviceAuthenticatorProvider.overrideWithValue(
            _Authenticator(supported: deviceLock),
          ),
        ],
        child: MaterialApp(
          locale: testLocale,
          localizationsDelegates: testLocalizationsDelegates,
          supportedLocales: testSupportedLocales,
          theme: buildAppTheme(),
          home: const SecuritySettingsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('포인트 사용 잠금은 켜진 채로 보인다', (tester) async {
    await pumpScreen(tester);

    expect(
      tester.widget<SwitchListTile>(find.byType(SwitchListTile)).value,
      isTrue,
    );
    expect(find.text('이 기기에는 화면 잠금이 없어 확인을 건너뜁니다.'.keepWord), findsNothing);
  });

  testWidgets('스위치를 끄면 기기에 저장된다', (tester) async {
    await pumpScreen(tester);

    await tester.tap(find.byType(SwitchListTile));
    await tester.pumpAndSettle();

    expect(
      tester.widget<SwitchListTile>(find.byType(SwitchListTile)).value,
      isFalse,
    );
    expect(await PointsLockSettings().isEnabled(), isFalse);
  });

  testWidgets('잠금이 없는 기기에는 확인을 건너뛴다고 적는다', (tester) async {
    await pumpScreen(tester, deviceLock: false);

    expect(find.text('이 기기에는 화면 잠금이 없어 확인을 건너뜁니다.'), findsOneWidget);
  });
}
