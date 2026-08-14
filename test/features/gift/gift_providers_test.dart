import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cafe_app/features/beans/domain/bean_models.dart';
import 'package:cafe_app/features/gift/domain/gift_models.dart';
import 'package:cafe_app/features/gift/presentation/gift_providers.dart';

const _bean = Bean(
  id: 'ethiopia-yirgacheffe-aricha',
  name: '에티오피아 예가체프 아리차 에이미 G1',
  origin: '에티오피아',
  description: '테스트 설명',
  story: '테스트 스토리',
  roastLevel: RoastLevel.light,
  process: '워시드',
  tastingNotes: ['자스민'],
  acidity: 4,
  body: 2,
  sweetness: 3,
  recommendedBrews: ['핸드드립'],
  price200: 18000,
  price500: 38000,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  ProviderContainer createContainer() {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    return container;
  }

  test('선물 전송 시 목록 맨 앞에 추가된다', () async {
    final container = createContainer();
    await container.read(beanGiftsControllerProvider.future);

    final gift =
        await container.read(beanGiftsControllerProvider.notifier).sendGift(
              bean: _bean,
              weight: BeanWeight.g200,
              grind: GrindOption.espresso,
              quantity: 1,
              recipientName: '김선물',
              recipientPhone: '010-1234-5678',
              message: '맛있게 드세요',
            );

    final gifts = container.read(beanGiftsControllerProvider).value!;
    expect(gifts.single.id, gift.id);
    expect(gifts.single.unitPrice, 18000);
    expect(gifts.single.status, BeanGiftStatus.sent);
    expect(gifts.single.message, '맛있게 드세요');
  });
}
