import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'referral_models.freezed.dart';
part 'referral_models.g.dart';

/// 초대한 쪽과 초대받은 쪽이 각각 받는 포인트. 서버 값이 기준이며 여기 값은 안내용이다.
const int referralRewardPoints = 3000;

/// 한 회원이 초대 보상을 받을 수 있는 최대 인원.
const int referralInviteLimit = 10;

/// 코드를 불러주고 받아적는 일이 잦으므로 0/O, 1/I처럼 헷갈리는 글자는 뺀다.
const String referralCodeAlphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

const int referralCodeLength = 6;

/// 입력한 코드를 대문자로 맞추고 공백·구분 기호를 지운다.
String normalizeReferralCode(String value) =>
    value.toUpperCase().replaceAll(RegExp('[^A-Z0-9]'), '');

bool isValidReferralCode(String value) {
  final code = normalizeReferralCode(value);
  return code.length == referralCodeLength &&
      code.split('').every(referralCodeAlphabet.contains);
}

String newReferralCode([Random? random]) {
  final source = random ?? Random();
  return List.generate(
    referralCodeLength,
    (_) => referralCodeAlphabet[source.nextInt(referralCodeAlphabet.length)],
  ).join();
}

/// 초대 코드 사용이 거절된 이유. 사용자에게 그대로 보여준다.
class ReferralException implements Exception {
  const ReferralException(this.message);

  final String message;

  @override
  String toString() => message;
}

@freezed
abstract class ReferralSummary with _$ReferralSummary {
  const ReferralSummary._();

  const factory ReferralSummary({
    required String code,
    @Default(0) int invitedCount,
    @Default(0) int earnedPoints,
    String? redeemedCode,
    @Default(referralRewardPoints) int reward,
    @Default(referralInviteLimit) int inviteLimit,
  }) = _ReferralSummary;

  factory ReferralSummary.fromJson(Map<String, dynamic> json) =>
      _$ReferralSummaryFromJson(json);

  bool get hasRedeemed => redeemedCode != null && redeemedCode!.isNotEmpty;

  int get remainingInvites => max(0, inviteLimit - invitedCount);
}

@freezed
abstract class ReferralRedeemResult with _$ReferralRedeemResult {
  const factory ReferralRedeemResult({
    required String code,
    required int reward,
    required int balance,
    required ReferralSummary summary,
  }) = _ReferralRedeemResult;

  factory ReferralRedeemResult.fromJson(Map<String, dynamic> json) =>
      _$ReferralRedeemResultFromJson(json);
}
