import 'referral_models.dart';

abstract class ReferralRepository {
  /// 내 초대 코드와 초대 현황을 가져온다. 코드가 없으면 발급받는다.
  Future<ReferralSummary> load();

  /// 친구에게 받은 초대 코드를 입력한다.
  Future<ReferralRedeemResult> redeem(String code);
}
