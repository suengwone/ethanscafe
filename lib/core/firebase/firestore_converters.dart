import 'package:cloud_firestore/cloud_firestore.dart';

DateTime firestoreDateTime(Object? value) {
  if (value is Timestamp) {
    return value.toDate();
  }
  if (value is String) {
    return DateTime.parse(value);
  }
  if (value is DateTime) {
    return value;
  }
  throw FormatException('지원하지 않는 날짜 형식입니다: $value');
}

Map<String, dynamic> deepStringKeyedMap(Object? value) {
  return {
    for (final entry in (value as Map).entries)
      entry.key as String: _deepValue(entry.value),
  };
}

Object? _deepValue(Object? value) {
  if (value is Map) {
    return deepStringKeyedMap(value);
  }
  if (value is List) {
    return value.map(_deepValue).toList();
  }
  return value;
}
