import 'package:freezed_annotation/freezed_annotation.dart';

part 'store_models.freezed.dart';

/// 매장 혼잡도. 직원이 카탈로그 관리에서 눌러 올리거나,
/// 없으면 진행 중인 픽업 주문 수로 서버가 자동으로 잰다.
enum StoreCongestion {
  unknown('정보 없음'),
  relaxed('여유'),
  normal('보통'),
  busy('혼잡');

  const StoreCongestion(this.label);

  final String label;
}

/// `09:00 - 21:00` 형태의 영업시간 문자열.
class StoreHours {
  const StoreHours({required this.openMinutes, required this.closeMinutes});

  /// 자정 기준 분. `09:00`이면 540.
  final int openMinutes;
  final int closeMinutes;

  static final _pattern = RegExp(r'^(\d{1,2}):(\d{2})\s*[-~]\s*(\d{1,2}):(\d{2})$');

  /// 해석할 수 없는 문자열(휴무, 빈 값, 자유 서술)이면 null.
  static StoreHours? parse(String text) {
    final match = _pattern.firstMatch(text.trim());
    if (match == null) {
      return null;
    }
    final openHour = int.parse(match[1]!);
    final openMinute = int.parse(match[2]!);
    final closeHour = int.parse(match[3]!);
    final closeMinute = int.parse(match[4]!);
    if (openHour > 24 || closeHour > 24 || openMinute > 59 || closeMinute > 59) {
      return null;
    }
    return StoreHours(
      openMinutes: openHour * 60 + openMinute,
      closeMinutes: closeHour * 60 + closeMinute,
    );
  }

  /// 마감이 자정을 넘기는 매장. 여는 시각과 닫는 시각이 같으면 24시간으로 본다.
  bool get isOvernight => closeMinutes <= openMinutes;

  bool isOpenAt(DateTime now) {
    final minutes = now.hour * 60 + now.minute;
    if (isOvernight) {
      return minutes >= openMinutes || minutes < closeMinutes;
    }
    return minutes >= openMinutes && minutes < closeMinutes;
  }
}

@freezed
abstract class CafeStore with _$CafeStore {
  const factory CafeStore({
    required String id,
    required String name,
    required String address,
    required String phone,
    required double latitude,
    required double longitude,
    required String weekdayHours,
    required String weekendHours,
    @Default(<String>[]) List<String> services,
    @Default(0) int sortOrder,
    @Default('') String notice,
    @Default(StoreCongestion.unknown) StoreCongestion congestion,
    DateTime? congestionUpdatedAt,
  }) = _CafeStore;

  const CafeStore._();

  /// 혼잡도를 올린 지 이 시간이 지나면 더 이상 보여주지 않는다.
  static const congestionFreshness = Duration(hours: 3);

  /// 토·일은 주말 영업시간을 쓴다.
  String hoursOn(DateTime day) {
    final isWeekend = day.weekday == DateTime.saturday ||
        day.weekday == DateTime.sunday;
    return isWeekend ? weekendHours : weekdayHours;
  }

  /// 영업시간을 해석할 수 없으면 null — 이때는 열림/닫힘을 단정하지 않는다.
  bool? isOpenAt(DateTime now) => StoreHours.parse(hoursOn(now))?.isOpenAt(now);

  /// 오래된 혼잡도는 `unknown`으로 낮춘다. 직원이 잊고 안 바꾼 값을
  /// 고객이 현재 상태로 믿는 편이 아무것도 안 보이는 것보다 나쁘다.
  StoreCongestion congestionAt(DateTime now) {
    final updatedAt = congestionUpdatedAt;
    if (congestion == StoreCongestion.unknown || updatedAt == null) {
      return StoreCongestion.unknown;
    }
    if (now.difference(updatedAt) > congestionFreshness) {
      return StoreCongestion.unknown;
    }
    return congestion;
  }

  /// 고객 화면에 실제로 띄울 혼잡도. 직원이 올린 값이 먼저고,
  /// 없거나 낡았으면 진행 중인 주문으로 잰 자동 집계로 메운다.
  StoreCongestionView congestionViewAt(DateTime now, {StoreActivity? activity}) {
    final staff = congestionAt(now);
    if (staff != StoreCongestion.unknown) {
      return StoreCongestionView(staff);
    }
    final live = activity?.congestionAt(now) ?? StoreCongestion.unknown;
    if (live == StoreCongestion.unknown) {
      return const StoreCongestionView(StoreCongestion.unknown);
    }
    return StoreCongestionView(live, liveOrders: activity!.activeOrders);
  }
}

/// 서버가 진행 중인 픽업 주문 수로 잰 매장별 혼잡도 (`store_activity`).
/// 직원이 손대지 않아도 붐비는 시간대가 고객 화면에 그대로 드러난다.
@freezed
abstract class StoreActivity with _$StoreActivity {
  const factory StoreActivity({
    required String storeId,
    /// 아직 음료가 나오지 않은 픽업 주문 수.
    @Default(0) int activeOrders,
    @Default(StoreCongestion.unknown) StoreCongestion congestion,
    required DateTime updatedAt,
  }) = _StoreActivity;

  const StoreActivity._();

  /// 밀린 주문이 이만큼 오래 그대로면 더 이상 현재 상태로 보지 않는다.
  static const freshness = Duration(hours: 2);

  StoreCongestion congestionAt(DateTime now) {
    // 진행 중인 주문이 없다는 사실은 시간이 지나도 그대로다. 새 주문이 들어오면
    // 트리거가 곧바로 다시 쓰므로, 오래된 0건은 낡은 값이 아니라 한산하다는 뜻이다.
    if (activeOrders <= 0) {
      return StoreCongestion.relaxed;
    }
    // 반면 밀린 주문은 직원이 상태를 안 넘긴 탓일 수 있어 오래되면 믿지 않는다.
    if (now.difference(updatedAt) > freshness) {
      return StoreCongestion.unknown;
    }
    return congestion;
  }
}

/// 화면에 띄울 혼잡도 한 건 — 값과, 자동 집계라면 그 근거가 된 주문 수.
class StoreCongestionView {
  const StoreCongestionView(this.congestion, {this.liveOrders});

  final StoreCongestion congestion;

  /// 자동 집계로 잰 값이면 진행 중인 주문 수, 직원이 올린 값이면 null.
  final int? liveOrders;

  bool get isLive => liveOrders != null;
}
