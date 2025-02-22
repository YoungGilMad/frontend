import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../screens/settings/settings_screen.dart';
import '../../screens/statistics/statistics_screen.dart';
import '../../screens/quest/daily_quest_screen.dart';
import '../../screens/store/store_screen.dart';
import '../../screens/social/social_screen.dart';

class HomeDrawerWidget extends StatelessWidget {
  const HomeDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Column(
          children: [
            // 사용자 프로필 정보
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                backgroundImage: user?.profileImageUrl != null
                    ? NetworkImage(user!.profileImageUrl!)
                    : null,
                child: user?.profileImageUrl == null
                    ? const Icon(Icons.person, color: Colors.white)
                    : null,
              ),
              accountName: Text(
                user?.name ?? '용사님',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
              ),
              accountEmail: Text(
                user?.email ?? '',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer
                          .withOpacity(0.8),
                    ),
              ),
            ),

            // 메뉴 아이템들
            _buildMenuItem(
              context,
              title: '데일리 퀘스트',
              icon: Icons.assignment,
              onTap: () => _navigateTo(context, const DailyQuestScreen()),
            ),
            _buildMenuItem(
              context,
              title: '소셜',
              icon: Icons.people,
              onTap: () => _navigateTo(context, const SocialScreen()),
            ),
            _buildMenuItem(
              context,
              title: '통계',
              icon: Icons.bar_chart,
              onTap: () => _navigateTo(context, const StatisticsScreen()),
            ),
            _buildMenuItem(
              context,
              title: '상점',
              icon: Icons.store,
              onTap: () => _navigateTo(context, const StoreScreen()),
            ),
            const Divider(),
            _buildMenuItem(
              context,
              title: '설정',
              icon: Icons.settings,
              onTap: () => _navigateTo(context, const SettingsScreen()),
            ),

            const Spacer(),
            // 로그아웃 버튼
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: OutlinedButton.icon(
                onPressed: () => _showLogoutDialog(context),
                icon: const Icon(Icons.logout),
                label: const Text('로그아웃'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.pop(context); // 드로어 닫기
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('로그아웃'),
        content: const Text('정말 로그아웃 하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('로그아웃'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      Navigator.pop(context); // 드로어 닫기
      await context.read<AuthProvider>().logout();
    }
  }
}