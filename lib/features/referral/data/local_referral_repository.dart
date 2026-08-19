import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import '../../points/data/local_points_repository.dart';
import '../domain/referral_models.dart';
import '../domain/referral_repository.dart';

/// Firebase 없이 도는 화면(테스트·프리뷰)용 구현.
/// 상대방이 없으므로 초대받은 쪽 보상만 이 기기에 적립한다.
class LocalReferralRepository implements ReferralRepository {
  LocalReferralRepository({
    LocalPointsRepository? pointsRepository,
    Random? random,
  })  : _pointsRepository = pointsRepository ?? LocalPointsRepository(),
        _random = random ?? Random();

  static const _storageKey = 'referral_summary';
  static const redeemDescription = '초대 코드 입력 보상';

  final LocalPointsRepository _pointsRepository;
  final Random _random;

  @override
  Future<ReferralSummary> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw != null) {
      return ReferralSummary.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    }

    final summary = ReferralSummary(code: newReferralCode(_random));
    await _save(prefs, summary);
    return summary;
  }

  @override
  Future<ReferralRedeemResult> redeem(String code) async {
    final normalized = normalizeReferralCode(code);
    if (!isValidReferralCode(normalized)) {
      throw const ReferralException('초대 코드는 6자리입니다.');
    }

    final prefs = await SharedPreferences.getInstance();
    final summary = await load();
    if (normalized == summary.code) {
      throw const ReferralException('본인의 초대 코드는 사용할 수 없습니다.');
    }
    if (summary.hasRedeemed) {
      throw const ReferralException('초대 코드는 한 번만 입력할 수 있습니다.');
    }

    final points = await _pointsRepository.award(
      amount: summary.reward,
      description: redeemDescription,
    );
    final redeemed = summary.copyWith(
      redeemedCode: normalized,
      earnedPoints: summary.earnedPoints + summary.reward,
    );
    await _save(prefs, redeemed);

    return ReferralRedeemResult(
      code: normalized,
      reward: summary.reward,
      balance: points.balance,
      summary: redeemed,
    );
  }

  Future<void> _save(SharedPreferences prefs, ReferralSummary summary) async {
    await prefs.setString(_storageKey, jsonEncode(summary.toJson()));
  }
}
