import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../data/models/group_item.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'join_group_widget.dart';
import 'room_widget.dart';

class GroupWidget extends StatelessWidget {
  final List<GroupItem> groups;

  const GroupWidget({
    super.key,
    required this.groups,
  });

  // ✅ 그룹 생성 API 호출
  Future<void> _createGroup({
    required BuildContext context,
    required int userId,
    required String name,
    String? description,
  }) async {
    final uri = Uri.parse("http://YOUR_BACKEND_URL/social/group/make/$userId")
        .replace(queryParameters: {
      'name': name,
      'description': description ?? '',
    });

    try {
      final response = await http.post(uri);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("그룹이 생성되었습니다.")),
        );
        print("✅ 생성된 그룹 ID: ${data['group_id']}");
        // TODO: 그룹 목록 갱신
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("그룹 생성 실패: ${response.body}")),
        );
      }
    } catch (e) {
      print("네트워크 오류: $e");
    }
  }

  // ✅ 그룹 생성 다이얼로그
  Future<void> _showCreateGroupDialog(BuildContext context, int userId) async {
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
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: '그룹 설명',
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
                _createGroup(
                  context: context,
                  userId: userId,
                  name: nameController.text,
                  description: descriptionController.text,
                );
                Navigator.pop(context);
              }
            },
            child: const Text('만들기'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userId = authProvider.user?.id;

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
                    if (userId != null) {
                      _showCreateGroupDialog(context, userId);
                    }
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
              ? _buildEmptyState(context, userId)
              : ListView.builder(
            itemCount: groups.length,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemBuilder: (context, index) {
              final group = groups[index];
              return _GroupCard(group: group);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, int? userId) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.group_outlined, size: 64, color: Colors.grey[400]),
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
                  if (userId != null) {
                    _showCreateGroupDialog(context, userId);
                  }
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

  const _GroupCard({
    required this.group,
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
              if (_isExpanded) ...[
                const SizedBox(height: 16),
                Text(
                  '현재 활동중', // 실제 구현은 아래 참고
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                const Text('(활동중인 멤버 기능은 백엔드 구현 필요)'),
              ],
              const SizedBox(height: 12),
              if (_isExpanded)
                FilledButton.icon(
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
            ],
          ),
        ),
      ),
    );
  }
}
