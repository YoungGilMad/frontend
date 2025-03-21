import 'package:flutter/material.dart';

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
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$name의 프로필')),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // 프로필 이미지
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.yellow[200],
            backgroundImage: profileImage != null ? NetworkImage(profileImage!) : null,
            child: profileImage == null ? const Icon(Icons.person, size: 50, color: Colors.grey) : null,
          ),
          const SizedBox(height: 16),

          // 이름 및 레벨
          Text(
            name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            'Lv. $level',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
          ),

          // 랭킹 및 경험치
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.emoji_events, color: Colors.blue, size: 20),
                            const SizedBox(width: 6),
                            Text('랭킹 $ranking위', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Text('$xp / $maxXp XP', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: xp / maxXp,
                      backgroundColor: Colors.grey[300],
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 능력치
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem(Icons.fitness_center, "힘", strength),
                _buildStatItem(Icons.directions_run, "민첩", agility),
                _buildStatItem(Icons.psychology, "지능", intelligence),
                _buildStatItem(Icons.favorite, "체력", stamina),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, int value) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Icon(icon, size: 28, color: Colors.blue),
              const SizedBox(height: 4),
              Text('$value', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
