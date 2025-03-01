import 'package:flutter/material.dart';
import '../../screens/social/story_upload_screen.dart';


class FriendListWidget extends StatefulWidget {
  final List<FriendItem> friends;
  final FriendItem myProfile; // 내 프로필 정보
  final Function(String query)? onSearch;
  final Function(FriendItem friend)? onWakeUp;
  final Function(FriendItem friend)? onFriendTap;
  final Function()? onAddStory;

  const FriendListWidget({
    super.key,
    required this.friends,
    required this.myProfile,
    this.onSearch,
    this.onWakeUp,
    this.onFriendTap,
    this.onAddStory,
  });

  @override
  State<FriendListWidget> createState() => _FriendListWidgetState();
}

class _FriendListWidgetState extends State<FriendListWidget> {
  String? _expandedId;

  void _toggleExpand(String id) {
    setState(() {
      _expandedId = _expandedId == id ? null : id;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 내 프로필과 친구 목록을 합친 전체 리스트
    final allItems = [widget.myProfile, ...widget.friends];

    return Column(
      children: [
        // 검색 바
        // Padding(
        //   padding: const EdgeInsets.all(16.0),
        //   child: SearchBar(
        //     hintText: '친구 검색',
        //     leading: const Icon(Icons.search),
        //     padding: const MaterialStatePropertyAll(
        //       EdgeInsets.symmetric(horizontal: 16.0),
        //     ),
        //     onChanged: (query) => widget.onSearch?.call(query),
        //   ),
        // ),

        // 친구 목록
        Expanded(
          child: allItems.isEmpty
              ? _buildEmptyState(context)
              : ListView.builder(
            itemCount: allItems.length,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemBuilder: (context, index) {
              final item = allItems[index];
              final isMe = item.id == widget.myProfile.id;
              final isExpanded = _expandedId == item.id;

              return _buildFriendCard(
                context,
                item,
                isMe,
                isExpanded,
              );
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

  Widget _buildFriendCard(BuildContext context, FriendItem friend, bool isMe, bool isExpanded) {
    return Column(
      children: [
        Card(
          margin: EdgeInsets.only(bottom: isExpanded ? 0 : 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: const Radius.circular(12),
              bottom: isExpanded ? Radius.zero : const Radius.circular(12),
            ),
          ),
          child: InkWell(
            onTap: () {
              _toggleExpand(friend.id);
              widget.onFriendTap?.call(friend);
            },
            borderRadius: BorderRadius.vertical(
              top: const Radius.circular(12),
              bottom: isExpanded ? Radius.zero : const Radius.circular(12),
            ),
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
                              isMe ? '내' : friend.name,
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

                  // 확장 표시기
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey[600],
                  ),

                  // 액션 버튼 (내가 아닌 경우에만)
                  if (!isMe)
                    IconButton(
                      onPressed: () => widget.onWakeUp?.call(friend),
                      icon: const Icon(Icons.notifications_active_outlined),
                      tooltip: '깨우기',
                    ),
                ],
              ),
            ),
          ),
        ),

        // 확장 영역
        if (isExpanded)
          _buildExpandedSection(context, friend, isMe),
      ],
    );
  }

  Widget _buildExpandedSection(BuildContext context, FriendItem friend, bool isMe) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.zero,
          bottom: Radius.circular(12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isMe
            ? _buildMyExpandedContent(context)
            : const SizedBox.shrink(), // 다른 사람은 아무것도 표시하지 않음
      ),
    );
  }

  // FriendListWidget 내의 _buildMyExpandedContent 메서드 수정
  Widget _buildMyExpandedContent(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            // 스토리 추가하기 버튼 클릭 시 StoryUploadScreen으로 이동
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const StoryUploadScreen(),
              ),
            );
          },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_circle_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '스토리 추가하기',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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