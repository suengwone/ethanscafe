import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_theme.dart';

class GuestSignupNoticeCard extends StatelessWidget {
  const GuestSignupNoticeCard({
    super.key,
    this.message = '비회원으로 주문할 수 있어요.\n포인트 적립은 회원가입 후 이용할 수 있어요.',
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
        side: const BorderSide(color: foxtrotGold),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
        child: Row(
          children: [
            const Icon(LucideIcons.userPlus, size: 20, color: foxtrotGold),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            TextButton(
              onPressed: () => context.push('/login'),
              child: const Text('로그인'),
            ),
          ],
        ),
      ),
    );
  }
}
