import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cafe_app/core/theme/app_theme.dart';
import 'package:cafe_app/core/utils/text_utils.dart';
import 'package:cafe_app/features/menu/data/local_menu_repository.dart';
import 'package:cafe_app/features/pickup/presentation/pickup_cart_providers.dart';
import 'package:cafe_app/features/pickup/presentation/pickup_cart_screen.dart';

import '../../support/localized_app.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('장바구니 항목을 지우면 실행취소로 되돌릴 수 있다', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final menuItems = await LocalMenuRepository().loadMenuItems();
    final latte = menuItems.firstWhere(
      (item) => item.id == 'espresso-vanilla-latte',
    );
    container
        .read(pickupCartProvider.notifier)
        .add(menuItem: latte, option: 'ICED', quantity: 2);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          locale: testLocale,
          localizationsDelegates: testLocalizationsDelegates,
          supportedLocales: testSupportedLocales,
          theme: buildAppTheme(),
          home: const PickupCartScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text(latte.name.keepWord), findsOneWidget);

    await tester.tap(find.byIcon(LucideIcons.trash2));
    await tester.pumpAndSettle();

    expect(container.read(pickupCartProvider), isEmpty);
    expect(find.textContaining('장바구니에서 뺐어요'), findsOneWidget);

    await tester.tap(find.text('실행취소'));
    await tester.pumpAndSettle();

    final items = container.read(pickupCartProvider);
    expect(items, hasLength(1));
    expect(items.first.option, 'ICED');
    expect(items.first.quantity, 2);
  });
}
