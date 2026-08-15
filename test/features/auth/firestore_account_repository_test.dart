import 'package:cafe_app/features/auth/data/firestore_account_repository.dart';
import 'package:cafe_app/features/auth/domain/account_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('accountProfileFromFirestore', () {
    test('Firestore 문서 데이터를 AccountProfile로 변환한다', () {
      final profile = accountProfileFromFirestore({
        'accountType': 'business',
        'business': {
          'companyName': '카페 어라운드',
          'businessNumber': '123-45-67890',
          'managerName': '김담당',
          'phone': '010-1234-5678',
        },
      });

      expect(profile.type, AccountType.business);
      expect(profile.business, isNotNull);
      expect(profile.business!.companyName, '카페 어라운드');
      expect(profile.business!.businessNumber, '123-45-67890');
    });

    test('중첩 business 맵이 Map<Object?, Object?> 타입이어도 파싱한다', () {
      final profile = accountProfileFromFirestore({
        'accountType': 'customer',
        'business': <Object?, Object?>{
          'companyName': '카페 어라운드',
          'businessNumber': '123-45-67890',
          'managerName': '김담당',
          'phone': '010-1234-5678',
        },
      });

      expect(profile.type, AccountType.customer);
      expect(profile.business, isNotNull);
      expect(profile.business!.companyName, '카페 어라운드');
      expect(profile.business!.businessNumber, '123-45-67890');
      expect(profile.business!.managerName, '김담당');
      expect(profile.business!.phone, '010-1234-5678');
    });

    test('business 필드가 없으면 null을 유지한다', () {
      final profile = accountProfileFromFirestore({
        'accountType': 'customer',
      });

      expect(profile.business, isNull);
    });
  });
}
