import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../core/theme/app_theme.dart';
import '../../auth/domain/auth_models.dart';
import '../../auth/presentation/auth_providers.dart';
import '../../coupon/presentation/coupons_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    await ref.read(authControllerProvider.notifier).signOut();
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('로그아웃되었습니다.')),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    final usableCouponCount = ref.watch(usableCouponCountProvider).value ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('내 정보'),
      ),
      body: ListView(
        children: [
          _ProfileHeader(user: user),
          const SizedBox(height: 8),
          _buildSection(
            context,
            '나의 활동',
            [
              _buildListTile(
                icon: LucideIcons.receiptText,
                title: '주문 내역',
                onTap: () => context.push('/profile/orders'),
              ),
              _buildListTile(
                icon: LucideIcons.ticket,
                title: '쿠폰함',
                trailing: usableCouponCount > 0
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: foxtrotGold,
                          borderRadius:
                              BorderRadius.circular(foxtrotRadiusMedium),
                        ),
                        child: Text(
                          '$usableCouponCount',
                          style: const TextStyle(
                            color: foxtrotBlack,
                            fontSize: 12,
                          ),
                        ),
                      )
                    : null,
                onTap: () => context.push('/profile/coupons'),
              ),
              _buildListTile(
                icon: LucideIcons.heart,
                title: '즐겨찾기 메뉴',
                onTap: () => context.push('/profile/favorites'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildSection(
            context,
            '설정',
            [
              _buildListTile(
                icon: LucideIcons.bell,
                title: '알림 설정',
                onTap: () => context.push('/profile/notifications'),
              ),
              _buildListTile(
                icon: LucideIcons.creditCard,
                title: '결제 수단 관리',
                onTap: () => context.push('/profile/payment-methods'),
              ),
              _buildListTile(
                icon: LucideIcons.mapPin,
                title: '배송지 관리',
                onTap: () => context.push('/profile/addresses'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildSection(
            context,
            '기타',
            [
              _buildListTile(
                icon: LucideIcons.circleQuestionMark,
                title: '고객센터',
                onTap: () => context.push('/profile/support'),
              ),
              _buildListTile(
                icon: LucideIcons.info,
                title: '이용약관',
                onTap: () => context.push('/profile/terms'),
              ),
              _buildListTile(
                icon: LucideIcons.shieldCheck,
                title: '개인정보처리방침',
                onTap: () => context.push('/profile/privacy'),
              ),
              _buildListTile(
                icon: LucideIcons.building2,
                title: '사업자 정보',
                onTap: () => _showBusinessInfo(context),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (user != null)
            _buildSection(
              context,
              '계정',
              [
                _buildListTile(
                  icon: LucideIcons.logOut,
                  title: '로그아웃',
                  textColor: Theme.of(context).colorScheme.error,
                  onTap: () => _signOut(context, ref),
                ),
              ],
            ),
          const SizedBox(height: 24),
          const Center(child: _AppVersionLabel()),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _showBusinessInfo(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: foxtrotCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const _BusinessInfoSheet(),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: foxtrotScreenHPadding,
            vertical: 8,
          ),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(
            horizontal: foxtrotScreenHPadding,
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    Widget? trailing,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor),
      title: Text(
        title,
        style: TextStyle(color: textColor),
      ),
      trailing: trailing ?? const Icon(LucideIcons.chevronRight, size: 18),
      onTap: onTap,
    );
  }
}

class _BusinessInfoSheet extends StatelessWidget {
  const _BusinessInfoSheet();

  static const _entries = [
    ('상호', "Ethan's Cafe"),
    ('대표자', '이단'),
    ('사업자등록번호', '123-45-67890'),
    ('주소', '서울 성동구 연무장길 47 1층'),
    ('대표번호', '02-1234-5678'),
    ('이메일', 'hello@ethanscafe.com'),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('사업자 정보', style: textTheme.titleLarge),
            const SizedBox(height: 16),
            for (final (label, value) in _entries)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 110,
                      child: Text(label, style: textTheme.bodySmall),
                    ),
                    Expanded(
                      child: Text(value, style: textTheme.bodyMedium),
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

class _AppVersionLabel extends StatelessWidget {
  const _AppVersionLabel();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        final version = snapshot.data?.version;
        return Text(
          version == null ? '앱 버전 확인 중...' : '앱 버전 $version',
          style: Theme.of(context).textTheme.bodySmall,
        );
      },
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final AppUser? user;

  const _ProfileHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    final photoUrl = user?.photoUrl;
    final email = user?.email;

    return Container(
      padding: const EdgeInsets.all(24),
      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: foxtrotCard,
            backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
            child: photoUrl == null
                ? const Icon(
                    LucideIcons.user300,
                    size: 50,
                    color: foxtrotMuted,
                  )
                : null,
          ),
          const SizedBox(height: 16),
          Text(
            user?.displayLabel ?? '게스트',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          if (user == null)
            TextButton.icon(
              onPressed: () => context.go('/login'),
              icon: const Icon(LucideIcons.logIn, size: 20),
              label: const Text('로그인하기'),
            )
          else if (email != null)
            Text(
              email,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontSize: 14),
            ),
        ],
      ),
    );
  }
}