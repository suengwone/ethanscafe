import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:cafe_app/features/beans/domain/bean_models.dart';
import 'package:cafe_app/features/wholesale/domain/wholesale_models.dart';

void main() {
  const bean = WholesaleBean(
    id: 'peru-el-babaco-bourbon',
    name: '페루 엘 바바코 버번',
    origin: '페루 카하마르카',
    roastLevel: RoastLevel.medium,
    process: '워시드',
    tastingNotes: ['토피', '감귤류'],
    minOrderKg: 5,
    tiers: [
      WholesalePriceTier(minKg: 5, pricePerKg: 46000),
      WholesalePriceTier(minKg: 10, pricePerKg: 43000),
      WholesalePriceTier(minKg: 30, pricePerKg: 39000),
    ],
  );

  group('WholesaleBean', () {
    test('기본 단가는 첫 구간 단가다', () {
      expect(bean.basePricePerKg, 46000);
    });

    test('주문량에 따라 구간별 도매 단가가 적용된다', () {
      expect(bean.unitPriceFor(5), 46000);
      expect(bean.unitPriceFor(9), 46000);
      expect(bean.unitPriceFor(10), 43000);
      expect(bean.unitPriceFor(29), 43000);
      expect(bean.unitPriceFor(30), 39000);
      expect(bean.unitPriceFor(100), 39000);
    });

    test('총액은 적용 단가 × 수량이다', () {
      expect(bean.totalPriceFor(10), 430000);
    });
  });

  group('WholesaleQuote', () {
    final quote = WholesaleQuote(
      id: 'quote-1',
      companyName: '카페 어라운드',
      items: const [
        WholesaleQuoteItem(
          beanId: 'peru-el-babaco-bourbon',
          beanName: '페루 엘 바바코 버번',
          kg: 10,
          pricePerKg: 43000,
        ),
        WholesaleQuoteItem(
          beanId: 'brazil-monte-belo-yellow-bourbon',
          beanName: '브라질 몬테 벨로 옐로우버본',
          kg: 5,
          pricePerKg: 37000,
        ),
      ],
      createdAt: DateTime(2026, 8, 10),
    );

    test('총 수량과 예상 금액을 계산한다', () {
      expect(quote.totalKg, 15);
      expect(quote.totalAmount, 430000 + 185000);
    });

    test('요약은 첫 원두와 전체 건수를 들고 있다', () {
      // 문구("외 1건")는 언어를 타므로 화면이 붙인다.
      expect(quote.firstItemName, '페루 엘 바바코 버번');
      expect(quote.items, hasLength(2));
      expect(quote.copyWith(items: [quote.items.first]).items, hasLength(1));
    });

    test('json 직렬화 왕복이 가능하다', () {
      final restored = WholesaleQuote.fromJson(
        jsonDecode(jsonEncode(quote.toJson())) as Map<String, dynamic>,
      );

      expect(restored, quote);
    });
  });
}
