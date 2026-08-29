import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cafe_app/core/theme/app_theme.dart';
import 'package:cafe_app/features/points/data/local_points_repository.dart';
import 'package:cafe_app/features/referral/domain/referral_models.dart';
import 'package:cafe_app/features/referral/presentation/referral_screen.dart';

import '../../support/localized_app.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({
      'referral_summary': jsonEncode(
        const ReferralSummary(
          code: 'FXP2K9',
          invitedCount: 2,
          earnedPoints: 6000,
        ).toJson(),
      ),
      'points_data': jsonEncode({
        'membershipId': 'MEMBER-12345678',
        'balance': 1000,
        'history': <Object?>[],
      }),
    });
  });

  Future<void> pumpScreen(WidgetTester tester) async {
    // 기본 테스트 화면(800x600)에서는 코드 입력 버튼이 화면 밖으로 밀린다.
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          locale: testLocale,
          localizationsDelegates: testLocalizationsDelegates,
          supportedLocales: testSupportedLocales,
          theme: buildAppTheme(),
          home: const ReferralScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('내 초대 코드와 초대 현황을 보여 준다', (tester) async {
    await pumpScreen(tester);

    expect(find.text('FXP2K9'), findsOneWidget);
    expect(find.text('2명'), findsOneWidget);
    expect(find.text('6,000P'), findsOneWidget);
    expect(find.text('8명'), findsOneWidget);
    expect(find.text('포인트 받기'), findsOneWidget);
  });

  testWidgets('코드를 입력하면 보상을 적립하고 입력 완료로 바뀐다', (tester) async {
    await pumpScreen(tester);

    await tester.enterText(find.byType(TextField), 'abc234');
    await tester.tap(find.text('포인트 받기'));
    await tester.pumpAndSettle();

    expect(find.textContaining('3,000P가 적립됐어요'), findsOneWidget);
    expect(find.text('초대 코드 입력 완료'), findsOneWidget);
    expect(find.textContaining('ABC234 코드로'), findsOneWidget);

    final points = await LocalPointsRepository().load();
    expect(points.balance, 4000);
  });

  testWidgets('본인 코드를 입력하면 사유를 안내한다', (tester) async {
    await pumpScreen(tester);

    await tester.enterText(find.byType(TextField), 'FXP2K9');
    await tester.tap(find.text('포인트 받기'));
    await tester.pumpAndSettle();

    expect(find.text('본인의 초대 코드는 사용할 수 없습니다.'), findsOneWidget);
    expect(find.text('포인트 받기'), findsOneWidget);
  });

  testWidgets('6자리가 아니면 서버를 부르지 않고 형식을 안내한다', (tester) async {
    await pumpScreen(tester);

    await tester.enterText(find.byType(TextField), 'ABC1');
    await tester.tap(find.text('포인트 받기'));
    await tester.pumpAndSettle();

    expect(find.text('초대 코드 6자리를 다시 확인해주세요.'), findsOneWidget);
  });

  testWidgets('초대 문구를 클립보드에 복사한다', (tester) async {
    String? copied;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied = (call.arguments as Map)['text'] as String?;
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );

    await pumpScreen(tester);
    await tester.tap(find.text('초대 문구 복사'));
    await tester.pumpAndSettle();

    expect(copied, contains('FXP2K9'));
    expect(find.text('초대 문구를 복사했어요.'), findsOneWidget);
  });
}
