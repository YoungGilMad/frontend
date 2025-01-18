// lib/social_flag/social_main.dart
import 'package:flutter/material.dart';

class SocialMainScreen extends StatefulWidget {
  const SocialMainScreen({super.key});

  @override
  State<SocialMainScreen> createState() => _SocialMainScreenState();
}

class _SocialMainScreenState extends State<SocialMainScreen> {
  int _selectedIndex = 0;

  // 각 탭에 해당하는 컨텐츠 위젯
  final List<Widget> _screens = [
    const RankingContent(),
    const FriendContent(),
    const GroupContent(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Social'),
      ),
      body: Column(
        children: [
          // 상단 탭 버튼들
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedIndex == 0 ? Colors.blue : Colors.white,
                      foregroundColor: _selectedIndex == 0 ? Colors.white : Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 0;
                      });
                    },
                    child: const Text('랭킹'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedIndex == 1 ? Colors.blue : Colors.white,
                      foregroundColor: _selectedIndex == 1 ? Colors.white : Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 1;
                      });
                    },
                    child: const Text('친구'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedIndex == 2 ? Colors.blue : Colors.white,
                      foregroundColor: _selectedIndex == 2 ? Colors.white : Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 2;
                      });
                    },
                    child: const Text('그룹'),
                  ),
                ),
              ],
            ),
          ),
          // 컨텐츠 영역
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.grey[200],
              child: _screens[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}

// 랭킹 컨텐츠
class RankingContent extends StatelessWidget {
  const RankingContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('랭킹 컨텐츠'),
    );
  }
}

// 친구 컨텐츠
class FriendContent extends StatelessWidget {
  const FriendContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('친구 컨텐츠'),
    );
  }
}

// 그룹 컨텐츠
class GroupContent extends StatelessWidget {
  const GroupContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('그룹 컨텐츠'),
    );
  }
}