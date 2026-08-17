import 'package:cafe_app/core/services/connectivity_providers.dart';
import 'package:cafe_app/core/widgets/offline_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(WidgetTester tester, {required Stream<bool> online}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [isOnlineProvider.overrideWith((ref) => online)],
      child: const MaterialApp(
        home: OfflineBanner(child: Scaffold(body: Text('본문'))),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  const message = '인터넷에 연결되어 있지 않습니다';

  testWidgets('오프라인이면 안내 줄을 띄운다', (tester) async {
    await _pump(tester, online: Stream.value(false));

    expect(find.text(message), findsOneWidget);
    expect(find.text('본문'), findsOneWidget);
  });

  testWidgets('온라인이면 안내 줄을 띄우지 않는다', (tester) async {
    await _pump(tester, online: Stream.value(true));

    expect(find.text(message), findsNothing);
  });

  testWidgets('연결 상태를 아직 모르면 안내 줄을 띄우지 않는다', (tester) async {
    await _pump(tester, online: const Stream<bool>.empty());

    expect(find.text(message), findsNothing);
  });
}
