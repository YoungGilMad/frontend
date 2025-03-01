import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'ranking_screen.dart';
import 'friend_screen.dart';
import 'group_screen.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const RankingScreen(),
    const FriendScreen(),
    const GroupScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                // 프로필 섹션
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: authProvider.user?.profileImageUrl != null
                            ? NetworkImage(authProvider.user!.profileImageUrl!)
                            : null,
                        child: authProvider.user?.profileImageUrl == null
                            ? const Icon(Icons.person, color: Colors.grey)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            authProvider.user?.nickname ?? 'GD',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // 탭 버튼들
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => setState(() => _selectedIndex = 0),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedIndex == 0
                                ? Colors.blue
                                : Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text('랭킹'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => setState(() => _selectedIndex = 1),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedIndex == 1
                                ? Colors.blue
                                : Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text('친구'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => setState(() => _selectedIndex = 2),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedIndex == 2
                                ? Colors.blue
                                : Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text('그룹'),
                        ),
                      ),
                    ],
                  ),
                ),

                // 선택된 스크린 표시
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: _screens[_selectedIndex],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}