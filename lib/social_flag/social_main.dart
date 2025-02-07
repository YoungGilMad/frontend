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
    // 랭킹을 위한 더미 데이터
    final List<Map<String, dynamic>> rankings = List.generate(
      20,
          (index) => {
        'rank': index + 1,
        'name': '사용자 ${index + 1}',
        'score': (1000 - index * 30),
      },
    );

    return ListView.builder(
      itemCount: rankings.length,
      itemBuilder: (context, index) {
        final ranking = rankings[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              child: Text('${ranking['rank']}'),
            ),
            title: Text(ranking['name']),
            trailing: Text('${ranking['score']}점'),
          ),
        );
      },
    );
  }
}

// 친구 컨텐츠
class FriendContent extends StatelessWidget {
  const FriendContent({super.key});

  @override
  Widget build(BuildContext context) {
    // 친구 목록을 위한 더미 데이터
    final List<Map<String, dynamic>> friends = List.generate(
      15,
          (index) => {
        'name': '친구 ${index + 1}',
        'status': index % 3 == 0 ? '온라인' : '오프라인',
        'lastActive': '${index + 1}시간 전',
      },
    );

    return ListView.builder(
      itemCount: friends.length,
      itemBuilder: (context, index) {
        final friend = friends[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: friend['status'] == '온라인' ? Colors.green : Colors.grey,
              child: Text(friend['name'][0]),
            ),
            title: Text(friend['name']),
            subtitle: Text('마지막 활동: ${friend['lastActive']}'),
            trailing: Text(friend['status']),
          ),
        );
      },
    );
  }
}

// 그룹 컨텐츠
class GroupContent extends StatelessWidget {
  const GroupContent({super.key});

  @override
  Widget build(BuildContext context) {
    // 그룹 목록을 위한 더미 데이터
    final List<Map<String, dynamic>> groups = List.generate(
      10,
          (index) => {
        'name': '그룹 ${index + 1}',
        'members': '${(index + 1) * 3}명',
        'description': '이것은 그룹 ${index + 1}의 설명입니다.',
      },
    );

    return ListView.builder(
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.group, color: Colors.white),
            ),
            title: Text(group['name']),
            subtitle: Text(group['description']),
            trailing: Text(group['members']),
          ),
        );
      },
    );
  }
}