import 'package:flutter_test/flutter_test.dart';

import 'package:cafe_app/features/beans/data/local_beans_repository.dart';
import 'package:cafe_app/features/beans/domain/bean_models.dart';

void main() {
  final repository = LocalBeansRepository();

  test('원두 목록을 불러온다', () async {
    final beans = await repository.loadBeans();

    expect(beans, isNotEmpty);
    final ids = beans.map((bean) => bean.id).toSet();
    expect(ids.length, beans.length);
  });

  test('원두 정보는 유효한 프로필과 가격을 가진다', () async {
    final beans = await repository.loadBeans();

    for (final bean in beans) {
      expect(bean.tastingNotes, isNotEmpty, reason: bean.id);
      expect(bean.recommendedBrews, isNotEmpty, reason: bean.id);
      expect(bean.acidity, inInclusiveRange(1, 5), reason: bean.id);
      expect(bean.body, inInclusiveRange(1, 5), reason: bean.id);
      expect(bean.sweetness, inInclusiveRange(1, 5), reason: bean.id);
      expect(bean.price200, greaterThan(0), reason: bean.id);
      expect(bean.price500, greaterThan(bean.price200), reason: bean.id);
    }
  });

  test('용량별 가격을 반환한다', () async {
    final beans = await repository.loadBeans();
    final bean = beans.first;

    expect(bean.priceOf(BeanWeight.g200), bean.price200);
    expect(bean.priceOf(BeanWeight.g500), bean.price500);
  });
}
