import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../data/firestore_stores_repository.dart';
import '../data/local_stores_repository.dart';
import '../domain/store_models.dart';
import '../domain/stores_repository.dart';

final storesRepositoryProvider = Provider<StoresRepository>((ref) {
  try {
    if (Firebase.apps.isNotEmpty) {
      return FirestoreStoresRepository();
    }
  } catch (_) {}
  return LocalStoresRepository();
});

final storesProvider = FutureProvider<List<CafeStore>>((ref) {
  return ref.watch(storesRepositoryProvider).loadStores();
});

/// 영업 중 여부와 혼잡도 신선도를 재는 기준 시각.
/// 화면이 `DateTime.now()`를 직접 부르면 테스트·골든이 실행 시각에 따라 흔들려서
/// provider로 빼 두고 고정할 수 있게 한다.
final storeClockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

final storeDistancesProvider =
    AsyncNotifierProvider<StoreDistancesController, Map<String, double>?>(
        StoreDistancesController.new);

class StoreDistancesController extends AsyncNotifier<Map<String, double>?> {
  @override
  Future<Map<String, double>?> build() async => null;

  Future<void> refreshFromCurrentLocation() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw StateError('위치 서비스가 꺼져 있습니다. 설정에서 위치 서비스를 켜주세요.');
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw StateError('위치 권한이 없어 거리를 계산할 수 없습니다.');
      }

      final position = await Geolocator.getCurrentPosition();
      final stores = await ref.read(storesProvider.future);
      return {
        for (final store in stores)
          store.id: Geolocator.distanceBetween(
            position.latitude,
            position.longitude,
            store.latitude,
            store.longitude,
          ),
      };
    });
  }
}
