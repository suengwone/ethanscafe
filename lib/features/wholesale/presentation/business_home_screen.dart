import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/text_utils.dart';
import '../../../features/beans/presentation/bean_labels.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/presentation/account_providers.dart';
import '../../auth/presentation/auth_providers.dart';
import '../domain/wholesale_models.dart';
import 'wholesale_providers.dart';

final _priceFormat = NumberFormat('#,###');

class BusinessHomeScreen extends ConsumerWidget {
  const BusinessHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    final business =
        ref.watch(accountProfileControllerProvider).value?.business;
    final beansState = ref.watch(wholesaleBeansProvider);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          children: [
            _BusinessHeader(
              companyName:
                  business?.companyName ?? user?.displayLabel ?? '사업자 회원',
            ),
            const SizedBox(height: 20),
            const _WholesaleInfoCard(),
            const SizedBox(height: 16),
            const _BusinessQuickActions(),
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '도매 원두 리스트',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push('/wholesale/quote'),
                    child: const Text('견적 요청'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            beansState.when(
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, _) => const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: Text('도매 원두를 불러오지 못했습니다.')),
              ),
              data: (beans) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    for (final bean in beans) _WholesaleBeanCard(bean: bean),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _BusinessHeader extends StatelessWidget {
  const _BusinessHeader({required this.companyName});

  final String companyName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: context.palette.accent.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
                    border: Border.all(
                      color: context.palette.accent.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Text(
                    '사업자 회원',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: context.palette.accentSoft,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '$companyName님,\n좋은 거래 되세요!'.keepWord,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 6),
                Text(
                  '주문 후 로스팅한 신선한 원두를 도매가로 공급해 드려요'.keepWord,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          _CircleIconButton(
            icon: LucideIcons.mapPin,
            tooltip: '매장 찾기',
            onPressed: () => context.push('/stores'),
          ),
          const SizedBox(width: 8),
          _CircleIconButton(
            icon: LucideIcons.bell,
            tooltip: '알림',
            onPressed: () => context.push('/notices'),
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
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
          side: BorderSide(color: context.palette.border.withValues(alpha: 0.7)),
        ),
        minimumSize: const Size(40, 40),
      ),
      icon: Icon(icon, size: 18, color: context.palette.ink),
    );
  }
}

class _WholesaleInfoCard extends StatelessWidget {
  const _WholesaleInfoCard();

  static const _entries = [
    (LucideIcons.packageCheck, '최소 주문 5kg부터, 구간별 도매 단가 적용'),
    (LucideIcons.flame, '주문 확인 후 당일 로스팅 · 전국 2~3일 배송'),
    (LucideIcons.receiptText, '세금계산서 발행 · 정기 납품 계약 지원'),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('원두 도매 공급 안내', style: textTheme.titleMedium),
            const SizedBox(height: 12),
            for (final (icon, label) in _entries)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(icon, size: 16, color: context.palette.accent),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(label.keepWord, style: textTheme.bodySmall),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BusinessQuickActions extends StatelessWidget {
  const _BusinessQuickActions();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: const [
          _QuickActionItem(
            icon: LucideIcons.calculator,
            label: '견적 요청',
            location: '/wholesale/quote',
          ),
          SizedBox(width: 10),
          _QuickActionItem(
            icon: LucideIcons.fileText,
            label: '견적 내역',
            location: '/wholesale/quotes',
          ),
          SizedBox(width: 10),
          _QuickActionItem(
            icon: LucideIcons.store,
            label: '매장찾기',
            location: '/stores',
          ),
          SizedBox(width: 10),
          _QuickActionItem(
            icon: LucideIcons.headset,
            label: '고객센터',
            location: '/profile/support',
          ),
        ],
      ),
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  const _QuickActionItem({
    required this.icon,
    required this.label,
    required this.location,
  });

  final IconData icon;
  final String label;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: context.palette.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(foxtrotRadiusLarge),
          side: BorderSide(color: context.palette.border.withValues(alpha: 0.7)),
        ),
        child: InkWell(
          onTap: () => context.push(location),
          borderRadius: BorderRadius.circular(foxtrotRadiusLarge),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Column(
              children: [
                Icon(icon, size: 22, color: context.palette.accent),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.palette.ink,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WholesaleBeanCard extends StatelessWidget {
  const _WholesaleBeanCard({required this.bean});

  final WholesaleBean bean;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(bean.name.keepWord, style: textTheme.titleMedium),
                ),
                if (bean.isBest) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: context.palette.accent,
                      borderRadius: BorderRadius.circular(foxtrotRadiusSmall),
                    ),
                    child: Text(
                      'BEST',
                      style: TextStyle(
                        color: context.palette.onAccent,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${bean.origin} · '
                      '${AppLocalizations.of(context).roastLevelLabel(bean.roastLevel)} · '
                      '${bean.process}'
                  .keepWord,
              style: textTheme.bodySmall,
            ),
            const SizedBox(height: 6),
            Text(
              bean.tastingNotes.join(' · '),
              style: textTheme.bodySmall?.copyWith(color: context.palette.accentSoft),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: context.palette.surface,
                borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
                border: Border.all(color: context.palette.border),
              ),
              child: Text(
                bean.tiers
                    .map((tier) =>
                        '${tier.minKg}kg~ ${_priceFormat.format(tier.pricePerKg)}원')
                    .join('  ·  '),
                style: textTheme.bodySmall?.copyWith(color: context.palette.ink),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'kg당 ${_priceFormat.format(bean.basePricePerKg)}원~',
                        style: textTheme.titleMedium
                            ?.copyWith(color: context.palette.accent),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '최소 주문 ${bean.minOrderKg}kg',
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: () =>
                      context.push('/wholesale/quote?bean=${bean.id}'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 40),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: const Text('견적 담기'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
