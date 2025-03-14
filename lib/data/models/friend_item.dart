class FriendItem {
  final String id;
  final String name;
  final int level;
  final String lastActive;
  final bool isOnline;
  final bool isPremium;
  final String? profileImage;
  bool hasStory; // 스토리 여부 필드 추가

  FriendItem({
    required this.id,
    required this.name,
    required this.level,
    required this.lastActive,
    required this.isOnline,
    required this.isPremium,
    required this.profileImage,
    this.hasStory = false, // 기본값 false
  });
}
