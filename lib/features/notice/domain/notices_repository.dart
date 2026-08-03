import 'notice_models.dart';

abstract class NoticesRepository {
  Future<List<Notice>> loadNotices();
}
