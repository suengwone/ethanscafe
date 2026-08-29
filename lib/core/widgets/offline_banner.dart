import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../l10n/app_localizations.dart';
import '../services/connectivity_providers.dart';
import '../theme/app_theme.dart';

/// 앱 전체를 감싸 오프라인일 때 상단에 안내 줄을 띄운다.
/// 연결 상태를 아직 모르면 배너를 띄우지 않는다.
class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(isOnlineProvider).value ?? true;

    return Material(
      color: context.palette.background,
      child: Column(
        children: [
          if (!isOnline) const _OfflineBar(),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _OfflineBar extends StatelessWidget {
  const _OfflineBar();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        width: double.infinity,
        color: context.palette.danger,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.wifiOff, size: 16, color: context.palette.onAccent),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.of(context).offlineBanner,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: context.palette.onAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
