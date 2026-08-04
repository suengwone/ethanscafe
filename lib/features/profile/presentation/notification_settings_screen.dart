import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../auth/presentation/auth_providers.dart';
import '../data/firestore_notification_settings_repository.dart';
import '../data/local_notification_settings_repository.dart';
import '../domain/notification_settings.dart';

final notificationSettingsRepositoryProvider =
    Provider<NotificationSettingsRepository>((ref) {
  try {
    if (Firebase.apps.isNotEmpty) {
      final user = ref.watch(authStateProvider).value;
      if (user != null) {
        return FirestoreNotificationSettingsRepository(uid: user.uid);
      }
    }
  } catch (_) {}
  return LocalNotificationSettingsRepository();
});

final notificationSettingsProvider = AsyncNotifierProvider<
    NotificationSettingsController,
    NotificationSettings>(NotificationSettingsController.new);

class NotificationSettingsController
    extends AsyncNotifier<NotificationSettings> {
  @override
  Future<NotificationSettings> build() {
    return ref.watch(notificationSettingsRepositoryProvider).load();
  }

  Future<void> updateSettings(
    NotificationSettings Function(NotificationSettings) updater,
  ) async {
    final current = state.asData?.value ?? const NotificationSettings();
    final updated = updater(current);
    state = AsyncData(updated);
    await ref.read(notificationSettingsRepositoryProvider).save(updated);
  }
}

class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(notificationSettingsProvider);
    final controller = ref.read(notificationSettingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('알림 설정')),
      body: settingsState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('알림 설정을 불러오지 못했습니다.'),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () =>
                    ref.invalidate(notificationSettingsProvider),
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
        data: (settings) => ListView(
          padding: foxtrotListPadding,
          children: [
            _SettingsSection(
              title: '푸시 알림',
              children: [
                SwitchListTile(
                  title: const Text('앱 푸시 알림'),
                  subtitle: const Text('주문 상태, 매장 소식 등 전체 알림'),
                  value: settings.pushEnabled,
                  onChanged: (value) => controller.updateSettings(
                    (s) => s.copyWith(pushEnabled: value),
                  ),
                ),
              ],
            ),
            _SettingsSection(
              title: '알림 항목',
              children: [
                SwitchListTile(
                  title: const Text('이벤트 소식'),
                  subtitle: const Text('신메뉴 출시, 시음회 등 이벤트 알림'),
                  value: settings.eventEnabled,
                  onChanged: settings.pushEnabled
                      ? (value) => controller.updateSettings(
                            (s) => s.copyWith(eventEnabled: value),
                          )
                      : null,
                ),
                SwitchListTile(
                  title: const Text('포인트 적립/사용'),
                  subtitle: const Text('포인트 변동 내역 알림'),
                  value: settings.pointsEnabled,
                  onChanged: settings.pushEnabled
                      ? (value) => controller.updateSettings(
                            (s) => s.copyWith(pointsEnabled: value),
                          )
                      : null,
                ),
                SwitchListTile(
                  title: const Text('마케팅 정보 수신'),
                  subtitle: const Text('할인 쿠폰, 프로모션 정보 알림'),
                  value: settings.marketingEnabled,
                  onChanged: settings.pushEnabled
                      ? (value) => controller.updateSettings(
                            (s) => s.copyWith(marketingEnabled: value),
                          )
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(title, style: Theme.of(context).textTheme.titleSmall),
        ),
        Card(
          margin: EdgeInsets.zero,
          child: Column(children: children),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
