import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cafe_app/features/beans/domain/bean_models.dart';
import 'package:cafe_app/features/gift/data/local_bean_gifts_repository.dart';
import 'package:cafe_app/features/gift/domain/gift_models.dart';

void main() {
  late LocalBeanGiftsRepository repository;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repository = LocalBeanGiftsRepository();
  });

  Future<BeanGift> sendGift({
    String recipientName = '김선물',
    String recipientPhone = '010-1234-5678',
    String message = '',
    int quantity = 1,
  }) {
    return repository.sendGift(
      beanId: 'ethiopia-yirgacheffe-aricha',
      beanName: '에티오피아 예가체프 아리차 에이미 G1',
      weight: BeanWeight.g200,
      grind: GrindOption.wholeBean,
      quantity: quantity,
      unitPrice: 18000,
      recipientName: recipientName,
      recipientPhone: recipientPhone,
      message: message,
    );
  }

  test('최초 로드 시 빈 선물 목록을 반환한다', () async {
    final gifts = await repository.load();

    expect(gifts, isEmpty);
  });

  test('선물 전송 시 받는 분 정보와 금액이 기록된다', () async {
    final gift = await sendGift(message: ' 생일 축하해! ', quantity: 2);

    expect(gift.id, isNotEmpty);
    expect(gift.recipientName, '김선물');
    expect(gift.recipientPhone, '010-1234-5678');
    expect(gift.message, '생일 축하해!');
    expect(gift.totalPrice, 36000);
    expect(gift.status, BeanGiftStatus.sent);
    expect(gift.optionLabel, '200g · 홀빈');
    expect(gift.summary, '에티오피아 예가체프 아리차 에이미 G1 2개');
  });

  test('받는 분 이름이 없으면 선물할 수 없다', () async {
    expect(() => sendGift(recipientName: '  '), throwsArgumentError);
  });

  test('받는 분 연락처가 없으면 선물할 수 없다', () async {
    expect(() => sendGift(recipientPhone: ''), throwsArgumentError);
  });

  test('선물이 로컬에 영속화되고 최신순으로 쌓인다', () async {
    await sendGift();
    final second = await sendGift(recipientName: '박원두');

    final reloaded = await LocalBeanGiftsRepository().load();

    expect(reloaded, hasLength(2));
    expect(reloaded.first.id, second.id);
    expect(reloaded.first.recipientName, '박원두');
  });
}
