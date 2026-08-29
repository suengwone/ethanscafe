import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/theme_mode_providers.dart';
import '../../../l10n/app_localizations.dart';

class AppearanceSettingsScreen extends ConsumerWidget {
  const AppearanceSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final mode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsAppearanceTitle)),
      body: ListView(
        padding: foxtrotListPadding,
        children: [
          const _ThemePreview(),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              l10n.settingsAppearanceThemeSection,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          Card(
            margin: EdgeInsets.zero,
            child: RadioGroup<ThemeMode>(
              groupValue: mode,
              onChanged: (value) {
                if (value != null) {
                  ref.read(themeModeProvider.notifier).select(value);
                }
              },
              child: Column(
                children: [
                  for (final option in ThemeMode.values)
                    RadioListTile<ThemeMode>(
                      value: option,
                      title: Text(l10n.themeModeLabel(option)),
                      subtitle: Text(l10n.themeModeDescription(option)),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.settingsAppearanceStoredOnThisDevice,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

/// 고른 테마가 실제로 어떤 색으로 보이는지 한눈에 보여 준다.
class _ThemePreview extends StatelessWidget {
  const _ThemePreview();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: palette.background,
        borderRadius: BorderRadius.circular(foxtrotRadiusLarge),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.settingsAppearancePreview, style: textTheme.titleSmall),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: palette.card,
              borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
              border: Border.all(color: palette.border.withValues(alpha: 0.7)),
            ),
            child: Row(
              children: [
                Icon(LucideIcons.coffee, size: 22, color: palette.accent),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.settingsAppearancePreviewRewards,
                        style: textTheme.titleMedium,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.settingsAppearancePreviewBalance,
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: palette.accent,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  l10n.settingsAppearancePreviewOrder,
                  style: textTheme.labelLarge?.copyWith(
                    color: palette.onAccent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: palette.border),
                ),
                child: Text(
                  l10n.settingsAppearancePreviewCart,
                  style: textTheme.labelLarge?.copyWith(color: palette.accent),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
