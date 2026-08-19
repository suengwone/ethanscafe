import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cafe_app/features/store/data/firestore_stores_repository.dart';
import 'package:cafe_app/features/store/domain/store_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('storeFromFirestore', () {
    test('Firestore 문서 데이터를 CafeStore로 변환한다', () {
      final store = storeFromFirestore('macheon', {
        'name': '폭스트롯 마천점',
        'address': '서울 송파구 성내천로 189 1층',
        'phone': '010-7730-2388',
        'latitude': 37.501458,
        'longitude': 127.149322,
        'weekdayHours': '09:00 - 21:00',
        'weekendHours': '09:00 - 21:00',
        'services': ['핸드드립 바', '카카오페이'],
        'sortOrder': 2,
        'notice': '매월 셋째 주 월요일은 정기 휴무입니다.',
        'congestion': 'busy',
        'congestionUpdatedAt': Timestamp.fromDate(DateTime(2026, 8, 19, 15)),
      });

      expect(store.id, 'macheon');
      expect(store.name, '폭스트롯 마천점');
      expect(store.latitude, 37.501458);
      expect(store.services, ['핸드드립 바', '카카오페이']);
      expect(store.sortOrder, 2);
      expect(store.notice, '매월 셋째 주 월요일은 정기 휴무입니다.');
      expect(store.congestion, StoreCongestion.busy);
      expect(store.congestionUpdatedAt, DateTime(2026, 8, 19, 15));
    });

    test('정수형 좌표도 double로 변환한다', () {
      final store = storeFromFirestore('store-2', {
        'name': '테스트점',
        'latitude': 37,
        'longitude': 127,
      });

      expect(store.latitude, 37.0);
      expect(store.longitude, 127.0);
      expect(store.services, isEmpty);
      expect(store.sortOrder, 0);
      expect(store.notice, '');
      expect(store.congestion, StoreCongestion.unknown);
      expect(store.congestionUpdatedAt, isNull);
    });
  });

  group('storeToFirestore', () {
    final store = CafeStore(
      id: 'macheon',
      name: '폭스트롯 마천점',
      address: '서울 송파구 성내천로 189 1층',
      phone: '010-7730-2388',
      latitude: 37.501458,
      longitude: 127.149322,
      weekdayHours: '09:00 - 21:00',
      weekendHours: '09:00 - 21:00',
      services: ['핸드드립 바', '카카오페이'],
      sortOrder: 2,
      notice: '매월 셋째 주 월요일은 정기 휴무입니다.',
      congestion: StoreCongestion.busy,
      congestionUpdatedAt: DateTime(2026, 8, 19, 15),
    );

    test('매장을 Firestore 문서 데이터로 되돌린다', () {
      expect(storeToFirestore(store), {
        'name': '폭스트롯 마천점',
        'address': '서울 송파구 성내천로 189 1층',
        'phone': '010-7730-2388',
        'latitude': 37.501458,
        'longitude': 127.149322,
        'weekdayHours': '09:00 - 21:00',
        'weekendHours': '09:00 - 21:00',
        'services': ['핸드드립 바', '카카오페이'],
        'sortOrder': 2,
        'notice': '매월 셋째 주 월요일은 정기 휴무입니다.',
        'congestion': 'busy',
        'congestionUpdatedAt': Timestamp.fromDate(DateTime(2026, 8, 19, 15)),
      });
    });

    test('혼잡도를 올린 적이 없으면 시각을 비워 둔다', () {
      const never = CafeStore(
        id: 'store-2',
        name: '테스트점',
        address: '',
        phone: '',
        latitude: 37,
        longitude: 127,
        weekdayHours: '',
        weekendHours: '',
      );

      expect(storeToFirestore(never)['congestion'], 'unknown');
      expect(storeToFirestore(never)['congestionUpdatedAt'], isNull);
    });

    test('id는 문서 데이터에 넣지 않는다', () {
      expect(storeToFirestore(store), isNot(contains('id')));
    });

    test('되돌린 데이터를 다시 읽으면 같은 매장이 된다', () {
      expect(storeToFirestore(store), isNotEmpty);
      expect(storeFromFirestore('macheon', storeToFirestore(store)), store);
    });
  });
}
