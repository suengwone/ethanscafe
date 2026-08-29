import 'package:flutter/foundation.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 리뷰를 요청하기까지 필요한 주문 횟수.
const reviewPromptOrderCount = 3;

/// 이미 요청했으면 다시 묻지 않는다.
bool shouldRequestReview({
  required int completedOrders,
  required bool alreadyRequested,
}) {
  if (alreadyRequested) {
    return false;
  }
  return completedOrders >= reviewPromptOrderCount;
}

class AppReviewService {
  AppReviewService({InAppReview? inAppReview})
    : _inAppReview = inAppReview ?? InAppReview.instance;

  final InAppReview _inAppReview;

  static const orderCountKey = 'app_review_order_count';
  static const requestedKey = 'app_review_requested';

  /// 주문이 끝날 때마다 호출한다. 조건을 채우면 스토어 리뷰 요청을 띄운다.
  /// 리뷰 요청은 부가 기능이라 어떤 실패도 주문 흐름을 막지 않는다.
  Future<void> onOrderPlaced() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final orderCount = (prefs.getInt(orderCountKey) ?? 0) + 1;
      await prefs.setInt(orderCountKey, orderCount);

      final alreadyRequested = prefs.getBool(requestedKey) ?? false;
      if (!shouldRequestReview(
        completedOrders: orderCount,
        alreadyRequested: alreadyRequested,
      )) {
        return;
      }
      if (!await _inAppReview.isAvailable()) {
        return;
      }
      await _inAppReview.requestReview();
      await prefs.setBool(requestedKey, true);
    } catch (e) {
      debugPrint('App review request skipped: $e');
    }
  }
}
