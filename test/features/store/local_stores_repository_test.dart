import 'package:flutter_test/flutter_test.dart';

import 'package:cafe_app/features/store/data/local_stores_repository.dart';

void main() {
  final repository = LocalStoresRepository();

  test('매장 목록이 비어있지 않다', () async {
    final stores = await repository.loadStores();

    expect(stores, isNotEmpty);
  });

  test('매장 id는 중복되지 않는다', () async {
    final stores = await repository.loadStores();
    final ids = stores.map((store) => store.id).toSet();

    expect(ids.length, stores.length);
  });

  test('모든 매장은 유효한 좌표를 가진다', () async {
    final stores = await repository.loadStores();

    for (final store in stores) {
      expect(store.latitude, inInclusiveRange(-90, 90));
      expect(store.longitude, inInclusiveRange(-180, 180));
    }
  });
}
