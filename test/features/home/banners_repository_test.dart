import 'package:cafe_app/features/home/data/firestore_banners_repository.dart';
import 'package:cafe_app/features/home/data/local_banners_repository.dart';
import 'package:cafe_app/features/home/domain/banner_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LocalBannersRepository', () {
    test('기본 배너 3개를 반환한다', () async {
      final banners = await LocalBannersRepository().loadBanners();

      expect(banners, hasLength(3));
      expect(banners.first.title, '여름 시즌 신메뉴 출시');
      expect(banners.map((banner) => banner.icon), [
        'snowflake',
        'bean',
        'gift',
      ]);
    });
  });

  group('bannerFromFirestore', () {
    test('Firestore 문서 데이터를 EventBanner로 변환한다', () {
      final banner = bannerFromFirestore('banner-1', {
        'title': '친구 초대 이벤트',
        'subtitle': '친구를 초대하면 3,000P를 드려요',
        'icon': 'gift',
        'sortOrder': 3,
      });

      expect(banner.id, 'banner-1');
      expect(banner.title, '친구 초대 이벤트');
      expect(banner.icon, 'gift');
      expect(banner.sortOrder, 3);
    });

    test('icon이 없으면 sparkles를 사용하고 순서는 0으로 둔다', () {
      final banner = bannerFromFirestore('banner-2', {
        'title': '이벤트',
        'subtitle': '설명',
      });

      expect(banner.icon, 'sparkles');
      expect(banner.sortOrder, 0);
    });
  });

  group('bannerToFirestore', () {
    test('배너를 Firestore 문서 데이터로 되돌린다', () {
      const banner = EventBanner(
        id: 'banner-1',
        title: '친구 초대 이벤트',
        subtitle: '친구를 초대하면 3,000P를 드려요',
        icon: 'gift',
        sortOrder: 3,
      );

      expect(bannerToFirestore(banner), {
        'title': '친구 초대 이벤트',
        'subtitle': '친구를 초대하면 3,000P를 드려요',
        'icon': 'gift',
        'sortOrder': 3,
      });
    });

    test('id는 문서 데이터에 넣지 않는다', () {
      const banner = EventBanner(id: 'banner-1', title: '', subtitle: '');

      expect(bannerToFirestore(banner), isNot(contains('id')));
    });

    // 목록 조회가 sortOrder로 정렬하므로, 필드가 빠진 문서는 홈에서 아예 보이지 않는다.
    test('새 배너도 sortOrder를 반드시 함께 쓴다', () {
      const banner = EventBanner(id: '', title: '새 배너', subtitle: '');

      expect(bannerToFirestore(banner), containsPair('sortOrder', 0));
    });
  });
}
