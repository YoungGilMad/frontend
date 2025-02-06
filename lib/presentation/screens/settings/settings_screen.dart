import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/app_bar_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: '설정',
        automaticallyImplyLeading: true,
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return ListView(
            children: [
              // 계정 섹션
              _buildSection(
                context,
                '계정',
                [
                  _buildListTile(
                    context,
                    '프로필 정보 수정',
                    Icons.person,
                    onTap: () {
                      // TODO: Navigate to profile edit screen
                    },
                  ),
                  _buildListTile(
                    context,
                    '비밀번호 변경',
                    Icons.lock,
                    onTap: () {
                      // TODO: Navigate to password change screen
                    },
                  ),
                ],
              ),

              // 앱 설정 섹션
              _buildSection(
                context,
                '앱 설정',
                [
                  _buildListTile(
                    context,
                    '알림 설정',
                    Icons.notifications,
                    trailing: Switch(
                      value: true, // TODO: Implement notification settings
                      onChanged: (value) {
                        // TODO: Handle notification toggle
                      },
                    ),
                  ),
                  _buildListTile(
                    context,
                    '언어 설정',
                    Icons.language,
                    subtitle: '한국어',
                    onTap: () {
                      // TODO: Show language selection dialog
                    },
                  ),
                  _buildListTile(
                    context,
                    '테마 설정',
                    Icons.palette,
                    subtitle: '시스템 설정',
                    onTap: () {
                      // TODO: Show theme selection dialog
                    },
                  ),
                ],
              ),

              // 지원 섹션
              _buildSection(
                context,
                '지원',
                [
                  _buildListTile(
                    context,
                    '자주 묻는 질문',
                    Icons.help,
                    onTap: () {
                      // TODO: Navigate to FAQ screen
                    },
                  ),
                  _buildListTile(
                    context,
                    '문의하기',
                    Icons.email,
                    onTap: () {
                      // TODO: Navigate to contact screen
                    },
                  ),
                  _buildListTile(
                    context,
                    '개인정보 처리방침',
                    Icons.privacy_tip,
                    onTap: () {
                      // TODO: Navigate to privacy policy screen
                    },
                  ),
                ],
              ),

              // 계정 관리 섹션
              _buildSection(
                context,
                '계정 관리',
                [
                  _buildListTile(
                    context,
                    '로그아웃',
                    Icons.logout,
                    textColor: Colors.red,
                    onTap: () async {
                      final confirmed = await showLogoutConfirmDialog(context);
                      if (confirmed == true) {
                        authProvider.logout();
                      }
                    },
                  ),
                  _buildListTile(
                    context,
                    '회원 탈퇴',
                    Icons.delete_forever,
                    textColor: Colors.red,
                    onTap: () {
                      // TODO: Show account deletion confirmation
                    },
                  ),
                ],
              ),

              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildListTile(
    BuildContext context,
    String title,
    IconData icon, {
    String? subtitle,
    Widget? trailing,
    Color? textColor,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? Colors.grey[700]),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: textColor,
            ),
      ),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Future<bool?> showLogoutConfirmDialog(BuildContext context) {
    return showDialog<bool>(
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
  }
}