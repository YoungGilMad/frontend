import 'package:flutter/material.dart';
import '../../../data/models/group_item.dart';
import 'friend_profile_screen.dart';
import '../../../data/models/friend_item.dart';
import 'group_chat_screen.dart'; // ✅ group_chat 스크린 import

class RoomWidget extends StatelessWidget {
  final GroupItem group;

  const RoomWidget({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final int completedQuests = 4;
    final int totalQuests = 5;
    final String timeElapsed = "00:00:00";

    final List<FriendItem> dummyFriends = [
      FriendItem(
        id: '1',
        name: 'Alice',
        level: 5,
        profileImage: null,
        hasStory: true,
        ranking: 1,
        xp: 3000,
        strength: 15,
        agility: 14,
        intelligence: 18,
        stamina: 20,
      ),
      FriendItem(
        id: '2',
        name: 'Bob',
        level: 4,
        profileImage: null,
        hasStory: false,
        ranking: 2,
        xp: 2500,
        strength: 13,
        agility: 15,
        intelligence: 17,
        stamina: 18,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(group.name)),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Column(
                  children: [
                    const Text(
                      "나의 진행",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "퀘스트 $completedQuests/$totalQuests",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "시간 $timeElapsed",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.only(bottom: 100), // 버튼 가려지지 않게 여유 공간 확보
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: dummyFriends.length,
                    itemBuilder: (context, index) {
                      final friend = dummyFriends[index];

                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FriendProfileScreen(
                                    name: friend.name,
                                    level: friend.level,
                                    ranking: friend.ranking,
                                    xp: friend.xp,
                                    maxXp: friend.level * 1000,
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
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.grey,
                              backgroundImage: friend.profileImage != null
                                  ? NetworkImage(friend.profileImage!)
                                  : null,
                              child: friend.profileImage == null
                                  ? const Icon(Icons.person, color: Colors.white)
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text("퀘스트 3/5", style: const TextStyle(fontSize: 14)),
                          Text("시간 00:00:00", style: const TextStyle(fontSize: 14)),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // 💬 대화 참여하기 버튼을 화면 하단 고정 + 살짝 띄움
          Positioned(
            bottom: 48, // 👈 여백 조절해서 위로 띄움
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 42,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GroupChatScreen(group: group),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
                  label: const Text(
                    '대화 참여하기',
                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
