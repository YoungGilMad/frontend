import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/common/app_bar_widget.dart';
import '../../widgets/social/ranking_widget.dart';
import '../../widgets/social/friend_list_widget.dart';
import '../../widgets/social/group_widget.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: '소셜',
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '랭킹'),
            Tab(text: '친구'),
            Tab(text: '그룹'),
          ],
          labelStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: Theme.of(context).textTheme.titleSmall,
          indicatorSize: TabBarIndicatorSize.label,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          // 랭킹 탭
          RankingTab(),
          
          // 친구 탭
          FriendTab(),
          
          // 그룹 탭
          GroupTab(),
        ],
      ),
    );
  }
}

class RankingTab extends StatelessWidget {
  const RankingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '이번 주 랭킹',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      child: Text('${index + 1}'),
                    ),
                    title: Text('User ${index + 1}'),
                    trailing: const Text('1000 pt'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FriendTab extends StatelessWidget {
  const FriendTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // 친구 검색 바
          SearchBar(
            hintText: '친구 검색',
            leading: const Icon(Icons.search),
            padding: const MaterialStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 16.0),
            ),
            onChanged: (query) {
              // TODO: Implement friend search
            },
          ),
          const SizedBox(height: 16),
          // 친구 목록
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      child: const Icon(Icons.person),
                    ),
                    title: Text('Friend ${index + 1}'),
                    subtitle: const Text('Level 10'),
                    trailing: IconButton(
                      icon: const Icon(Icons.notifications),
                      onPressed: () {
                        // TODO: Implement wake up friend
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class GroupTab extends StatelessWidget {
  const GroupTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // 그룹 생성 버튼
          FilledButton.icon(
            onPressed: () {
              // TODO: Implement create group
            },
            icon: const Icon(Icons.add),
            label: const Text('새 그룹 만들기'),
          ),
          const SizedBox(height: 16),
          // 그룹 목록
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      child: const Icon(Icons.group),
                    ),
                    title: Text('Group ${index + 1}'),
                    subtitle: Text('멤버 ${index + 5}명'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Navigate to group detail
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}