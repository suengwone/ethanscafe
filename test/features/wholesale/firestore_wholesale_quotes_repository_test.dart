import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cafe_app/features/wholesale/data/firestore_wholesale_quotes_repository.dart';
import 'package:cafe_app/features/wholesale/domain/wholesale_models.dart';

void main() {
  group('wholesaleQuotesFromFirestore', () {
    test('Timestamp를 포함한 문서를 변환한다', () {
      final createdAt = DateTime(2026, 8, 10, 9, 30);
      final quotes = wholesaleQuotesFromFirestore({
        'quotes': [
          {
            'id': 'quote-1',
            'companyName': '카페 어라운드',
            'items': [
              {
                'beanId': 'peru-el-babaco-bourbon',
                'beanName': '페루 엘 바바코 버번',
                'kg': 10,
                'pricePerKg': 43000,
              },
            ],
            'memo': '매주 월요일 납품 희망',
            'status': 'quoted',
            'createdAt': Timestamp.fromDate(createdAt),
          },
        ],
      });

      expect(quotes, hasLength(1));
      final quote = quotes.first;
      expect(quote.id, 'quote-1');
      expect(quote.companyName, '카페 어라운드');
      expect(quote.items.first.kg, 10);
      expect(quote.items.first.pricePerKg, 43000);
      expect(quote.memo, '매주 월요일 납품 희망');
      expect(quote.status, WholesaleQuoteStatus.quoted);
      expect(quote.createdAt, createdAt);
    });

    test('누락된 필드는 기본값으로 채운다', () {
      final quotes = wholesaleQuotesFromFirestore({
        'quotes': [
          {
            'id': 'quote-2',
            'createdAt': '2026-08-01T09:00:00.000',
          },
        ],
      });

      final quote = quotes.first;
      expect(quote.companyName, isEmpty);
      expect(quote.items, isEmpty);
      expect(quote.memo, isEmpty);
      expect(quote.status, WholesaleQuoteStatus.requested);
    });
  });

  test('wholesaleQuoteToFirestore는 왕복 변환이 가능하다', () {
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
      ],
      memo: '메모',
      status: WholesaleQuoteStatus.confirmed,
      createdAt: DateTime(2026, 8, 10, 9, 30),
    );

    final restored = wholesaleQuoteFromFirestore(
      wholesaleQuoteToFirestore(quote),
    );

    expect(restored, quote);
  });
}
