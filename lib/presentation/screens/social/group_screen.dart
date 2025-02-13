import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/social/group_widget.dart';

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
    // 초기 샘플 데이터 로드
    groups = _getSampleGroups();
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

  @override
  Widget build(BuildContext context) {
    return GroupWidget(
      groups: groups,
      onCreateGroup: (name, description) {
        // 새 그룹 생성 시 호출될 콜백
        final newGroup = GroupItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(), // 임시 ID 생성
          name: name,
          description: description,
          memberCount: 1,
          isOwner: true,
          activeMembers: [], // 초기에는 활성 멤버 없음
        );
        _addNewGroup(newGroup);
        Navigator.pop(context); // 생성 화면 닫기
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
    );
  }
}