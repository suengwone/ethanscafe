import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cafe_app/core/theme/app_theme.dart';
import 'package:cafe_app/features/catalog/presentation/catalog_admin_providers.dart';
import 'package:cafe_app/features/catalog/presentation/notice_edit_screen.dart';
import 'package:cafe_app/features/notice/domain/notice_models.dart';

import 'fake_catalog_admin_repository.dart';

import '../../support/localized_app.dart';

void main() {
  late FakeCatalogAdminRepository repository;

  final notice = Notice(
    id: 'notice-1',
    title: '8월 영업시간 안내',
    body: '8월 한 달간 매일 오전 8시부터 오후 10시까지 운영합니다.',
    category: NoticeCategory.notice,
    createdAt: DateTime(2026, 8, 1, 10),
    isImportant: true,
  );

  setUp(() => repository = FakeCatalogAdminRepository());

  Future<void> pumpScreen(WidgetTester tester, {Notice? notice}) async {
    // 본문 칸이 커서 기본 화면 높이로는 ListView가 저장 버튼을 만들지 않는다.
    tester.view.physicalSize = const Size(1200, 3000);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          catalogAdminRepositoryProvider.overrideWithValue(repository),
        ],
        child: MaterialApp(
          locale: testLocale,
          localizationsDelegates: testLocalizationsDelegates,
          supportedLocales: testSupportedLocales,
          theme: buildAppTheme(),
          home: NoticeEditScreen(notice: notice),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('제목과 본문이 비어 있으면 저장하지 않는다', (tester) async {
    await pumpScreen(tester);

    await tester.tap(find.text('등록'));
    await tester.pumpAndSettle();

    expect(find.text('제목을 입력해 주세요.'), findsOneWidget);
    expect(find.text('본문을 입력해 주세요.'), findsOneWidget);
    expect(repository.savedNotice, isNull);
  });

  testWidgets('새 공지는 빈 id로 저장해 서버가 문서를 새로 만들게 한다', (tester) async {
    await pumpScreen(tester);

    await tester.enterText(find.byType(TextFormField).at(0), '추석 연휴 휴무 안내');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      '9월 16일부터 사흘간 쉽니다.',
    );
    await tester.tap(find.text('등록'));
    await tester.pumpAndSettle();

    final saved = repository.savedNotice;
    expect(saved?.id, '');
    expect(saved?.title, '추석 연휴 휴무 안내');
    expect(saved?.body, '9월 16일부터 사흘간 쉽니다.');
    // 새 공지는 분류 기본값 '공지'로, 중요 표시 없이 오늘 날짜로 올라간다.
    expect(saved?.category, NoticeCategory.notice);
    expect(saved?.isImportant, isFalse);
    expect(saved?.createdAt.day, DateTime.now().day);
  });

  testWidgets('기존 공지를 고치면 id와 게시일을 유지한 채 저장한다', (tester) async {
    await pumpScreen(tester, notice: notice);

    expect(find.text('2026.08.01'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), '8월 영업시간 변경');
    await tester.tap(find.text('저장'));
    await tester.pumpAndSettle();

    expect(repository.savedNotice?.id, 'notice-1');
    expect(repository.savedNotice?.title, '8월 영업시간 변경');
    expect(repository.savedNotice?.createdAt, DateTime(2026, 8, 1, 10));
    expect(repository.savedNotice?.isImportant, isTrue);
  });

  testWidgets('분류와 중요 표시를 바꿔 저장한다', (tester) async {
    await pumpScreen(tester, notice: notice);

    await tester.tap(find.byType(DropdownButtonFormField<NoticeCategory>));
    await tester.pumpAndSettle();
    await tester.tap(find.text(NoticeCategory.event.label).last);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(SwitchListTile));
    await tester.pumpAndSettle();
    await tester.tap(find.text('저장'));
    await tester.pumpAndSettle();

    expect(repository.savedNotice?.category, NoticeCategory.event);
    expect(repository.savedNotice?.isImportant, isFalse);
  });

  testWidgets('게시일을 바꾸면 그 날짜로 저장한다', (tester) async {
    await pumpScreen(tester, notice: notice);

    await tester.tap(find.text('날짜 선택'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('5'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('확인'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('저장'));
    await tester.pumpAndSettle();

    // 날짜만 바뀌고 시각은 그대로 남는다.
    expect(repository.savedNotice?.createdAt, DateTime(2026, 8, 5, 10));
  });

  testWidgets('내리기는 확인을 받은 뒤에만 삭제한다', (tester) async {
    await pumpScreen(tester, notice: notice);

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();
    await tester.tap(find.text('닫기'));
    await tester.pumpAndSettle();

    expect(repository.deletedNoticeId, isNull);

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();
    await tester.tap(find.text('공지 내리기'));
    await tester.pumpAndSettle();

    expect(repository.deletedNoticeId, 'notice-1');
  });
}
