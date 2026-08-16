import 'package:flutter_test/flutter_test.dart';

import 'package:cafe_app/features/points/domain/membership_qr_token.dart';

void main() {
  final issuedAt = DateTime(2026, 8, 16, 10, 0);
  const membershipId = 'MEMBER-12345678';

  test('토큰을 디코딩하면 멤버십 ID가 나온다', () {
    final token = encodeMembershipQrToken(membershipId, now: issuedAt);

    expect(decodeMembershipQrToken(token, now: issuedAt), membershipId);
  });

  test('발급할 때마다 다른 토큰이 생성된다', () {
    final first = encodeMembershipQrToken(membershipId, now: issuedAt);
    final second = encodeMembershipQrToken(membershipId, now: issuedAt);

    expect(first, isNot(second));
  });

  test('3분 이내의 토큰은 유효하다', () {
    final token = encodeMembershipQrToken(membershipId, now: issuedAt);

    expect(
      decodeMembershipQrToken(
        token,
        now: issuedAt.add(const Duration(minutes: 2, seconds: 59)),
      ),
      membershipId,
    );
  });

  test('3분이 지난 토큰은 예외를 던진다', () {
    final token = encodeMembershipQrToken(membershipId, now: issuedAt);

    expect(
      () => decodeMembershipQrToken(
        token,
        now: issuedAt.add(const Duration(minutes: 3, seconds: 1)),
      ),
      throwsA(
        isA<FormatException>().having(
          (error) => error.message,
          'message',
          contains('만료'),
        ),
      ),
    );
  });

  test('서명이 변조된 토큰은 예외를 던진다', () {
    final token = encodeMembershipQrToken(membershipId, now: issuedAt);
    final parts = token.split('.');
    parts[4] = '0000000000000000';

    expect(
      () => decodeMembershipQrToken(parts.join('.'), now: issuedAt),
      throwsFormatException,
    );
  });

  test('형식이 다른 코드는 예외를 던진다', () {
    expect(
      () => decodeMembershipQrToken(membershipId, now: issuedAt),
      throwsFormatException,
    );
    expect(
      () => decodeMembershipQrToken('', now: issuedAt),
      throwsFormatException,
    );
  });
}
