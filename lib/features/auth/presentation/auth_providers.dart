import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/firebase_auth_repository.dart';
import '../data/unavailable_auth_repository.dart';
import '../domain/auth_models.dart';
import '../domain/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  try {
    if (Firebase.apps.isNotEmpty) {
      return FirebaseAuthRepository();
    }
  } catch (_) {}
  return const UnavailableAuthRepository();
});

final authStateProvider = StreamProvider<AppUser?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
});

final authControllerProvider =
    AsyncNotifierProvider<AuthController, void>(AuthController.new);

class AuthController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> signInWith(AuthProviderType provider) async {
    final repository = ref.read(authRepositoryProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => repository.signInWith(provider));
    return !state.hasError;
  }

  Future<void> signOut() async {
    final repository = ref.read(authRepositoryProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(repository.signOut);
  }
}
