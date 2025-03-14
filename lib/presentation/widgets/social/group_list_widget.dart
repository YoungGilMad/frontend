import 'package:flutter/material.dart';
import '../../screens/social/group_room_screen.dart';
import '../../../data/models/group_item.dart';

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
  Widget build(BuildContext context) {
    return Expanded(
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
                    backgroundColor:
                    Theme.of(context).colorScheme.primaryContainer,
                    child: Text(
                      widget.group.name.substring(0, 1).toUpperCase(),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color:
                        Theme.of(context).colorScheme.onPrimaryContainer,
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
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
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

              // 활동 중인 멤버 및 버튼 (확장 시 표시)
              if (_isExpanded) ...[
                const SizedBox(height: 16),
                Text(
                  '현재 활동 중',
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
                          backgroundImage: NetworkImage(
                              widget.group.activeMembers[index].photoUrl),
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
                          builder: (context) =>
                              RoomWidget(group: widget.group),
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
