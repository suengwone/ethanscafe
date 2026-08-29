import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import 'auth_providers.dart';

/// 비회원이 주문·구독 같은 거래 흐름을 시작하면 왜 막혔는지 알려주고 로그인으로 안내한다.
/// 그냥 로그인 화면으로 튕기면 하던 작업이 사라진 것처럼 보여 혼란스럽다.
bool requireLogin(
  BuildContext context,
  WidgetRef ref, {
  required String message,
}) {
  // 스트림이 아직 첫 값을 흘리기 전이면 회원도 비회원으로 보이므로 저장소를 함께 확인한다.
  final user = ref.read(authStateProvider).value ??
      ref.read(authRepositoryProvider).currentUser;
  if (user != null) {
    return true;
  }
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: AppLocalizations.of(context).authSignIn,
          onPressed: () => context.push('/login'),
        ),
      ),
    );
  return false;
}
