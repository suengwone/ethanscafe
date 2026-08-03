import 'package:flutter_test/flutter_test.dart';

import 'package:cafe_app/features/notice/data/local_notices_repository.dart';

void main() {
  final repository = LocalNoticesRepository();

  test('알림 목록이 비어있지 않다', () async {
    final notices = await repository.loadNotices();

    expect(notices, isNotEmpty);
  });

  test('알림은 최신순으로 정렬된다', () async {
    final notices = await repository.loadNotices();

    for (var i = 0; i < notices.length - 1; i++) {
      expect(
        notices[i].createdAt.isAfter(notices[i + 1].createdAt) ||
            notices[i].createdAt.isAtSameMomentAs(notices[i + 1].createdAt),
        isTrue,
      );
    }
  });

  test('알림 id는 중복되지 않는다', () async {
    final notices = await repository.loadNotices();
    final ids = notices.map((notice) => notice.id).toSet();

    expect(ids.length, notices.length);
  });
}
