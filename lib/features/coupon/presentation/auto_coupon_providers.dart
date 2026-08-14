import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/presentation/account_providers.dart';
import '../../auth/presentation/auth_providers.dart';
import '../domain/auto_coupons.dart';
import 'coupons_providers.dart';

final autoCouponSetupProvider = FutureProvider<void>((ref) async {
  final user = ref.watch(authStateProvider).value;
  if (user == null) {
    return;
  }
  final profile = await ref.watch(accountProfileControllerProvider.future);
  final repository = ref.read(couponsRepositoryProvider);
  final now = ref.read(couponNowProvider);

  var issued = await repository.issueCoupon(
    buildWelcomeCoupon(uid: user.uid, now: now),
  );
  final birthdayCoupon = buildBirthdayCoupon(
    uid: user.uid,
    birthDate: profile.birthDate,
    now: now,
  );
  if (birthdayCoupon != null) {
    final birthdayIssued = await repository.issueCoupon(birthdayCoupon);
    issued = issued || birthdayIssued;
  }
  if (issued) {
    ref.invalidate(couponsControllerProvider);
  }
});
