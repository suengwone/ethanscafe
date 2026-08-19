import '../domain/store_models.dart';
import '../domain/stores_repository.dart';

class LocalStoresRepository implements StoresRepository {
  @override
  Future<List<CafeStore>> loadStores() async => _stores;

  static const _stores = <CafeStore>[
    CafeStore(
      id: 'macheon',
      name: '폭스트롯 마천점',
      address: '서울 송파구 성내천로 189 1층 (마천동)',
      phone: '010-7730-2388',
      latitude: 37.501458,
      longitude: 127.149322,
      weekdayHours: '09:00 - 21:00',
      weekendHours: '09:00 - 21:00',
      services: ['핸드드립 바', '카카오페이', '제로페이'],
    ),
    CafeStore(
      id: 'pangyo',
      name: '폭스트롯 판교테크노밸리점',
      address: '경기 성남시 분당구 판교역로 230 삼환하이펙스 B동 1층 114호',
      phone: '0502-5553-5036',
      latitude: 37.401221,
      longitude: 127.110935,
      weekdayHours: '08:00 - 18:30',
      weekendHours: '10:00 - 19:00',
      services: ['무료주차 2시간', '반려견 동반', '테라스', '장애인 시설'],
      notice: '매월 셋째 주 월요일은 정기 휴무입니다.',
    ),
  ];
}
