import 'package:cafe_app/features/beans/data/firestore_beans_repository.dart';
import 'package:cafe_app/features/beans/domain/bean_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('beanFromFirestore', () {
    test('Firestore 문서 데이터를 Bean으로 변환한다', () {
      final bean = beanFromFirestore('bean-1', {
        'name': '에티오피아 예가체프',
        'origin': '에티오피아',
        'description': '화사한 과일 향',
        'story': '예가체프 아리차 스테이션의 내추럴 로트입니다.',
        'roastLevel': 'light',
        'process': '내추럴',
        'tastingNotes': ['스트로베리', '피치'],
        'acidity': 5,
        'body': 2,
        'sweetness': 5,
        'recommendedBrews': ['핸드드립'],
        'price200': 14000,
        'price500': 30000,
        'isNew': true,
      });

      expect(bean.id, 'bean-1');
      expect(bean.name, '에티오피아 예가체프');
      expect(bean.roastLevel, RoastLevel.light);
      expect(bean.tastingNotes, ['스트로베리', '피치']);
      expect(bean.price200, 14000);
      expect(bean.isNew, isTrue);
    });

    test('알 수 없는 roastLevel은 medium으로 대체한다', () {
      final bean = beanFromFirestore('bean-2', {
        'name': '테스트',
        'roastLevel': 'unknown',
      });

      expect(bean.roastLevel, RoastLevel.medium);
      expect(bean.isNew, isFalse);
      expect(bean.tastingNotes, isEmpty);
    });
  });
}
