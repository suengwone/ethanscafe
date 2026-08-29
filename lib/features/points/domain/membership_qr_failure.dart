/// 회원 QR을 읽지 못한 까닭.
///
/// 토큰을 푸는 곳에는 BuildContext가 없어 읽는 사람의 언어를 알 수 없다.
/// 까닭만 올려 보내고 문구는 스캔 화면이 자기 l10n에서 고른다.
enum MembershipQrFailure { malformed, expired }

class MembershipQrException implements Exception {
  const MembershipQrException(this.reason);

  final MembershipQrFailure reason;
}
