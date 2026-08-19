import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'package:cafe_app/features/referral/domain/referral_models.dart';

void main() {
  test('입력한 코드는 대문자로 맞추고 구분 기호를 지운다', () {
    expect(normalizeReferralCode('fxp-2k9'), 'FXP2K9');
    expect(normalizeReferralCode(' ab c2 34 '), 'ABC234');
  });

  test('6자리가 아니거나 쓸 수 없는 글자가 있으면 잘못된 코드로 본다', () {
    expect(isValidReferralCode('FXP2K9'), isTrue);
    expect(isValidReferralCode('fxp2k9'), isTrue);
    expect(isValidReferralCode('ABC12'), isFalse);
    expect(isValidReferralCode('ABCD123'), isFalse);
    // 0(숫자)과 I는 헷갈려서 코드에 쓰지 않는다.
    expect(isValidReferralCode('ABC01D'), isFalse);
    expect(isValidReferralCode('ABCDIF'), isFalse);
  });

  test('발급한 코드는 헷갈리는 글자 없이 6자리다', () {
    final code = newReferralCode(Random(7));

    expect(code.length, referralCodeLength);
    expect(isValidReferralCode(code), isTrue);
    for (final letter in ['0', 'O', '1', 'I']) {
      expect(referralCodeAlphabet.contains(letter), isFalse);
    }
  });

  test('남은 초대 횟수는 한도를 넘어가면 0으로 멈춘다', () {
    const summary = ReferralSummary(code: 'FXP2K9', invitedCount: 3);

    expect(summary.remainingInvites, referralInviteLimit - 3);
    expect(
      const ReferralSummary(code: 'FXP2K9', invitedCount: 12).remainingInvites,
      0,
    );
  });

  test('입력한 코드가 있어야 사용 완료로 본다', () {
    expect(const ReferralSummary(code: 'FXP2K9').hasRedeemed, isFalse);
    expect(
      const ReferralSummary(code: 'FXP2K9', redeemedCode: '').hasRedeemed,
      isFalse,
    );
    expect(
      const ReferralSummary(code: 'FXP2K9', redeemedCode: 'ABC234')
          .hasRedeemed,
      isTrue,
    );
  });
}
