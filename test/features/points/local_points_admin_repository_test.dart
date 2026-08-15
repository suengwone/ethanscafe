import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cafe_app/features/points/data/local_points_admin_repository.dart';
import 'package:cafe_app/features/points/data/local_points_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late LocalPointsRepository points;
  late LocalPointsAdminRepository repository;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    points = LocalPointsRepository();
    repository = LocalPointsAdminRepository(points);
  });

  Future<String> membershipId() async => (await points.load()).membershipId;

  test('회원 QR로 결제 금액의 10%를 적립한다', () async {
    final id = await membershipId();

    final result = await repository.earnByMembershipId(
      membershipId: id,
      paymentAmount: 12000,
    );

    expect(result.membershipId, id);
    expect(result.paymentAmount, 12000);
    expect(result.earned, 1200);
    expect(result.balance, 1200);

    final data = await points.load();
    expect(data.balance, 1200);
    expect(data.history, hasLength(1));
    expect(data.history.first.paymentAmount, 12000);
    expect(data.history.first.description, '매장 결제');
  });

  test('적립이 누적된다', () async {
    final id = await membershipId();

    await repository.earnByMembershipId(membershipId: id, paymentAmount: 5500);
    final result = await repository.earnByMembershipId(
      membershipId: id,
      paymentAmount: 4500,
    );

    expect(result.earned, 450);
    expect(result.balance, 550 + 450);
  });

  test('등록되지 않은 회원 QR이면 예외를 던진다', () async {
    await points.load();

    expect(
      () => repository.earnByMembershipId(
        membershipId: 'MEMBER-00000000-INVALID',
        paymentAmount: 1000,
      ),
      throwsFormatException,
    );
  });

  test('결제 금액이 0 이하이면 예외를 던진다', () async {
    final id = await membershipId();

    expect(
      () => repository.earnByMembershipId(membershipId: id, paymentAmount: 0),
      throwsArgumentError,
    );
  });
}
