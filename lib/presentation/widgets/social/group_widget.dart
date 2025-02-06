import 'package:flutter/material.dart';

class GroupWidget extends StatelessWidget {
  final List<GroupItem> groups;
  final VoidCallback? onCreateGroup;
  final Function(GroupItem group)? onGroupTap;
  final Function(GroupItem group)? onLeaveGroup;
  final Function(String userId, GroupItem group)? onInviteMember;

  const GroupWidget({
    super.key,
    required this.groups,
    this.onCreateGroup,
    this.onGroupTap,
    this.onLeaveGroup,
    this.onInviteMember,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 그룹 생성 버튼
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: FilledButton.icon(
            onPressed: onCreateGroup,
            icon: const Icon(Icons.add),
            label: const Text('새 스터디 그룹 만들기'),
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
                    return _buildGroupCard(context, group);
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
            '새로운 스터디 그룹을 만들어보세요!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupCard(BuildContext context, GroupItem group) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => onGroupTap?.call(group),
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
                      group.name.substring(0, 1).toUpperCase(),
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
                          group.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          '멤버 ${group.memberCount}명',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'invite':
                          // TODO: Show member invite dialog
                          break;
                        case 'leave':
                          onLeaveGroup?.call(group);
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'invite',
                        child: Row(
                          children: [
                            Icon(Icons.person_add),
                            SizedBox(width: 8),
                            Text('멤버 초대'),
                          ],
                        ),
                      ),
                      if (!group.isOwner)
                        const PopupMenuItem(
                          value: 'leave',
                          child: Row(
                            children: [
                              Icon(Icons.exit_to_app),
                              SizedBox(width: 8),
                              Text('그룹 나가기'),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              if (group.description != null) ...[
                const SizedBox(height: 12),
                Text(
                  group.description!,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),
              // 활동 정보
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildActivityInfo(
                    context,
                    Icons.task_alt,
                    '완료한 퀘스트',
                    '${group.completedQuests}개',
                  ),
                  _buildActivityInfo(
                    context,
                    Icons.trending_up,
                    '주간 성장률',
                    '${group.weeklyGrowth}%',
                  ),
                  _buildActivityInfo(
                    context,
                    Icons.emoji_events,
                    '그룹 랭킹',
                    '#${group.ranking}',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityInfo(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
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

  const GroupItem({
    required this.id,
    required this.name,
    this.description,
    required this.memberCount,
    this.isOwner = false,
    this.completedQuests = 0,
    this.weeklyGrowth = 0,
    this.ranking = 0,
  });
}