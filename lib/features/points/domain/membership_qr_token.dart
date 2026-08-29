import 'dart:convert';
import 'dart:math';

import 'membership_qr_failure.dart';

const Duration membershipQrValidity = Duration(minutes: 3);
const Duration membershipQrRefreshInterval = Duration(minutes: 1);

const String _tokenPrefix = 'MQR1';
const String _tokenSalt = 'foxtrot-membership-qr';

// FNV-1a 64비트. 웹(JS)은 정수가 double이라 64비트 리터럴을 표현하지 못하므로
// BigInt로 계산해 네이티브와 같은 결과를 낸다.
final BigInt _fnvOffsetBasis = BigInt.parse('cbf29ce484222325', radix: 16);
final BigInt _fnvPrime = BigInt.parse('100000001b3', radix: 16);
final BigInt _fnv64Mask = BigInt.parse('ffffffffffffffff', radix: 16);

String _signature(String payload) {
  var hash = _fnvOffsetBasis;
  for (final unit in utf8.encode('$_tokenSalt.$payload')) {
    hash ^= BigInt.from(unit);
    hash = (hash * _fnvPrime) & _fnv64Mask;
  }
  return hash.toRadixString(16).padLeft(16, '0');
}

String encodeMembershipQrToken(
  String membershipId, {
  DateTime? now,
  int? nonce,
}) {
  final issuedAt = now ?? DateTime.now();
  final expiresAt = issuedAt.add(membershipQrValidity).millisecondsSinceEpoch;
  final resolvedNonce = nonce ?? Random().nextInt(0xFFFFFFFF);
  final encodedId = base64Url.encode(utf8.encode(membershipId));
  final payload = '$encodedId.$expiresAt.$resolvedNonce';
  return '$_tokenPrefix.$payload.${_signature(payload)}';
}

String decodeMembershipQrToken(String code, {DateTime? now}) {
  final parts = code.trim().split('.');
  if (parts.length != 5 || parts[0] != _tokenPrefix) {
    throw const MembershipQrException(MembershipQrFailure.malformed);
  }

  final payload = '${parts[1]}.${parts[2]}.${parts[3]}';
  final expiresAt = int.tryParse(parts[2]);
  if (expiresAt == null || parts[4] != _signature(payload)) {
    throw const MembershipQrException(MembershipQrFailure.malformed);
  }

  final current = now ?? DateTime.now();
  if (current.millisecondsSinceEpoch > expiresAt) {
    throw const MembershipQrException(MembershipQrFailure.expired);
  }

  try {
    return utf8.decode(base64Url.decode(parts[1]));
  } on FormatException {
    throw const MembershipQrException(MembershipQrFailure.malformed);
  }
}
