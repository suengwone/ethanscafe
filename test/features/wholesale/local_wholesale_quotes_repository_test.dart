import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cafe_app/features/wholesale/data/local_wholesale_quotes_repository.dart';
import 'package:cafe_app/features/wholesale/domain/wholesale_models.dart';

void main() {
  late LocalWholesaleQuotesRepository repository;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repository = LocalWholesaleQuotesRepository();
  });

  const items = [
    WholesaleQuoteItem(
      beanId: 'peru-el-babaco-bourbon',
      beanName: '페루 엘 바바코 버번',
      kg: 10,
      pricePerKg: 43000,
    ),
  ];

  test('최초 로드 시 빈 견적 목록을 반환한다', () async {
    final quotes = await repository.load();

    expect(quotes, isEmpty);
  });

  test('견적 요청 시 회사명과 금액이 기록된다', () async {
    final quote = await repository.submitQuote(
      companyName: ' 카페 어라운드 ',
      items: items,
      memo: ' 매주 월요일 납품 희망 ',
    );

    expect(quote.id, isNotEmpty);
    expect(quote.companyName, '카페 어라운드');
    expect(quote.memo, '매주 월요일 납품 희망');
    expect(quote.status, WholesaleQuoteStatus.requested);
    expect(quote.totalKg, 10);
    expect(quote.totalAmount, 430000);
  });

  test('회사명이 없으면 견적을 요청할 수 없다', () async {
    expect(
      () => repository.submitQuote(companyName: '  ', items: items),
      throwsArgumentError,
    );
  });

  test('원두가 없으면 견적을 요청할 수 없다', () async {
    expect(
      () => repository.submitQuote(companyName: '카페', items: const []),
      throwsArgumentError,
    );
  });

  test('수량이 0 이하면 견적을 요청할 수 없다', () async {
    expect(
      () => repository.submitQuote(
        companyName: '카페',
        items: const [
          WholesaleQuoteItem(
            beanId: 'x',
            beanName: 'x',
            kg: 0,
            pricePerKg: 1000,
          ),
        ],
      ),
      throwsArgumentError,
    );
  });

  test('견적이 로컬에 영속화되고 최신순으로 쌓인다', () async {
    await repository.submitQuote(companyName: '첫 번째 카페', items: items);
    final second =
        await repository.submitQuote(companyName: '두 번째 카페', items: items);

    final reloaded = await LocalWholesaleQuotesRepository().load();

    expect(reloaded, hasLength(2));
    expect(reloaded.first.id, second.id);
    expect(reloaded.first.companyName, '두 번째 카페');
  });
}
