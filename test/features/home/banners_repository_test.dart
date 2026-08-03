import 'package:cafe_app/features/home/data/firestore_banners_repository.dart';
import 'package:cafe_app/features/home/data/local_banners_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LocalBannersRepository', () {
    test('기본 배너 3개를 반환한다', () async {
      final banners = await LocalBannersRepository().loadBanners();

      expect(banners, hasLength(3));
      expect(banners.first.title, '여름 시즌 신메뉴 출시');
      expect(banners.map((banner) => banner.icon),
          ['snowflake', 'bean', 'gift']);
    });
  });

  group('bannerFromFirestore', () {
    test('Firestore 문서 데이터를 EventBanner로 변환한다', () {
      final banner = bannerFromFirestore('banner-1', {
        'title': '친구 초대 이벤트',
        'subtitle': '친구를 초대하면 3,000P를 드려요',
        'icon': 'gift',
      });

      expect(banner.id, 'banner-1');
      expect(banner.title, '친구 초대 이벤트');
      expect(banner.icon, 'gift');
    });

    test('icon이 없으면 sparkles를 사용한다', () {
      final banner = bannerFromFirestore('banner-2', {
        'title': '이벤트',
        'subtitle': '설명',
      });

      expect(banner.icon, 'sparkles');
    });
  });
}
