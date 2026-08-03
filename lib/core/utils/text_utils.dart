const String _wordJoiner = '\u2060';

extension KeepWordBreak on String {
  /// 단어 중간 줄바꿈을 막아 어절(공백) 단위로만 줄바꿈되도록 만든다.
  String get keepWord {
    if (length < 2) {
      return this;
    }
    final buffer = StringBuffer();
    for (var i = 0; i < length; i++) {
      final current = this[i];
      buffer.write(current);
      if (i + 1 < length &&
          current.trim().isNotEmpty &&
          this[i + 1].trim().isNotEmpty) {
        buffer.write(_wordJoiner);
      }
    }
    return buffer.toString();
  }
}
