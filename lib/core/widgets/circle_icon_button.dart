import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// 홈 헤더에 놓이는 동그란 아이콘 버튼.
class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      style: IconButton.styleFrom(
        backgroundColor: context.palette.card,
        shape: CircleBorder(
          side: BorderSide(
            color: context.palette.border.withValues(alpha: 0.7),
          ),
        ),
        minimumSize: const Size(40, 40),
      ),
      icon: Icon(icon, size: 18, color: context.palette.ink),
    );
  }
}
