import 'package:flutter/material.dart';
import '../../../data/models/friend_item.dart';
import 'friend_chat_screen.dart';

class FriendProfileScreen extends StatelessWidget {
  final String name;
  final int level;
  final int ranking;
  final int xp;
  final int maxXp;
  final int strength;
  final int agility;
  final int intelligence;
  final int stamina;
  final String? profileImage;
  final List<String> stories;
  final FriendItem? friend;

  const FriendProfileScreen({
    super.key,
    required this.name,
    required this.level,
    required this.ranking,
    required this.xp,
    required this.maxXp,
    required this.strength,
    required this.agility,
    required this.intelligence,
    required this.stamina,
    this.profileImage,
    this.stories = const [],
    this.friend,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$name의 프로필'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              // 👤 프로필 정보
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: profileImage != null ? NetworkImage(profileImage!) : null,
                    child: profileImage == null
                        ? const Icon(Icons.person, size: 40, color: Colors.grey)
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text('랭킹 $ranking위',
                          style: const TextStyle(fontSize: 14, color: Colors.grey)),
                      Text('Lv. $level',
                          style: const TextStyle(fontSize: 14, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 💬 메시지 버튼
              SizedBox(
                width: double.infinity,
                height: 42,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (friend != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FriendChatScreen(friend: friend!),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
                  label: const Text(
                    '메시지 보내기',
                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 3,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 📊 능력치 카드
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatItem(Icons.fitness_center, "힘", strength),
                  _buildStatItem(Icons.directions_run, "민첩", agility),
                  _buildStatItem(Icons.psychology, "지능", intelligence),
                  _buildStatItem(Icons.favorite, "체력", stamina),
                ],
              ),

              const SizedBox(height: 32),

              // 📸 스토리 제목
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '$name의 스토리',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // 🖼 스토리 그리드
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: stories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      stories[index],
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: Colors.grey[200],
                          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, int value) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              Icon(icon, size: 26, color: Colors.blue),
              const SizedBox(height: 4),
              Text('$value',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text(label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
