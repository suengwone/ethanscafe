import 'package:cafe_app/features/notification/presentation/notification_labels.dart';
import 'package:cafe_app/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  final l10n = lookupAppLocalizations(const Locale('ko'));
  final now = DateTime(2026, 8, 30, 10);

  setUpAll(() async {
    await initializeDateFormatting('ko');
  });

  test('막 도착한 알림은 방금 전으로 적는다', () {
    expect(
      l10n.notificationTimeLabel(
        now.subtract(const Duration(seconds: 20)),
        now,
      ),
      '방금 전',
    );
  });

  test('한 시간 안쪽은 분으로, 하루 안쪽은 시간으로 적는다', () {
    expect(
      l10n.notificationTimeLabel(now.subtract(const Duration(minutes: 3)), now),
      '3분 전',
    );
    expect(
      l10n.notificationTimeLabel(now.subtract(const Duration(hours: 5)), now),
      '5시간 전',
    );
  });

  test('일주일 안쪽은 날짜 수로 적는다', () {
    expect(
      l10n.notificationTimeLabel(now.subtract(const Duration(days: 6)), now),
      '6일 전',
    );
  });

  test('일주일이 넘으면 날짜로 적는다', () {
    expect(
      l10n.notificationTimeLabel(DateTime(2026, 8, 1, 9), now),
      '2026.08.01',
    );
  });
}
