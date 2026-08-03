import 'banner_models.dart';

abstract class BannersRepository {
  Future<List<EventBanner>> loadBanners();
}
