import 'package:flutter/material.dart';

class FriendListWidget extends StatelessWidget {
  final List<FriendItem> friends;
  final Function(String query)? onSearch;
  final Function(FriendItem friend)? onWakeUp;
  final Function(FriendItem friend)? onFriendTap;

  const FriendListWidget({
    super.key,
    required this.friends,
    this.onSearch,
    this.onWakeUp,
    this.onFriendTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 검색 바
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SearchBar(
            hintText: '친구 검색',
            leading: const Icon(Icons.search),
            padding: const MaterialStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 16.0),
            ),
            onChanged: (query) => onSearch?.call(query),
          ),
        ),

        // 친구 목록
        Expanded(
          child: friends.isEmpty
              ? _buildEmptyState(context)
              : ListView.builder(
                  itemCount: friends.length,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemBuilder: (context, index) {
                    final friend = friends[index];
                    return _buildFriendCard(context, friend);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            '아직 친구가 없습니다',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            '새로운 친구를 추가해보세요!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildFriendCard(BuildContext context, FriendItem friend) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => onFriendTap?.call(friend),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // 프로필 이미지
              Stack(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: friend.profileImage != null
                        ? NetworkImage(friend.profileImage!)
                        : null,
                    child: friend.profileImage == null
                        ? const Icon(Icons.person, color: Colors.grey)
                        : null,
                  ),
                  if (friend.isOnline)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              
              // 친구 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          friend.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        if (friend.isPremium)
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Icon(
                              Icons.verified,
                              size: 16,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.military_tech,
                          size: 14,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Lv.${friend.level}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          friend.lastActive,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 액션 버튼
              IconButton(
                onPressed: () => onWakeUp?.call(friend),
                icon: const Icon(Icons.notifications_active_outlined),
                tooltip: '깨우기',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FriendItem {
  final String id;
  final String name;
  final int level;
  final String lastActive;
  final String? profileImage;
  final bool isOnline;
  final bool isPremium;

  const FriendItem({
    required this.id,
    required this.name,
    required this.level,
    required this.lastActive,
    this.profileImage,
    this.isOnline = false,
    this.isPremium = false,
  });
}