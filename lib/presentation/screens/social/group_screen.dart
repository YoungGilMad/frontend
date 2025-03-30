import 'package:flutter/material.dart';
import '../../widgets/social/group_list_widget.dart';
import '../../../data/models/group_item.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  List<GroupItem> groups = [];

  @override
  void initState() {
    super.initState();
    groups = _getSampleGroups(); // 초기 샘플 데이터 로드
  }

  // 샘플 그룹 데이터 생성
  List<GroupItem> _getSampleGroups() {
    return [
      GroupItem(
        id: '1',
        name: '알고리즘 스터디',
        description: '매주 알고리즘 문제를 함께 풀어보는 스터디입니다.',
        memberCount: 5,
        isOwner: true,
        activeMembers: [
          ActiveMember(
            id: '1',
            name: '김천 지드래곤',
            photoUrl: 'https://example.com/photo1.jpg',
          ),
          ActiveMember(
            id: '2',
            name: '김천 지드래곤',
            photoUrl: 'https://example.com/photo2.jpg',
          ),
        ],
      ),
      GroupItem(
        id: '2',
        name: '플러터 마스터',
        description: '플러터 개발 스터디 그룹입니다.',
        memberCount: 8,
        activeMembers: [
          ActiveMember(
            id: '3',
            name: '김천 지드래곤',
            photoUrl: 'https://example.com/photo3.jpg',
          ),
        ],
      ),
    ];
  }

  // 새 그룹 추가 메서드
  void _addNewGroup(GroupItem newGroup) {
    setState(() {
      groups.add(newGroup);
    });
  }

  // 그룹 생성 다이얼로그 표시
  void _showCreateGroupDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final nameController = TextEditingController();
        final descriptionController = TextEditingController();

        return AlertDialog(
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
                  final newGroup = GroupItem(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: nameController.text,
                    description: descriptionController.text.isEmpty
                        ? null
                        : descriptionController.text,
                    memberCount: 1,
                    isOwner: true,
                    activeMembers: [],
                  );
                  _addNewGroup(newGroup);
                  Navigator.pop(context);
                }
              },
              child: const Text('만들기'),
            ),
          ],
        );
      },
    );
  }

  // 그룹 검색 다이얼로그 표시
  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String searchQuery = "";
        return AlertDialog(
          title: const Text('그룹 검색'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(
              hintText: '그룹 이름을 입력하세요',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              searchQuery = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                // 검색 기능 구현
                debugPrint('Searching for group: $searchQuery');
                // TODO: Implement actual search functionality using searchQuery
                Navigator.pop(context);
              },
              child: const Text('검색'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GroupWidget(
        groups: groups,
        onCreateGroup: (name, description) {
          final newGroup = GroupItem(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: name,
            description: description,
            memberCount: 1,
            isOwner: true,
            activeMembers: [],
          );
          _addNewGroup(newGroup);
        },
        onGroupTap: (group) {
          debugPrint('Tapped group: ${group.name}');
        },
        onLeaveGroup: (group) {
          setState(() {
            groups.removeWhere((g) => g.id == group.id);
          });
        },
        onInviteMember: (userId, group) {
          debugPrint('Invite member to group: ${group.name}');
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _showCreateGroupDialog,
            backgroundColor: Colors.blue,
            shape: const CircleBorder(),
            tooltip: '새 그룹 만들기',
            child: const Icon(Icons.add, color: Colors.white),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            onPressed: _showSearchDialog,
            backgroundColor: Colors.blue,
            shape: const CircleBorder(),
            tooltip: '그룹 검색',
            child: const Icon(Icons.search, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
