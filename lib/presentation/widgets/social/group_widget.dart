import 'package:flutter/material.dart';
import 'join_group_widget.dart';
import 'room_widget.dart';

class GroupWidget extends StatelessWidget {
  final List<GroupItem> groups;
  final Function(GroupItem group)? onGroupTap;
  final Function(GroupItem group)? onLeaveGroup;
  final Function(String userId, GroupItem group)? onInviteMember;
  final Function(String name, String? description)? onCreateGroup;

  const GroupWidget({
    super.key,
    required this.groups,
    this.onGroupTap,
    this.onLeaveGroup,
    this.onInviteMember,
    this.onCreateGroup,
  });

  @override
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 그룹 생성 및 참여 버튼
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    _showCreateGroupDialog(context);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('새 스터디 그룹 만들기'),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const JoinGroupWidget(),
                    ),
                  );
                },
                icon: const Icon(Icons.search),
                label: const Text('참여'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 40),
                ),
              ),
            ],
          ),
        ),

        // 그룹 목록
        Expanded(
          child: groups.isEmpty
              ? _buildEmptyState(context)
              : ListView.builder(
            itemCount: groups.length,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemBuilder: (context, index) {
              final group = groups[index];
              return _GroupCard(
                group: group,
                onGroupTap: onGroupTap,
              );
            },
          ),
        ),
      ],
    );
  }

  // 그룹 생성 다이얼로그
  Future<void> _showCreateGroupDialog(BuildContext context) async {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('새 스터디 그룹 만들기'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: '그룹 이름',
                hintText: '그룹 이름을 입력하세요',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: '그룹 설명',
                hintText: '그룹 설명을 입력하세요',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                onCreateGroup?.call(
                  nameController.text,
                  descriptionController.text.isEmpty
                      ? null
                      : descriptionController.text,
                );
              }
            },
            child: const Text('만들기'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.group_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            '아직 참여 중인 그룹이 없습니다',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '새로운 스터디 그룹을 만들거나 참여해보세요!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton.icon(
                onPressed: () {
                  _showCreateGroupDialog(context);
                },
                icon: const Icon(Icons.add),
                label: const Text('그룹 만들기'),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const JoinGroupWidget(),
                    ),
                  );
                },
                icon: const Icon(Icons.search),
                label: const Text('그룹 참여하기'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GroupCard extends StatefulWidget {
  final GroupItem group;
  final Function(GroupItem group)? onGroupTap;

  const _GroupCard({
    required this.group,
    this.onGroupTap,
  });

  @override
  State<_GroupCard> createState() => _GroupCardState();
}

class _GroupCardState extends State<_GroupCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 그룹 헤더
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    child: Text(
                      widget.group.name.substring(0, 1).toUpperCase(),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.group.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '멤버 ${widget.group.memberCount}명',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // 활동중인 멤버와 버튼 (확장 시에만 표시)
              if (_isExpanded) ...[
                const SizedBox(height: 16),
                Text(
                  '현재 활동중',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.group.activeMembers.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(widget.group.activeMembers[index].photoUrl),
                          radius: 20,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RoomWidget(group: widget.group),
                        ),
                      );
                    },
                    icon: const Icon(Icons.login),
                    label: const Text('방 들어가기'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class GroupItem {
  final String id;
  final String name;
  final String? description;
  final int memberCount;
  final bool isOwner;
  final int completedQuests;
  final int weeklyGrowth;
  final int ranking;
  final List<ActiveMember> activeMembers;

  const GroupItem({
    required this.id,
    required this.name,
    this.description,
    required this.memberCount,
    this.isOwner = false,
    this.completedQuests = 0,
    this.weeklyGrowth = 0,
    this.ranking = 0,
    this.activeMembers = const [],
  });
}

class ActiveMember {
  final String id;
  final String name;
  final String photoUrl;

  const ActiveMember({
    required this.id,
    required this.name,
    required this.photoUrl,
  });
}