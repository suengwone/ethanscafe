import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../domain/auth_models.dart';
import 'auth_providers.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  Future<void> _signIn(
    BuildContext context,
    WidgetRef ref,
    AuthProviderType provider,
  ) async {
    final success =
        await ref.read(authControllerProvider.notifier).signInWith(provider);
    if (!context.mounted) {
      return;
    }
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인되었습니다.')),
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

    final isLoading = ref.watch(authControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.coffee,
              size: 100,
              color: Colors.brown,
            ),
            const SizedBox(height: 32),
            const Text(
              'Ethan\'s Cafe',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 48),
            _SocialLoginButton(
              onPressed: isLoading
                  ? null
                  : () => _signIn(context, ref, AuthProviderType.kakao),
              backgroundColor: const Color(0xFFFEE500),
              icon: Icons.chat_bubble,
              label: '카카오로 시작하기',
              textColor: Colors.black87,
            ),
            const SizedBox(height: 12),
            _SocialLoginButton(
              onPressed: isLoading
                  ? null
                  : () => _signIn(context, ref, AuthProviderType.google),
              backgroundColor: Colors.white,
              icon: Icons.g_mobiledata,
              label: '구글로 시작하기',
              textColor: Colors.black87,
              borderColor: Colors.grey.shade300,
            ),
            const SizedBox(height: 12),
            _SocialLoginButton(
              onPressed: isLoading
                  ? null
                  : () => _signIn(context, ref, AuthProviderType.apple),
              backgroundColor: Colors.black,
              icon: Icons.apple,
              label: 'Apple로 시작하기',
              textColor: Colors.white,
            ),
            const SizedBox(height: 24),
            if (isLoading)
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: CircularProgressIndicator(),
              ),
            TextButton(
              onPressed: isLoading ? null : () => context.go('/'),
              child: const Text('나중에 로그인하기'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialLoginButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final IconData icon;
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
            borderRadius: BorderRadius.circular(8),
            side: borderColor != null
                ? BorderSide(color: borderColor!)
                : BorderSide.none,
          ),
        ),
        icon: Icon(icon),
        label: Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
