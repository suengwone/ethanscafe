import 'package:cafe_app/core/services/remote_config_providers.dart';
import 'package:cafe_app/core/services/remote_config_service.dart';
import 'package:cafe_app/core/widgets/update_gate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/localized_app.dart';

Future<void> _pump(
  WidgetTester tester, {
  required bool updateRequired,
  RemoteAppConfig config = const RemoteAppConfig(),
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        isUpdateRequiredProvider.overrideWithValue(updateRequired),
        remoteAppConfigProvider.overrideWith((ref) => config),
      ],
      child: const MaterialApp(
        locale: testLocale,
        localizationsDelegates: testLocalizationsDelegates,
        supportedLocales: testSupportedLocales,
        home: UpdateGate(child: Scaffold(body: Text('본문'))),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  const title = '업데이트가 필요합니다';

  testWidgets('업데이트가 필요 없으면 앱 화면을 그대로 보여준다', (tester) async {
    await _pump(tester, updateRequired: false);

    expect(find.text('본문'), findsOneWidget);
    expect(find.text(title), findsNothing);
  });

  testWidgets('업데이트가 필요하면 앱 화면을 막는다', (tester) async {
    await _pump(tester, updateRequired: true);

    expect(find.text(title), findsOneWidget);
    expect(find.text('본문'), findsNothing);
  });

  testWidgets('스토어 주소가 있으면 이동 버튼을 띄운다', (tester) async {
    await _pump(
      tester,
      updateRequired: true,
      config: const RemoteAppConfig(storeUrl: 'https://example.com/app'),
    );

    expect(find.text('업데이트하러 가기'), findsOneWidget);
  });

  testWidgets('스토어 주소가 없으면 이동 버튼을 감춘다', (tester) async {
    await _pump(tester, updateRequired: true);

    expect(find.text('업데이트하러 가기'), findsNothing);
  });
}
