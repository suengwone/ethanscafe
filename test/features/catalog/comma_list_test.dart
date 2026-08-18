import 'package:flutter_test/flutter_test.dart';

import 'package:cafe_app/features/catalog/domain/comma_list.dart';

void main() {
  group('쉼표 목록 파싱', () {
    test('앞뒤 공백을 버리고 나눈다', () {
      expect(parseCommaList('자몽, 자스민 , 흑설탕'), ['자몽', '자스민', '흑설탕']);
    });

    test('빈 항목은 버린다', () {
      expect(parseCommaList('자몽,,자스민,'), ['자몽', '자스민']);
      expect(parseCommaList(''), isEmpty);
      expect(parseCommaList('  ,  '), isEmpty);
    });
  });

  test('목록을 다시 한 줄로 되돌린다', () {
    expect(formatCommaList(['자몽', '자스민']), '자몽, 자스민');
    expect(formatCommaList(const []), '');
  });
}
