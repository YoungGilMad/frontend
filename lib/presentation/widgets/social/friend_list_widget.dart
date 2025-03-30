import 'package:flutter/material.dart';
import '../../screens/social/story_upload_screen.dart';
import '../../../data/models/friend_item.dart';
import '../../screens/social/friend_profile_screen.dart';
import '../../screens/social/story_watch_screen.dart';


class FriendListWidget extends StatefulWidget {
  final List<FriendItem> friends;
  final FriendItem myProfile;
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
    final allItems = [widget.myProfile, ...widget.friends];

    return Column(
      children: [
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
          Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            '아직 친구가 없습니다',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            '새로운 친구를 추가해보세요!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
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
                  // 프로필 이미지 (스토리 있는 경우 빨간 테두리 추가)
                  // 프로필 이미지 (스토리가 있을 때 클릭 가능)
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (friend.hasStory) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StoryWatchScreen(
                                  friendName: friend.name,
                                  storyImageUrl: friend.profileImage, // 예제: 스토리 이미지는 프로필과 같다고 가정
                                ),
                              ),
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: friend.hasStory
                                ? Border.all(color: Colors.blue, width: 3) // 스토리가 있을 때 테두리 강조
                                : null,
                          ),
                          child: CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: friend.profileImage != null
                                ? NetworkImage(friend.profileImage!)
                                : null,
                            child: friend.profileImage == null
                                ? const Icon(Icons.person, color: Colors.grey)
                                : null,
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
                              isMe ? '나' : friend.name,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            // if (friend.isPremium)
                            //   Padding(
                            //     padding: const EdgeInsets.only(left: 4),
                            //     child: Icon(Icons.verified, size: 16, color: Theme.of(context).colorScheme.primary),
                            //   ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // Row(
                        //   children: [
                        //     Icon(Icons.military_tech, size: 14, color: Theme.of(context).colorScheme.primary),
                        //     const SizedBox(width: 4),
                        //     Text('Lv.${friend.level}', style: Theme.of(context).textTheme.bodySmall),
                        //     const SizedBox(width: 12),
                        //     Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                        //     const SizedBox(width: 4),
                        //     Text(
                        //       friend.lastActive,
                        //       style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),

                  // 확장 표시기
                  // Icon(isExpanded ? Icons.expand_less : Icons.expand_more, color: Colors.grey[600]),

                  // 깨우기 버튼 (내가 아닌 경우에만)
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
        if (isExpanded) _buildExpandedSection(context, friend, isMe),
      ],
    );
  }

  Widget _buildExpandedSection(BuildContext context, FriendItem friend, bool isMe) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isMe
            ? _buildMyExpandedContent(context)
            : _buildFriendExpandedContent(context, friend),
      ),
    );
  }

  Widget _buildFriendExpandedContent(BuildContext context, FriendItem friend) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FriendProfileScreen(
              name: friend.name,
              level: friend.level,
              ranking: friend.ranking,
              xp: friend.xp,
              maxXp: 10000, // 예제 값
              strength: friend.strength,
              agility: friend.agility,
              intelligence: friend.intelligence,
              stamina: friend.stamina,
              profileImage: friend.profileImage,
              friend: friend,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_outline, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              '프로필 구경하기',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildMyExpandedContent(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StoryUploadScreen(
                  onStoryUploaded: () {
                    setState(() {
                      widget.myProfile.hasStory = true;
                    });
                  },
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_circle_outline, color: Theme.of(context).colorScheme.primary),
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
