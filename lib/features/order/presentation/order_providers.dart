import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/presentation/auth_providers.dart';
import '../../beans/domain/bean_cart_models.dart';
import '../../points/presentation/points_providers.dart';
import '../data/firestore_bean_orders_repository.dart';
import '../data/local_bean_orders_repository.dart';
import '../domain/bean_orders_repository.dart';
import '../domain/order_models.dart';

final beanOrdersRepositoryProvider = Provider<BeanOrdersRepository>((ref) {
  try {
    if (Firebase.apps.isNotEmpty) {
      final user = ref.watch(authStateProvider).value;
      if (user != null) {
        return FirestoreBeanOrdersRepository(uid: user.uid);
      }
    }
  } catch (_) {}
  return LocalBeanOrdersRepository();
});

final beanOrdersControllerProvider =
    AsyncNotifierProvider<BeanOrdersController, List<BeanOrder>>(
      BeanOrdersController.new,
    );

class BeanOrdersController extends AsyncNotifier<List<BeanOrder>> {
  static const _earnRate = 0.1;

  @override
  Future<List<BeanOrder>> build() {
    return ref.watch(beanOrdersRepositoryProvider).load();
  }

  Future<BeanOrder> placeOrder({
    required List<BeanCartItem> cartItems,
    int usedPoints = 0,
  }) async {
    if (cartItems.isEmpty) {
      throw StateError('장바구니가 비어 있습니다.');
    }

    final items = cartItems
        .map(
          (item) => BeanOrderItem(
            beanId: item.bean.id,
            beanName: item.bean.name,
            weight: item.weight,
            grind: item.grind,
            quantity: item.quantity,
            unitPrice: item.unitPrice,
          ),
        )
        .toList();
    final totalAmount = items.fold(0, (sum, item) => sum + item.totalPrice);
    if (usedPoints < 0 || usedPoints > totalAmount) {
      throw ArgumentError.value(
        usedPoints,
        'usedPoints',
        '사용 포인트가 결제 금액을 벗어났습니다.',
      );
    }

    final pointsRepository = ref.read(pointsRepositoryProvider);
    if (usedPoints > 0) {
      await pointsRepository.usePoints(
        amount: usedPoints,
        description: beanOrderPointsUseDescription,
      );
    }

    final paidAmount = totalAmount - usedPoints;
    var earnedPoints = 0;
    if (paidAmount > 0) {
      await pointsRepository.recordPayment(
        paymentAmount: paidAmount,
        description: beanOrderPaymentDescription,
      );
      earnedPoints = (paidAmount * _earnRate).floor();
    }
    ref.invalidate(pointsControllerProvider);

    final order = await ref.read(beanOrdersRepositoryProvider).placeOrder(
          items: items,
          usedPoints: usedPoints,
          earnedPoints: earnedPoints,
        );
    state = AsyncValue.data([order, ...state.value ?? const []]);
    return order;
  }
}
