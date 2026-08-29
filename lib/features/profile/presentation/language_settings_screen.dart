import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/locale_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';

class LanguageSettingsScreen extends ConsumerWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final selected = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsLanguageTitle)),
      body: ListView(
        padding: foxtrotListPadding,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              l10n.settingsLanguageSection,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          Card(
            margin: EdgeInsets.zero,
            child: RadioGroup<String>(
              // null은 라디오 값으로 쓸 수 없어 기기 설정을 빈 문자열로 둔다.
              groupValue: selected?.languageCode ?? '',
              onChanged: (value) {
                ref.read(localeProvider.notifier).select(decodeLocale(value));
              },
              child: Column(
                children: [
                  RadioListTile<String>(
                    value: '',
                    title: Text(l10n.settingsLanguageSystem),
                    subtitle: Text(l10n.settingsLanguageSystemDescription),
                  ),
                  for (final locale in supportedLocales)
                    RadioListTile<String>(
                      value: locale.languageCode,
                      title: Text(localeName(locale)),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.settingsLanguageStoredOnThisDevice,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.settingsLanguageUnsupportedNotice,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
