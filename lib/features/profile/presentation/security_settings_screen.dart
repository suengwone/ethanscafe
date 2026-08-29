import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/services/points_lock_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';

class SecuritySettingsScreen extends ConsumerWidget {
  const SecuritySettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final enabled = ref.watch(pointsLockEnabledProvider);
    final deviceLock = ref.watch(deviceLockAvailableProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.securitySettingsTitle)),
      body: ListView(
        padding: foxtrotListPadding,
        children: [
          Card(
            margin: EdgeInsets.zero,
            child: SwitchListTile(
              title: Text(l10n.securityPointsLockTitle),
              subtitle: Text(l10n.securityPointsLockDetail),
              value: enabled.value ?? true,
              onChanged: enabled.isLoading
                  ? null
                  : (value) => ref
                        .read(pointsLockEnabledProvider.notifier)
                        .setEnabled(value),
            ),
          ),
          const SizedBox(height: 12),
          // 잠금이 없는 기기에서는 스위치를 켜 둬도 확인이 일어나지 않는다.
          // 켜 뒀으니 지켜지겠거니 하고 두지 않도록 그 사실을 적어 둔다.
          if (deviceLock.value == false)
            _Note(icon: LucideIcons.info, text: l10n.securityNoDeviceLock),
          _Note(
            icon: LucideIcons.shieldCheck,
            text: l10n.securityPointsLockWhy,
          ),
        ],
      ),
    );
  }
}

class _Note extends StatelessWidget {
  const _Note({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: context.palette.muted),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}
