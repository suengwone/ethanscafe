import '../domain/store_models.dart';
import '../domain/stores_repository.dart';

class LocalStoresRepository implements StoresRepository {
  @override
  Future<List<CafeStore>> loadStores() async => _stores;

  static const _stores = <CafeStore>[
    CafeStore(
      id: 'seongsu',
      name: "Ethan's Cafe 성수점",
      address: '서울 성동구 연무장길 47 1층',
      phone: '02-1234-5678',
      latitude: 37.5445,
      longitude: 127.0561,
      weekdayHours: '08:00 - 22:00',
      weekendHours: '10:00 - 22:00',
      services: ['로스팅 랩', '원두 판매', '주차 가능'],
    ),
    CafeStore(
      id: 'yeonnam',
      name: "Ethan's Cafe 연남점",
      address: '서울 마포구 동교로 252-1',
      phone: '02-2345-6789',
      latitude: 37.5622,
      longitude: 126.9256,
      weekdayHours: '09:00 - 21:00',
      weekendHours: '09:00 - 22:00',
      services: ['핸드드립 바', '디저트 베이킹'],
    ),
    CafeStore(
      id: 'pangyo',
      name: "Ethan's Cafe 판교점",
      address: '경기 성남시 분당구 판교역로 235 B1',
      phone: '031-3456-7890',
      latitude: 37.3947,
      longitude: 127.1112,
      weekdayHours: '07:30 - 21:00',
      weekendHours: '10:00 - 20:00',
      services: ['테이크아웃 전용', '원두 판매'],
    ),
  ];
}
