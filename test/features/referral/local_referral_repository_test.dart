import 'dart:convert';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cafe_app/features/points/data/local_points_repository.dart';
import 'package:cafe_app/features/referral/data/local_referral_repository.dart';
import 'package:cafe_app/features/referral/domain/referral_models.dart';

void main() {
  late LocalReferralRepository repository;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repository = LocalReferralRepository(random: Random(7));
  });

  test('최초 로드 시 초대 코드를 발급하고 저장한다', () async {
    final summary = await repository.load();
    final prefs = await SharedPreferences.getInstance();

    expect(isValidReferralCode(summary.code), isTrue);
    expect(summary.invitedCount, 0);
    expect(summary.earnedPoints, 0);
    expect(summary.hasRedeemed, isFalse);
    expect(
      jsonDecode(prefs.getString('referral_summary')!),
      containsPair('code', summary.code),
    );
  });

  test('다시 로드해도 같은 코드를 쓴다', () async {
    final first = await repository.load();
    final second = await LocalReferralRepository().load();

    expect(second.code, first.code);
  });

  test('코드를 입력하면 보상 포인트가 적립된다', () async {
    final points = LocalPointsRepository();
    final repository = LocalReferralRepository(pointsRepository: points);
    await repository.load();

    final result = await repository.redeem('abc-234');
    final pointsData = await points.load();

    expect(result.code, 'ABC234');
    expect(result.reward, referralRewardPoints);
    expect(result.balance, referralRewardPoints);
    expect(result.summary.redeemedCode, 'ABC234');
    expect(result.summary.earnedPoints, referralRewardPoints);
    expect(
      pointsData.history.first.description,
      LocalReferralRepository.redeemDescription,
    );
    expect(pointsData.history.first.isEarn, isTrue);
  });

  test('형식이 맞지 않는 코드는 거부한다', () async {
    await repository.load();

    expect(() => repository.redeem('ABC12'), throwsA(isA<ReferralException>()));
  });

  test('본인 코드는 사용할 수 없다', () async {
    final summary = await repository.load();

    expect(
      () => repository.redeem(summary.code),
      throwsA(
        isA<ReferralException>().having(
          (error) => error.message,
          'message',
          contains('본인의 초대 코드'),
        ),
      ),
    );
  });

  test('코드는 한 번만 입력할 수 있다', () async {
    await repository.load();
    await repository.redeem('ABC234');

    expect(
      () => repository.redeem('XYZ789'),
      throwsA(
        isA<ReferralException>().having(
          (error) => error.message,
          'message',
          contains('한 번만'),
        ),
      ),
    );
  });
}
