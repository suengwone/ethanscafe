import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/firestore_account_repository.dart';
import '../data/local_account_repository.dart';
import '../domain/account_models.dart';
import '../domain/account_repository.dart';
import 'auth_providers.dart';

final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  try {
    if (Firebase.apps.isNotEmpty) {
      final user = ref.watch(authStateProvider).value;
      if (user != null) {
        return FirestoreAccountRepository(uid: user.uid);
      }
    }
  } catch (_) {}
  return LocalAccountRepository();
});

final accountProfileControllerProvider =
    AsyncNotifierProvider<AccountProfileController, AccountProfile>(
  AccountProfileController.new,
);

class AccountProfileController extends AsyncNotifier<AccountProfile> {
  @override
  Future<AccountProfile> build() {
    return ref.watch(accountRepositoryProvider).load();
  }

  Future<AccountProfile> registerBusiness(BusinessProfile business) async {
    final profile =
        await ref.read(accountRepositoryProvider).registerBusiness(business);
    state = AsyncValue.data(profile);
    return profile;
  }

  Future<AccountProfile> switchToCustomer() async {
    final profile =
        await ref.read(accountRepositoryProvider).switchToCustomer();
    state = AsyncValue.data(profile);
    return profile;
  }

  Future<AccountProfile> saveBirthDate(DateTime birthDate) async {
    final profile =
        await ref.read(accountRepositoryProvider).saveBirthDate(birthDate);
    state = AsyncValue.data(profile);
    return profile;
  }
}

final accountTypeProvider = Provider<AccountType>((ref) {
  return ref.watch(accountProfileControllerProvider).value?.type ??
      AccountType.customer;
});
