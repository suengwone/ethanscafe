import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cafe_app/core/theme/app_theme.dart';
import 'package:cafe_app/core/utils/text_utils.dart';
import 'package:cafe_app/features/pickup/domain/pickup_order_models.dart';
import 'package:cafe_app/features/pickup/domain/pickup_orders_repository.dart';
import 'package:cafe_app/features/pickup/presentation/pickup_order_providers.dart';
import 'package:cafe_app/features/pickup/presentation/pickup_order_tracking_screen.dart';

const _items = [
  PickupOrderItem(
    menuId: 'espresso-vanilla-latte',
    menuName: '바닐라 라떼',
    option: 'ICED',
    quantity: 2,
    unitPrice: 6000,
  ),
  PickupOrderItem(
    menuId: 'dessert-croissant',
    menuName: '크루아상',
    quantity: 1,
    unitPrice: 4500,
  ),
];

PickupOrder _order(PickupOrderStatus status) {
  return PickupOrder(
    id: 'pickup-1',
    storeId: 'macheon',
    storeName: '폭스트롯 마천점',
    pickupNumber: 3,
    items: _items,
    totalAmount: 16500,
    usedPoints: 500,
    status: status,
    createdAt: DateTime(2026, 8, 14, 11, 20),
  );
}

class _StreamPickupOrdersRepository implements PickupOrdersRepository {
  final _controller = StreamController<List<PickupOrder>>.broadcast();

  void emit(List<PickupOrder> orders) => _controller.add(orders);

  void close() => _controller.close();

  @override
  Future<List<PickupOrder>> load() async => const [];

  @override
  Stream<List<PickupOrder>> watchOrders() => _controller.stream;

  @override
  Future<PickupOrder> placeOrder({
    required List<PickupOrderItem> items,
    required String storeId,
    required String storeName,
    int usedPoints = 0,
    int earnedPoints = 0,
    String? couponId,
    String? couponTitle,
    int couponDiscount = 0,
    String? paymentKey,
    String? paymentMethod,
  }) {
    throw UnimplementedError();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<void> pumpTrackingScreen(
    WidgetTester tester, {
    required PickupOrdersRepository repository,
    String orderId = 'pickup-1',
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          pickupOrdersRepositoryProvider.overrideWithValue(repository),
        ],
        child: MaterialApp(
          theme: buildAppTheme(),
          home: PickupOrderTrackingScreen(orderId: orderId),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('주문 정보와 상태 타임라인이 표시된다', (WidgetTester tester) async {
    final repository = _StreamPickupOrdersRepository();
    addTearDown(repository.close);

    await pumpTrackingScreen(tester, repository: repository);
    repository.emit([_order(PickupOrderStatus.preparing)]);
    await tester.pump();

    expect(find.text('폭스트롯 마천점'), findsOneWidget);
    expect(find.text('주문번호 3번'), findsOneWidget);
    expect(find.text('바닐라 라떼 외 1건'.keepWord), findsOneWidget);
    for (final status in PickupOrderStatus.values) {
      expect(find.text(status.label), findsOneWidget);
    }
    expect(find.text('진행 중'), findsOneWidget);
    expect(find.text('바닐라 라떼 (ICED)'.keepWord), findsOneWidget);
    expect(find.text('크루아상'.keepWord), findsOneWidget);
    expect(find.text('16,000원'), findsOneWidget);
  });

  testWidgets('상태가 바뀌면 실시간으로 타임라인이 갱신된다', (WidgetTester tester) async {
    final repository = _StreamPickupOrdersRepository();
    addTearDown(repository.close);

    await pumpTrackingScreen(tester, repository: repository);
    repository.emit([_order(PickupOrderStatus.received)]);
    await tester.pump();

    expect(find.byIcon(LucideIcons.check), findsNothing);

    repository.emit([_order(PickupOrderStatus.ready)]);
    await tester.pump();

    expect(find.byIcon(LucideIcons.check), findsNWidgets(2));
    expect(find.text('진행 중'), findsOneWidget);
  });

  testWidgets('주문을 찾을 수 없으면 안내 문구가 표시된다', (WidgetTester tester) async {
    final repository = _StreamPickupOrdersRepository();
    addTearDown(repository.close);

    await pumpTrackingScreen(
      tester,
      repository: repository,
      orderId: 'unknown',
    );
    repository.emit([_order(PickupOrderStatus.received)]);
    await tester.pump();

    expect(find.text('주문을 찾을 수 없어요'), findsOneWidget);
  });
}
