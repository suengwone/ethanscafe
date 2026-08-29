import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../data/firestore_stores_repository.dart';
import '../data/local_stores_repository.dart';
import '../domain/location_failure.dart';
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

/// 서버가 진행 중인 주문으로 잰 매장별 혼잡도. 직원이 올린 값이 없을 때 쓴다.
/// 집계를 못 읽어도 매장 정보는 그대로 떠야 하므로 화면은 실패를 무시한다.
final storeActivityProvider =
    FutureProvider<Map<String, StoreActivity>>((ref) {
  return ref.watch(storesRepositoryProvider).loadActivity();
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
        throw const LocationUnavailable(LocationFailure.serviceOff);
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw const LocationUnavailable(LocationFailure.permissionDenied);
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
