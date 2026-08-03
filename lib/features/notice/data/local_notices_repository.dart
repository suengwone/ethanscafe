import '../domain/notice_models.dart';
import '../domain/notices_repository.dart';

class LocalNoticesRepository implements NoticesRepository {
  @override
  Future<List<Notice>> loadNotices() async {
    final notices = [..._notices]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return notices;
  }

  static final _notices = <Notice>[
    Notice(
      id: 'notice-augus-hours',
      title: '8월 영업시간 안내',
      body: '8월 한 달간 매일 오전 8시부터 오후 10시까지 운영합니다. '
          '광복절(8/15)은 정상 영업하며, 라스트 오더는 마감 30분 전입니다.',
      category: NoticeCategory.notice,
      createdAt: DateTime(2026, 8, 1, 10),
      isImportant: true,
    ),
    Notice(
      id: 'event-new-geisha',
      title: '니카라과 게이샤 출시 기념 시음회',
      body: '새로 입고된 니카라과 핀카 리브레 게이샤 출시를 기념해 '
          '8월 둘째 주 토요일 오후 2시에 무료 시음회를 진행합니다. '
          '드립 커피를 사랑하는 분들의 많은 참여 부탁드립니다.',
      category: NoticeCategory.event,
      createdAt: DateTime(2026, 7, 30, 14),
    ),
    Notice(
      id: 'benefit-points-double',
      title: '여름 시즌 포인트 2배 적립',
      body: '8월 31일까지 매장 결제 시 포인트가 기본 적립률의 2배로 적립됩니다. '
          '멤버십 QR을 꼭 제시해주세요.',
      category: NoticeCategory.benefit,
      createdAt: DateTime(2026, 7, 28, 9),
      isImportant: true,
    ),
    Notice(
      id: 'event-summer-menu',
      title: '여름 신메뉴 3종 출시',
      body: '수박 주스, 오렌지 몽블랑, 복숭아 아이스티까지 여름 한정 메뉴가 출시되었습니다. '
          '시원한 여름 음료와 함께 더위를 이겨보세요.',
      category: NoticeCategory.event,
      createdAt: DateTime(2026, 7, 15, 11),
    ),
    Notice(
      id: 'notice-roasting-day',
      title: '매주 화요일은 로스팅 데이',
      body: '매주 화요일 오전에는 로스팅 작업으로 원두 구매 대기 시간이 '
          '평소보다 길어질 수 있습니다. 양해 부탁드립니다.',
      category: NoticeCategory.notice,
      createdAt: DateTime(2026, 7, 7, 9),
    ),
    Notice(
      id: 'benefit-bean-subscription',
      title: '원두 정기구독 오픈 예정',
      body: '매주 갓 볶은 원두를 집으로 보내드리는 정기구독 서비스를 준비 중입니다. '
          '오픈 소식은 앱 알림으로 가장 먼저 알려드릴게요.',
      category: NoticeCategory.benefit,
      createdAt: DateTime(2026, 6, 25, 16),
    ),
  ];
}
