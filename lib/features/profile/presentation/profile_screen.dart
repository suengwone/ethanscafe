import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 정보'),
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey.shade300,
                  child: const Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '게스트',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () => context.go('/login'),
                  icon: const Icon(Icons.login),
                  label: const Text('로그인하기'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _buildSection(
            '나의 활동',
            [
              _buildListTile(
                icon: Icons.receipt_long,
                title: '주문 내역',
                onTap: () {},
              ),
              _buildListTile(
                icon: Icons.card_giftcard,
                title: '쿠폰함',
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '2',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                onTap: () {},
              ),
              _buildListTile(
                icon: Icons.favorite,
                title: '즐겨찾기 메뉴',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildSection(
            '설정',
            [
              _buildListTile(
                icon: Icons.notifications,
                title: '알림 설정',
                onTap: () {},
              ),
              _buildListTile(
                icon: Icons.payment,
                title: '결제 수단 관리',
                onTap: () {},
              ),
              _buildListTile(
                icon: Icons.location_on,
                title: '배송지 관리',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildSection(
            '기타',
            [
              _buildListTile(
                icon: Icons.help,
                title: '고객센터',
                onTap: () {},
              ),
              _buildListTile(
                icon: Icons.info,
                title: '이용약관',
                onTap: () {},
              ),
              _buildListTile(
                icon: Icons.privacy_tip,
                title: '개인정보처리방침',
                onTap: () {},
              ),
              _buildListTile(
                icon: Icons.business,
                title: '사업자 정보',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildSection(
            '계정',
            [
              _buildListTile(
                icon: Icons.logout,
                title: '로그아웃',
                textColor: Colors.red,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              '앱 버전 1.0.0',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
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
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}