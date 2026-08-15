import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cafe_app/features/coupon/data/local_coupons_repository.dart';
import 'package:cafe_app/features/points/data/local_points_repository.dart';
import 'package:cafe_app/features/stamp/data/local_stamp_admin_repository.dart';
import 'package:cafe_app/features/stamp/data/local_stamps_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late LocalStampsRepository stamps;
  late LocalPointsRepository points;
  late LocalCouponsRepository coupons;
  late LocalStampAdminRepository repository;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    stamps = LocalStampsRepository();
    points = LocalPointsRepository();
    coupons = LocalCouponsRepository();
    repository = LocalStampAdminRepository(stamps, points, coupons);
  });

  Future<String> membershipId() async => (await points.load()).membershipId;

  test('회원 QR로 스탬프를 적립한다', () async {
    final id = await membershipId();

    final result =
        await repository.earnByMembershipId(membershipId: id, cups: 2);

    expect(result.membershipId, id);
    expect(result.cups, 2);
    expect(result.count, 2);
    expect(result.totalEarned, 2);
    expect(result.rewardsIssued, 0);

    final data = await stamps.load();
    expect(data.count, 2);
    expect(data.history, hasLength(1));
    expect(data.history.first.cups, 2);
  });

  test('스탬프 10개를 채우면 무료 음료 쿠폰을 발급한다', () async {
    final id = await membershipId();
    final before = (await coupons.loadCoupons()).length;

    await repository.earnByMembershipId(membershipId: id, cups: 8);
    final result =
        await repository.earnByMembershipId(membershipId: id, cups: 3);

    expect(result.count, 1);
    expect(result.totalEarned, 11);
    expect(result.rewardsIssued, 1);

    final after = await coupons.loadCoupons();
    expect(after.length, before + 1);
    expect(
      after.where((coupon) => coupon.id.startsWith('stamp-reward-')),
      hasLength(1),
    );
  });

  test('등록되지 않은 회원 QR이면 예외를 던진다', () async {
    await points.load();

    expect(
      () => repository.earnByMembershipId(
        membershipId: 'MEMBER-00000000-INVALID',
        cups: 1,
      ),
      throwsFormatException,
    );
  });

  test('잔 수가 0 이하이면 예외를 던진다', () async {
    final id = await membershipId();

    expect(
      () => repository.earnByMembershipId(membershipId: id, cups: 0),
      throwsArgumentError,
    );
  });
}
