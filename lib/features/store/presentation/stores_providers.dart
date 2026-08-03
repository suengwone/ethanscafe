import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../data/local_stores_repository.dart';
import '../domain/store_models.dart';
import '../domain/stores_repository.dart';

final storesRepositoryProvider = Provider<StoresRepository>((ref) {
  return LocalStoresRepository();
});

final storesProvider = FutureProvider<List<CafeStore>>((ref) {
  return ref.watch(storesRepositoryProvider).loadStores();
});

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
