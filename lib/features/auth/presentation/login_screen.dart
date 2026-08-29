import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/foxtrot_logo.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/auth_models.dart';
import 'auth_providers.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  Future<void> _signIn(
    BuildContext context,
    WidgetRef ref,
    AuthProviderType provider,
  ) async {
    final success = await ref
        .read(authControllerProvider.notifier)
        .signInWith(provider);
    if (!context.mounted) {
      return;
    }
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).authSignedIn)),
      );
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authControllerProvider, (previous, next) {
      final error = next.error;
      if (error != null && !next.isLoading) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(error.toString())));
      }
    });

    final l10n = AppLocalizations.of(context);
    final isLoading = ref.watch(authControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.authSignIn)),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const FoxtrotLogo(size: 112),
              const SizedBox(height: 24),
              Text(
                l10n.appTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'NOT FAST. JUST BETTER.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 28),
              _SocialLoginButton(
                onPressed: isLoading
                    ? null
                    : () => _signIn(context, ref, AuthProviderType.kakao),
                backgroundColor: const Color(0xFFFEE500),
                icon: const Icon(LucideIcons.messageCircle600, size: 22),
                label: l10n.authSignInWithKakao,
                textColor: Colors.black87,
              ),
              const SizedBox(height: 12),
              _SocialLoginButton(
                onPressed: isLoading
                    ? null
                    : () => _signIn(context, ref, AuthProviderType.naver),
                backgroundColor: const Color(0xFF03C75A),
                icon: const Text(
                  'N',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                label: l10n.authSignInWithNaver,
                textColor: Colors.white,
              ),
              const SizedBox(height: 12),
              _SocialLoginButton(
                onPressed: isLoading
                    ? null
                    : () => _signIn(context, ref, AuthProviderType.google),
                backgroundColor: Colors.white,
                icon: const Text(
                  'G',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
                label: l10n.authSignInWithGoogle,
                textColor: Colors.black87,
                borderColor: context.palette.border,
              ),
              const SizedBox(height: 24),
              if (isLoading)
                const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: CircularProgressIndicator(),
                ),
              TextButton(
                onPressed: isLoading ? null : () => context.go('/'),
                child: Text(l10n.authSignInLater),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialLoginButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Widget icon;
  final String label;
  final Color textColor;
  final Color? borderColor;

  const _SocialLoginButton({
    required this.onPressed,
    required this.backgroundColor,
    required this.icon,
    required this.label,
    required this.textColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
            side: borderColor != null
                ? BorderSide(color: borderColor!)
                : BorderSide.none,
          ),
        ),
        icon: icon,
        label: Text(label, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
