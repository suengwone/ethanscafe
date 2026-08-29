import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cafe_app/features/profile/data/local_notification_settings_repository.dart';
import 'package:cafe_app/features/profile/domain/notification_settings.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('저장된 값이 없으면 기본 설정을 반환한다', () async {
    final repository = LocalNotificationSettingsRepository();

    final settings = await repository.load();

    expect(settings.pushEnabled, isTrue);
    expect(settings.eventEnabled, isTrue);
    expect(settings.pointsEnabled, isTrue);
    expect(settings.marketingEnabled, isFalse);
  });

  test('설정을 저장하면 다시 불러올 수 있다', () async {
    final repository = LocalNotificationSettingsRepository();

    await repository.save(
      const NotificationSettings(pushEnabled: false, marketingEnabled: true),
    );

    final settings = await repository.load();
    expect(settings.pushEnabled, isFalse);
    expect(settings.eventEnabled, isTrue);
    expect(settings.marketingEnabled, isTrue);
  });
}
