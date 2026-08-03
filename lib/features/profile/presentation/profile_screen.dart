import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../core/theme/app_theme.dart';
import '../../auth/domain/auth_models.dart';
import '../../auth/presentation/auth_providers.dart';

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
                onTap: () {},
              ),
              _buildListTile(
                icon: LucideIcons.ticket,
                title: '쿠폰함',
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: foxtrotGold,
                    borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
                  ),
                  child: const Text(
                    '2',
                    style: TextStyle(color: foxtrotBlack, fontSize: 12),
                  ),
                ),
                onTap: () {},
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
                onTap: () {},
              ),
              _buildListTile(
                icon: LucideIcons.creditCard,
                title: '결제 수단 관리',
                onTap: () {},
              ),
              _buildListTile(
                icon: LucideIcons.mapPin,
                title: '배송지 관리',
                onTap: () {},
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
                onTap: () {},
              ),
              _buildListTile(
                icon: LucideIcons.info,
                title: '이용약관',
                onTap: () {},
              ),
              _buildListTile(
                icon: LucideIcons.shieldCheck,
                title: '개인정보처리방침',
                onTap: () {},
              ),
              _buildListTile(
                icon: LucideIcons.building2,
                title: '사업자 정보',
                onTap: () {},
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

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 8),
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