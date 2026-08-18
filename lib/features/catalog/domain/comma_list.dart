/// 쉼표로 구분한 한 줄 입력과 문자열 목록 사이를 오간다.
///
/// 테이스팅 노트나 추천 추출법처럼 항목이 몇 개뿐인 목록은 별도 편집 UI를 두는 것보다
/// 한 줄에 쉼표로 적는 편이 빠르다. 빈 항목과 앞뒤 공백은 버린다.
List<String> parseCommaList(String text) {
  return text
      .split(',')
      .map((value) => value.trim())
      .where((value) => value.isNotEmpty)
      .toList();
}

String formatCommaList(List<String> values) => values.join(', ');
