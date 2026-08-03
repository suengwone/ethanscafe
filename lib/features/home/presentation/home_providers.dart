import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/firestore_banners_repository.dart';
import '../data/local_banners_repository.dart';
import '../domain/banner_models.dart';
import '../domain/banners_repository.dart';

final bannersRepositoryProvider = Provider<BannersRepository>((ref) {
  try {
    if (Firebase.apps.isNotEmpty) {
      return FirestoreBannersRepository();
    }
  } catch (_) {}
  return LocalBannersRepository();
});

final bannersProvider = FutureProvider<List<EventBanner>>((ref) {
  return ref.watch(bannersRepositoryProvider).loadBanners();
});
