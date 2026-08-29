import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// 앱이 남기는 이벤트.
///
/// 화면과 데이터 레이어가 직접 Firebase를 부르지 않게 한 겹 둔다. Firebase가 뜨지
/// 않은 자리(테스트, 초기화 실패)에서는 아무 일도 하지 않아야 하므로 그 판단도
/// 여기서 한 번만 한다.
abstract class AnalyticsService {
  Future<void> addToCart({required String itemId, required int amount});

  Future<void> beginCheckout({required int amount, required int itemCount});

  Future<void> purchase({
    required String orderType,
    required int amount,
    required int itemCount,
  });

  /// 주문이 실패한 까닭. 결제 승인 뒤에 서버가 거절하는 경우(품절, 쿠폰 선점)가
  /// 얼마나 자주 일어나는지는 이걸 남겨야만 알 수 있다.
  Future<void> orderFailed({required String orderType, required String reason});
}

/// 아무것도 남기지 않는다. Firebase가 없는 자리에서 쓴다.
class NoopAnalyticsService implements AnalyticsService {
  const NoopAnalyticsService();

  @override
  Future<void> addToCart({required String itemId, required int amount}) async {}

  @override
  Future<void> beginCheckout({
    required int amount,
    required int itemCount,
  }) async {}

  @override
  Future<void> purchase({
    required String orderType,
    required int amount,
    required int itemCount,
  }) async {}

  @override
  Future<void> orderFailed({
    required String orderType,
    required String reason,
  }) async {}
}

class FirebaseAnalyticsService implements AnalyticsService {
  FirebaseAnalyticsService({FirebaseAnalytics? analytics})
    : _analytics = analytics ?? FirebaseAnalytics.instance;

  final FirebaseAnalytics _analytics;

  /// 이벤트 하나가 실패해도 화면이 멈추면 안 된다. 관측은 거들 뿐이다.
  Future<void> _log(String name, Map<String, Object> parameters) async {
    try {
      await _analytics.logEvent(name: name, parameters: parameters);
    } catch (error) {
      debugPrint('analytics event skipped: $name ($error)');
    }
  }

  @override
  Future<void> addToCart({required String itemId, required int amount}) =>
      _log('add_to_cart', {'item_id': itemId, 'value': amount});

  @override
  Future<void> beginCheckout({
    required int amount,
    required int itemCount,
  }) => _log('begin_checkout', {'value': amount, 'item_count': itemCount});

  @override
  Future<void> purchase({
    required String orderType,
    required int amount,
    required int itemCount,
  }) => _log('purchase', {
    'order_type': orderType,
    'value': amount,
    'item_count': itemCount,
  });

  @override
  Future<void> orderFailed({
    required String orderType,
    required String reason,
  }) => _log('order_failed', {'order_type': orderType, 'reason': reason});
}

/// Firebase가 떠 있으면 진짜로 남기고, 아니면 아무것도 하지 않는다.
AnalyticsService createAnalyticsService() {
  try {
    if (Firebase.apps.isNotEmpty) {
      return FirebaseAnalyticsService();
    }
  } catch (_) {}
  return const NoopAnalyticsService();
}
