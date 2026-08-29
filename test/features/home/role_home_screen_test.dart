import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cafe_app/core/theme/app_theme.dart';
import 'package:cafe_app/core/utils/text_utils.dart';
import 'package:cafe_app/features/auth/domain/account_models.dart';
import 'package:cafe_app/features/auth/presentation/account_providers.dart';
import 'package:cafe_app/features/auth/presentation/auth_providers.dart';
import 'package:cafe_app/features/home/presentation/home_screen.dart';
import 'package:cafe_app/features/home/presentation/role_home_screen.dart';
import 'package:cafe_app/features/wholesale/presentation/business_home_screen.dart';

import '../auth/fake_account_repository.dart';
import '../auth/fake_auth_repository.dart';

import '../../support/localized_app.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<void> pumpRoleHome(
    WidgetTester tester, {
    required AccountProfile profile,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
          accountRepositoryProvider.overrideWithValue(
            FakeAccountRepository(profile: profile),
          ),
        ],
        child: MaterialApp(
          locale: testLocale,
          localizationsDelegates: testLocalizationsDelegates,
          supportedLocales: testSupportedLocales,
          theme: buildAppTheme(),
          home: const RoleHomeScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('일반 고객 계정은 기존 홈 화면을 본다', (WidgetTester tester) async {
    await pumpRoleHome(tester, profile: const AccountProfile());

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(BusinessHomeScreen), findsNothing);
  });

  testWidgets('사업자 계정은 B2B 도매 홈 화면을 본다', (WidgetTester tester) async {
    await pumpRoleHome(
      tester,
      profile: const AccountProfile(
        type: AccountType.business,
        business: BusinessProfile(
          companyName: '카페 어라운드',
          businessNumber: '123-45-67890',
        ),
      ),
    );

    expect(find.byType(BusinessHomeScreen), findsOneWidget);
    expect(find.byType(HomeScreen), findsNothing);
    expect(find.textContaining('카페 어라운드'.keepWord), findsOneWidget);
    expect(find.text('도매 원두 리스트'), findsOneWidget);
  });
}
