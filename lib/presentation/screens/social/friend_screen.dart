import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../widgets/social/friend_list_widget.dart';
import '../../../data/models/friend_item.dart';
import '../../providers/auth_provider.dart';

class FriendScreen extends StatefulWidget {
  const FriendScreen({super.key});

  @override
  State<FriendScreen> createState() => _FriendScreenState();
}

class _FriendScreenState extends State<FriendScreen> {
  List<FriendItem> friends = [];
  FriendItem? myProfile;
  String searchQuery = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      _fetchFriendsFromServer(
        userId: authProvider.user!.id,
        token: authProvider.token,
      );
    });
  }

  Future<void> _fetchFriendsFromServer({
    required int userId,
    String? token,
  }) async {
    try {
      final dio = Dio();
      final baseUrl = dotenv.env['API_BASE_URL'];

      if (baseUrl == null) {
        throw Exception("API_BASE_URL is not set in .env");
      }

      if (token != null) {
        dio.options.headers['Authorization'] = 'Bearer $token';
      }

      final response = await dio.get('$baseUrl/friends/$userId');
      final data = response.data as List;

      setState(() {
        friends = data.map((json) => FriendItem.fromJson(json)).toList();

        // ✅ 임시 내 정보 (원하면 서버에서 가져오도록 확장 가능)
        myProfile = FriendItem(
          id: userId.toString(),
          name: '내 이름',
          level: 25,
          profileImage: null,
          hasStory: false,
          ranking: 1,
          xp: 9500,
          strength: 80,
          agility: 75,
          intelligence: 90,
          stamina: 85,
        );

        isLoading = false;
      });
    } catch (e) {
      print('친구 목록 불러오기 실패: $e');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('친구 목록을 불러오지 못했습니다.')),
      );
    }
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

  void _onFriendTap(FriendItem friend) {
    // 친구 클릭 시 행동 정의
  }

  void _addStory() {
    if (myProfile != null) {
      setState(() {
        myProfile!.hasStory = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('스토리가 추가되었습니다!')),
      );
    }
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

  void _addFriend() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final dio = Dio();
    final baseUrl = dotenv.env['API_BASE_URL'];

    if (baseUrl == null) {
      throw Exception("API_BASE_URL is not set in .env");
    }

    dio.options.headers['Authorization'] = 'Bearer ${authProvider.token}';

    try {
      final response = await dio.get('$baseUrl/users/all');
      final data = response.data as List;
      final allUsers = data.map((json) => FriendItem.fromJson(json)).toList();

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('친구 추가'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: allUsers.length,
                itemBuilder: (context, index) {
                  final user = allUsers[index];
                  final isAlreadyFriend = friends.any((f) => f.id == user.id) ||
                      user.id == authProvider.user!.id.toString();

                  if (isAlreadyFriend) return const SizedBox.shrink();

                  return ListTile(
                    title: Text(user.name),
                    subtitle: Text('Lv. ${user.level}'),
                    trailing: TextButton(
                      onPressed: () async {
                        await _sendFriendRequest(
                          myId: authProvider.user!.id,
                          friendId: int.parse(user.id),
                          token: authProvider.token,
                        );
                        Navigator.of(context).pop();
                      },
                      child: const Text('추가'),
                    ),
                  );
                },
              ),
            ),
          );
        },
      );
    } catch (e) {
      print('전체 사용자 불러오기 실패: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('사용자 목록을 불러오지 못했습니다.')),
      );
    }
  }

  Future<void> _sendFriendRequest({
    required int myId,
    required int friendId,
    required String? token,
  }) async {
    try {
      final dio = Dio();
      final baseUrl = dotenv.env['API_BASE_URL'];
      if (baseUrl == null) throw Exception("API_BASE_URL is not set");

      dio.options.headers['Authorization'] = 'Bearer $token';

      await dio.post('$baseUrl/friends/add', data: {
        'user_id': myId,
        'friend_user_id': friendId,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('친구가 추가되었습니다.')),
      );

      // 친구 목록 갱신
      await _fetchFriendsFromServer(userId: myId, token: token);
    } catch (e) {
      print('친구 추가 실패: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('친구 추가에 실패했습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredFriends = searchQuery.isEmpty
        ? friends
        : friends
        .where((friend) => friend.name
        .toLowerCase()
        .contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      body: isLoading || myProfile == null
          ? const Center(child: CircularProgressIndicator())
          : FriendListWidget(
        friends: filteredFriends,
        myProfile: myProfile!,
        onSearch: _searchFriends,
        onWakeUp: _wakeUpFriend,
        onFriendTap: _onFriendTap,
        onAddStory: _addStory,
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'add_friend',
            onPressed: _addFriend,
            backgroundColor: Colors.blue,
            shape: const CircleBorder(),
            tooltip: '친구 추가',
            child: const Icon(Icons.person_add, color: Colors.white),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'search_friend',
            onPressed: _showSearchDialog,
            backgroundColor: Colors.blue,
            shape: const CircleBorder(),
            tooltip: '친구 검색',
            child: const Icon(Icons.search, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

