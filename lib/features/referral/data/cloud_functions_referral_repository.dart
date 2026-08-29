import 'package:cloud_functions/cloud_functions.dart';

import '../domain/referral_models.dart';
import '../domain/referral_repository.dart';

class CloudFunctionsReferralRepository implements ReferralRepository {
  CloudFunctionsReferralRepository({FirebaseFunctions? functions})
    : _functions = functions ?? FirebaseFunctions.instanceFor(region: _region);

  static const _region = 'asia-northeast3';
  static const issueCallableName = 'issueReferralCode';
  static const redeemCallableName = 'redeemReferralCode';

  final FirebaseFunctions _functions;

  @override
  Future<ReferralSummary> load() async {
    final result = await _call(issueCallableName, const {});
    return _summaryOf(result);
  }

  @override
  Future<ReferralRedeemResult> redeem(String code) async {
    final normalized = normalizeReferralCode(code);
    if (!isValidReferralCode(normalized)) {
      throw const ReferralException('초대 코드는 6자리입니다.');
    }
    final result = await _call(redeemCallableName, {'code': normalized});
    final summary = _summaryOf(
      Map<String, dynamic>.from(result['summary'] as Map? ?? const {}),
    );
    return ReferralRedeemResult(
      code: result['code'] as String? ?? normalized,
      reward: (result['reward'] as num? ?? referralRewardPoints).toInt(),
      balance: (result['balance'] as num? ?? 0).toInt(),
      summary: summary,
    );
  }

  Future<Map<String, dynamic>> _call(
    String name,
    Map<String, dynamic> payload,
  ) async {
    try {
      final result = await _functions.httpsCallable(name).call(payload);
      return Map<String, dynamic>.from(result.data as Map);
    } on FirebaseFunctionsException catch (error) {
      // 서버가 거절 사유를 한국어 문구로 돌려주므로 그대로 보여준다.
      throw ReferralException(error.message ?? '초대 코드를 처리하지 못했습니다.');
    }
  }

  ReferralSummary _summaryOf(Map<String, dynamic> data) => ReferralSummary(
    code: data['code'] as String? ?? '',
    invitedCount: (data['invitedCount'] as num? ?? 0).toInt(),
    earnedPoints: (data['earnedPoints'] as num? ?? 0).toInt(),
    redeemedCode: data['redeemedCode'] as String?,
    reward: (data['reward'] as num? ?? referralRewardPoints).toInt(),
    inviteLimit: (data['inviteLimit'] as num? ?? referralInviteLimit).toInt(),
  );
}
