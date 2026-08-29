import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cafe_app/core/services/points_lock_providers.dart';
import 'package:cafe_app/core/services/points_lock_service.dart';
import 'package:cafe_app/core/theme/app_theme.dart';
import 'package:cafe_app/features/points/domain/charge_plans.dart';
import 'package:cafe_app/features/points/domain/points_models.dart';
import 'package:cafe_app/features/points/domain/points_repository.dart';
import 'package:cafe_app/features/points/presentation/points_providers.dart';
import 'package:cafe_app/features/points/presentation/points_screen.dart';

import '../../support/localized_app.dart';

class _RecordingPointsRepository implements PointsRepository {
  int? usedAmount;

  @override
  Future<PointsData> load() async => PointsData(
    membershipId: 'MEMBER-12345678',
    balance: 5000,
    history: const [],
  );

  @override
  Future<PointsData> usePoints({
    required int amount,
    String description = pointsPaymentDescription,
  }) async {
    usedAmount = amount;
    return PointsData(
      membershipId: 'MEMBER-12345678',
      balance: 5000 - amount,
      history: const [],
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Authenticator implements DeviceAuthenticator {
  _Authenticator(this.result);

  final DeviceAuthResult result;
  int asked = 0;

  @override
  Future<bool> isSupported() async => true;

  @override
  Future<DeviceAuthResult> authenticate(String reason) async {
    asked += 1;
    return result;
  }
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<_RecordingPointsRepository> pumpAndUsePoints(
    WidgetTester tester,
    _Authenticator authenticator,
  ) async {
    final repository = _RecordingPointsRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          pointsRepositoryProvider.overrideWithValue(repository),
          deviceAuthenticatorProvider.overrideWithValue(authenticator),
        ],
        child: MaterialApp(
          locale: testLocale,
          localizationsDelegates: testLocalizationsDelegates,
          supportedLocales: testSupportedLocales,
          theme: buildAppTheme(),
          home: const PointsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('포인트 사용').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '1000');
    await tester.pumpAndSettle();
    await tester.tap(find.text('사용').last);
    await tester.pumpAndSettle();
    return repository;
  }

  testWidgets('포인트 화면에서 쓸 때도 본인 확인을 받는다', (tester) async {
    final authenticator = _Authenticator(DeviceAuthResult.passed);

    final repository = await pumpAndUsePoints(tester, authenticator);

    expect(authenticator.asked, 1);
    expect(repository.usedAmount, 1000);
  });

  testWidgets('본인 확인이 막히면 포인트가 빠져나가지 않는다', (tester) async {
    // 폰을 주운 사람이 이 화면에서 잔액을 그대로 쓰지 못해야 한다.
    final authenticator = _Authenticator(DeviceAuthResult.refused);

    final repository = await pumpAndUsePoints(tester, authenticator);

    expect(authenticator.asked, 1);
    expect(repository.usedAmount, isNull);
  });
}
