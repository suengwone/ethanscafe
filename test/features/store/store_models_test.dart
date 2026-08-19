import 'package:flutter_test/flutter_test.dart';

import 'package:cafe_app/features/store/domain/store_models.dart';

void main() {
  const store = CafeStore(
    id: 'macheon',
    name: '폭스트롯 마천점',
    address: '서울 송파구 성내천로 189 1층',
    phone: '010-7730-2388',
    latitude: 37.501458,
    longitude: 127.149322,
    weekdayHours: '09:00 - 21:00',
    weekendHours: '10:00 - 18:00',
  );

  group('StoreHours.parse', () {
    test('여는 시각과 닫는 시각을 분으로 읽는다', () {
      final hours = StoreHours.parse('09:00 - 21:30')!;

      expect(hours.openMinutes, 9 * 60);
      expect(hours.closeMinutes, 21 * 60 + 30);
      expect(hours.isOvernight, isFalse);
    });

    test('물결표와 공백 차이를 견딘다', () {
      expect(StoreHours.parse(' 8:00~18:30 ')!.openMinutes, 8 * 60);
    });

    test('해석할 수 없는 문자열은 null이다', () {
      expect(StoreHours.parse(''), isNull);
      expect(StoreHours.parse('연중무휴'), isNull);
      expect(StoreHours.parse('09:00'), isNull);
      expect(StoreHours.parse('09:70 - 21:00'), isNull);
    });
  });

  group('StoreHours.isOpenAt', () {
    final hours = StoreHours.parse('09:00 - 21:00')!;

    test('영업시간 안이면 열려 있다', () {
      expect(hours.isOpenAt(DateTime(2026, 8, 19, 9)), isTrue);
      expect(hours.isOpenAt(DateTime(2026, 8, 19, 20, 59)), isTrue);
    });

    test('마감 시각과 그 뒤는 닫혀 있다', () {
      expect(hours.isOpenAt(DateTime(2026, 8, 19, 21)), isFalse);
      expect(hours.isOpenAt(DateTime(2026, 8, 19, 8, 59)), isFalse);
    });

    test('자정을 넘겨 닫는 매장은 새벽에도 열려 있다', () {
      final overnight = StoreHours.parse('21:00 - 02:00')!;

      expect(overnight.isOvernight, isTrue);
      expect(overnight.isOpenAt(DateTime(2026, 8, 19, 23)), isTrue);
      expect(overnight.isOpenAt(DateTime(2026, 8, 19, 1, 30)), isTrue);
      expect(overnight.isOpenAt(DateTime(2026, 8, 19, 3)), isFalse);
    });
  });

  group('CafeStore.hoursOn', () {
    test('평일은 평일 영업시간을 쓴다', () {
      expect(store.hoursOn(DateTime(2026, 8, 19)), '09:00 - 21:00');
    });

    test('토요일과 일요일은 주말 영업시간을 쓴다', () {
      expect(store.hoursOn(DateTime(2026, 8, 22)), '10:00 - 18:00');
      expect(store.hoursOn(DateTime(2026, 8, 23)), '10:00 - 18:00');
    });
  });

  group('CafeStore.isOpenAt', () {
    test('요일에 맞는 영업시간으로 판단한다', () {
      // 토요일 19시 — 평일 기준이면 열려 있지만 주말은 18시에 닫는다.
      expect(store.isOpenAt(DateTime(2026, 8, 22, 19)), isFalse);
      expect(store.isOpenAt(DateTime(2026, 8, 21, 19)), isTrue);
    });

    test('영업시간을 해석할 수 없으면 단정하지 않는다', () {
      const unknown = CafeStore(
        id: 'x',
        name: '테스트점',
        address: '',
        phone: '',
        latitude: 0,
        longitude: 0,
        weekdayHours: '',
        weekendHours: '',
      );

      expect(unknown.isOpenAt(DateTime(2026, 8, 19, 12)), isNull);
    });
  });

  group('CafeStore.congestionAt', () {
    final now = DateTime(2026, 8, 19, 15);

    test('방금 올린 혼잡도는 그대로 보여 준다', () {
      final busy = store.copyWith(
        congestion: StoreCongestion.busy,
        congestionUpdatedAt: now.subtract(const Duration(minutes: 20)),
      );

      expect(busy.congestionAt(now), StoreCongestion.busy);
    });

    test('오래된 혼잡도는 정보 없음으로 낮춘다', () {
      final stale = store.copyWith(
        congestion: StoreCongestion.busy,
        congestionUpdatedAt: now.subtract(const Duration(hours: 4)),
      );

      expect(stale.congestionAt(now), StoreCongestion.unknown);
    });

    test('올린 시각이 없으면 정보 없음이다', () {
      final noStamp = store.copyWith(congestion: StoreCongestion.relaxed);

      expect(noStamp.congestionAt(now), StoreCongestion.unknown);
    });
  });
}
