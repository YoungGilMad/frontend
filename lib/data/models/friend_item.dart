class FriendItem {
  final String id;
  final String name;
  final int level;
  final String lastActive;
  final bool isOnline;
  final bool isPremium;
  final String? profileImage;
  bool hasStory;

  // ✅ 기본값 추가 (랭킹, 경험치)
  final int ranking;
  final int xp;

  // ✅ 기본값 추가 (스탯 정보)
  final int strength;
  final int agility;
  final int intelligence;
  final int stamina;

  FriendItem({
    required this.id,
    required this.name,
    required this.level,
    required this.lastActive,
    required this.isOnline,
    required this.isPremium,
    required this.profileImage,
    this.hasStory = false,
    required this.ranking,  // ✅ null 방지
    required this.xp,       // ✅ null 방지
    required this.strength,  // ✅ null 방지
    required this.agility,   // ✅ null 방지
    required this.intelligence, // ✅ null 방지
    required this.stamina,   // ✅ null 방지
  });
}
