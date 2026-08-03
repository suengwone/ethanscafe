import 'package:cafe_app/features/notice/data/firestore_notices_repository.dart';
import 'package:cafe_app/features/notice/domain/notice_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('noticeFromFirestore', () {
    test('Firestore 문서 데이터를 Notice로 변환한다', () {
      final createdAt = DateTime(2026, 8, 1, 10);
      final notice = noticeFromFirestore('notice-1', {
        'title': '8월 영업시간 안내',
        'body': '매일 오전 8시부터 오후 10시까지 운영합니다.',
        'category': 'notice',
        'createdAt': Timestamp.fromDate(createdAt),
        'isImportant': true,
      });

      expect(notice.id, 'notice-1');
      expect(notice.title, '8월 영업시간 안내');
      expect(notice.category, NoticeCategory.notice);
      expect(notice.createdAt, createdAt);
      expect(notice.isImportant, isTrue);
    });

    test('알 수 없는 카테고리는 notice로 대체한다', () {
      final notice = noticeFromFirestore('notice-2', {
        'title': '테스트',
        'body': '본문',
        'category': 'unknown',
        'createdAt': '2026-07-01T09:00:00.000',
      });

      expect(notice.category, NoticeCategory.notice);
      expect(notice.isImportant, isFalse);
    });
  });
}
