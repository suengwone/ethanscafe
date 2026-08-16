import 'dart:convert';
import 'dart:math';

const Duration membershipQrValidity = Duration(minutes: 3);

const String _tokenPrefix = 'MQR1';
const String _tokenSalt = 'foxtrot-membership-qr';

String _signature(String payload) {
  const int fnvPrime = 0x100000001b3;
  int hash = 0xcbf29ce484222325;
  for (final unit in utf8.encode('$_tokenSalt.$payload')) {
    hash ^= unit;
    hash = (hash * fnvPrime) & 0xFFFFFFFFFFFFFFFF;
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
    throw const FormatException('회원 QR 코드가 올바르지 않습니다.');
  }

  final payload = '${parts[1]}.${parts[2]}.${parts[3]}';
  final expiresAt = int.tryParse(parts[2]);
  if (expiresAt == null || parts[4] != _signature(payload)) {
    throw const FormatException('회원 QR 코드가 올바르지 않습니다.');
  }

  final current = now ?? DateTime.now();
  if (current.millisecondsSinceEpoch > expiresAt) {
    throw const FormatException('만료된 회원 QR 코드입니다. 갱신된 QR을 다시 스캔해주세요.');
  }

  try {
    return utf8.decode(base64Url.decode(parts[1]));
  } on FormatException {
    throw const FormatException('회원 QR 코드가 올바르지 않습니다.');
  }
}
