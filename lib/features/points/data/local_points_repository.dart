import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/points_models.dart';
import '../domain/points_repository.dart';

class LocalPointsRepository implements PointsRepository {
  static const _storageKey = 'points_data';
  static const _legacyStorageKey = 'membership_data';
  static const earnRate = 0.1;

  @override
  Future<PointsData> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw != null) {
      return PointsData.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    }

    final data = PointsData(membershipId: _migrateLegacyMembershipId(prefs));
    await _save(prefs, data);
    return data;
  }

  @override
  Future<PointsData> recordPayment({
    required int paymentAmount,
    String description = '매장 결제',
  }) async {
    if (paymentAmount <= 0) {
      throw ArgumentError.value(paymentAmount, 'paymentAmount', '결제 금액은 0보다 커야 합니다.');
    }

    final prefs = await SharedPreferences.getInstance();
    var data = await load();
    final earned = (paymentAmount * earnRate).floor();

    data = data.copyWith(
      balance: data.balance + earned,
      history: [
        PointHistoryEntry(
          id: _generateId(),
          type: PointHistoryType.earn,
          description: description,
          amount: earned,
          paymentAmount: paymentAmount,
          createdAt: DateTime.now(),
        ),
        ...data.history,
      ],
    );

    await _save(prefs, data);
    return data;
  }

  @override
  Future<PointsData> usePoints({
    required int amount,
    String description = '포인트 결제',
  }) async {
    if (amount <= 0) {
      throw ArgumentError.value(amount, 'amount', '사용 포인트는 0보다 커야 합니다.');
    }

    final prefs = await SharedPreferences.getInstance();
    var data = await load();
    if (amount > data.balance) {
      throw StateError('포인트 잔액이 부족합니다.');
    }

    data = data.copyWith(
      balance: data.balance - amount,
      history: [
        PointHistoryEntry(
          id: _generateId(),
          type: PointHistoryType.use,
          description: description,
          amount: -amount,
          createdAt: DateTime.now(),
        ),
        ...data.history,
      ],
    );

    await _save(prefs, data);
    return data;
  }

  @override
  Future<PointsData> refundOrderPoints({
    int usedPoints = 0,
    int earnedPoints = 0,
    String description = '주문 취소',
  }) async {
    if (usedPoints < 0 || earnedPoints < 0) {
      throw ArgumentError('환급/회수 포인트는 0 이상이어야 합니다.');
    }

    final prefs = await SharedPreferences.getInstance();
    var data = await load();
    if (usedPoints == 0 && earnedPoints == 0) {
      return data;
    }

    final reclaimed = min(earnedPoints, data.balance + usedPoints);
    data = data.copyWith(
      balance: data.balance + usedPoints - reclaimed,
      history: [
        if (reclaimed > 0)
          PointHistoryEntry(
            id: _generateId(),
            type: PointHistoryType.use,
            description: '$description 적립 회수',
            amount: -reclaimed,
            createdAt: DateTime.now(),
          ),
        if (usedPoints > 0)
          PointHistoryEntry(
            id: _generateId(),
            type: PointHistoryType.earn,
            description: '$description 포인트 환급',
            amount: usedPoints,
            createdAt: DateTime.now(),
          ),
        ...data.history,
      ],
    );

    await _save(prefs, data);
    return data;
  }

  String _migrateLegacyMembershipId(SharedPreferences prefs) {
    final legacyRaw = prefs.getString(_legacyStorageKey);
    if (legacyRaw != null) {
      prefs.remove(_legacyStorageKey);
      try {
        final legacy = jsonDecode(legacyRaw) as Map<String, dynamic>;
        final membershipId = legacy['membershipId'];
        if (membershipId is String && membershipId.isNotEmpty) {
          return membershipId;
        }
      } on FormatException {
        // 손상된 레거시 데이터는 무시하고 새 멤버십 ID를 발급한다.
      }
    }
    return _generateMembershipId();
  }

  Future<void> _save(SharedPreferences prefs, PointsData data) async {
    await prefs.setString(_storageKey, jsonEncode(data.toJson()));
  }

  String _generateId() =>
      '${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(0xFFFF)}';

  String _generateMembershipId() {
    final random = Random();
    final digits = List.generate(8, (_) => random.nextInt(10)).join();
    return 'MEMBER-$digits';
  }
}
