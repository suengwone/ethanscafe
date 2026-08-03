import '../domain/banner_models.dart';
import '../domain/banners_repository.dart';

class LocalBannersRepository implements BannersRepository {
  static const _banners = <EventBanner>[
    EventBanner(
      id: 'summer-new-menu',
      title: '여름 시즌 신메뉴 출시',
      subtitle: '시원한 콜드브루와 함께 여름을 즐겨보세요',
      icon: 'snowflake',
    ),
    EventBanner(
      id: 'bean-subscription',
      title: '원두 정기 구독',
      subtitle: '매달 새로운 원두를 집에서 만나보세요',
      icon: 'bean',
    ),
    EventBanner(
      id: 'invite-friends',
      title: '친구 초대 이벤트',
      subtitle: '친구를 초대하면 3,000P를 드려요',
      icon: 'gift',
    ),
  ];

  @override
  Future<List<EventBanner>> loadBanners() async => _banners;
}
