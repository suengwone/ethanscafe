import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/remote_config_providers.dart';
import '../theme/app_theme.dart';
import 'foxtrot_logo.dart';

/// 원격 최소 지원 버전보다 낮은 앱이면 사용을 막고 업데이트 안내를 띄운다.
class UpdateGate extends ConsumerWidget {
  const UpdateGate({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(isUpdateRequiredProvider)) {
      return child;
    }
    final config = ref.watch(remoteAppConfigProvider).value;
    return UpdateRequiredView(storeUrl: config?.storeUrl ?? '');
  }
}

class UpdateRequiredView extends StatelessWidget {
  const UpdateRequiredView({super.key, this.storeUrl = ''});

  final String storeUrl;

  Future<void> _openStore() async {
    final uri = Uri.tryParse(storeUrl.trim());
    if (uri == null) {
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasStoreUrl = storeUrl.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: foxtrotBlack,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const FoxtrotLogo(size: 96),
                const SizedBox(height: 32),
                Text(
                  '업데이트가 필요합니다',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: foxtrotCream,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  '더 안전하고 편리한 이용을 위해\n최신 버전으로 업데이트해 주세요.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: foxtrotMuted,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (hasStoreUrl) ...[
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _openStore,
                      child: const Text('업데이트하러 가기'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
