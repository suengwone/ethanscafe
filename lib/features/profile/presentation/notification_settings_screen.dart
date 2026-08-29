import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
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

final notificationSettingsProvider =
    AsyncNotifierProvider<NotificationSettingsController, NotificationSettings>(
      NotificationSettingsController.new,
    );

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
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).notificationSettingsTitle),
      ),
      body: settingsState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(AppLocalizations.of(context).notificationLoadFailed),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.invalidate(notificationSettingsProvider),
                child: Text(AppLocalizations.of(context).retry),
              ),
            ],
          ),
        ),
        data: (settings) => ListView(
          padding: foxtrotListPadding,
          children: [
            _SettingsSection(
              title: AppLocalizations.of(context).notificationSectionPush,
              children: [
                SwitchListTile(
                  title: Text(AppLocalizations.of(context).notificationPushAll),
                  subtitle: Text(
                    AppLocalizations.of(context).notificationPushAllDetail,
                  ),
                  value: settings.pushEnabled,
                  onChanged: (value) => controller.updateSettings(
                    (s) => s.copyWith(pushEnabled: value),
                  ),
                ),
              ],
            ),
            _SettingsSection(
              title: AppLocalizations.of(context).notificationSectionTopics,
              children: [
                SwitchListTile(
                  title: Text(AppLocalizations.of(context).notificationEvents),
                  subtitle: Text(
                    AppLocalizations.of(context).notificationEventsDetail,
                  ),
                  value: settings.eventEnabled,
                  onChanged: settings.pushEnabled
                      ? (value) => controller.updateSettings(
                          (s) => s.copyWith(eventEnabled: value),
                        )
                      : null,
                ),
                SwitchListTile(
                  title: Text(AppLocalizations.of(context).notificationPoints),
                  subtitle: Text(
                    AppLocalizations.of(context).notificationPointsDetail,
                  ),
                  value: settings.pointsEnabled,
                  onChanged: settings.pushEnabled
                      ? (value) => controller.updateSettings(
                          (s) => s.copyWith(pointsEnabled: value),
                        )
                      : null,
                ),
                SwitchListTile(
                  title: Text(
                    AppLocalizations.of(context).notificationMarketing,
                  ),
                  subtitle: Text(
                    AppLocalizations.of(context).notificationMarketingDetail,
                  ),
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
