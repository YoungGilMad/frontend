import 'package:flutter/material.dart';
import '../../widgets/social/friend_list_widget.dart';
import '../../../data/models/friend_item.dart';

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
    myProfile = FriendItem(
      id: 'my-id',
      name: '내 이름',
      level: 25,
      lastActive: '방금 전',
      isOnline: true,
      isPremium: true,
      profileImage: null,
      hasStory: false, // 초기에는 스토리 없음
    );

    friends = List.generate(
      10,
          (index) => FriendItem(
        id: 'friend-$index',
        name: '친구 ${index + 1}',
        level: 10 + index,
        lastActive: index % 3 == 0 ? '방금 전' : '${index + 1}시간 전',
        isOnline: index % 3 == 0,
        isPremium: index % 5 == 0,
        profileImage: null,
        hasStory: index % 4 == 0, // 샘플 친구들 중 일부는 스토리 있음
      ),
    );
  }

  void _searchFriends(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  void _wakeUpFriend(FriendItem friend) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${friend.name}님을 깨웠습니다!')),
    );
  }

  void _onFriendTap(FriendItem friend) {}

  void _addStory() {
    setState(() {
      myProfile.hasStory = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('스토리가 추가되었습니다!')),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String tempQuery = searchQuery;
        return AlertDialog(
          title: const Text('친구 검색'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(
              hintText: '친구 이름을 입력하세요',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              tempQuery = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  searchQuery = tempQuery;
                });
                Navigator.of(context).pop();
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
    final filteredFriends = searchQuery.isEmpty
        ? friends
        : friends
        .where((friend) =>
        friend.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      body: FriendListWidget(
        friends: filteredFriends,
        myProfile: myProfile,
        onSearch: _searchFriends,
        onWakeUp: _wakeUpFriend,
        onFriendTap: _onFriendTap,
        onAddStory: _addStory,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showSearchDialog,
        backgroundColor: Colors.blue, // 버튼 색상을 파란색으로 설정
        shape: const CircleBorder(), // 버튼을 완전히 동그랗게 만듦
        child: const Icon(Icons.search, color: Colors.white), // 아이콘 색상을 흰색으로 설정
        tooltip: '친구 검색',
      ),
    );
  }
}
