class FriendItem {
  final String id;
  final String name;
  final int level;
  final String? profileImage;
  bool hasStory;

  final int ranking;
  final int xp;

  final int strength;
  final int agility;
  final int intelligence;
  final int stamina;

  FriendItem({
    required this.id,
    required this.name,
    required this.level,
    required this.profileImage,
    this.hasStory = false,
    required this.ranking,
    required this.xp,
    required this.strength,
    required this.agility,
    required this.intelligence,
    required this.stamina,
  });

  // ✅ fromJson 팩토리 메서드 추가
  factory FriendItem.fromJson(Map<String, dynamic> json) {
    return FriendItem(
      id: json['id'].toString(),
      name: json['name'],
      level: json['level'] ?? 0,
      profileImage: json['profile_img'],
      hasStory: false,
      ranking: json['ranking'] ?? 0,
      xp: json['xp'] ?? 0,
      strength: json['strength'] ?? 0,
      agility: json['agility'] ?? 0,
      intelligence: json['intelligence'] ?? 0,
      stamina: json['stamina'] ?? 0,
    );
  }
}
