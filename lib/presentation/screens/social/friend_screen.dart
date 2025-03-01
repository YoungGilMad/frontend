import 'package:flutter/material.dart';
import '../../widgets/social/friend_list_widget.dart';

class FriendScreen extends StatefulWidget {
  const FriendScreen({super.key});

  @override
  State<FriendScreen> createState() => _FriendScreenState();
}

class _FriendScreenState extends State<FriendScreen> {
  List<FriendItem> friends = [];
  late FriendItem myProfile;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    // 내 프로필 정보 초기화
    myProfile = FriendItem(
      id: 'my-id',
      name: '내 이름', // '내'로 표시됨
      level: 25,
      lastActive: '방금 전',
      isOnline: true,
      isPremium: true,
      profileImage: null, // 프로필 이미지 URL 있다면 설정
    );

    // 샘플 친구 목록 초기화
    friends = List.generate(
      10,
          (index) => FriendItem(
        id: 'friend-$index',
        name: '친구 ${index + 1}',
        level: 10 + index,
        lastActive: index % 3 == 0 ? '방금 전' : '${index + 1}시간 전',
        isOnline: index % 3 == 0,
        isPremium: index % 5 == 0,
        profileImage: null, // 실제 앱에서는 친구 프로필 이미지 URL 설정
      ),
    );
  }

  // 검색 기능 구현
  void _searchFriends(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  // 깨우기 기능 구현
  void _wakeUpFriend(FriendItem friend) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${friend.name}님을 깨웠습니다!')),
    );
  }

  // 친구 탭 기능 구현
  void _onFriendTap(FriendItem friend) {
    // 친구 프로필로 이동하거나 다른 작업 수행
  }

  // 스토리 추가 기능 구현
  void _addStory() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('스토리 추가 기능 구현 예정입니다.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 검색어로 필터링된 친구 목록
    final filteredFriends = searchQuery.isEmpty
        ? friends
        : friends
        .where((friend) =>
        friend.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return FriendListWidget(
      friends: filteredFriends,
      myProfile: myProfile,
      onSearch: _searchFriends,
      onWakeUp: _wakeUpFriend,
      onFriendTap: _onFriendTap,
      onAddStory: _addStory,
    );
  }
}