class GroupItem {
  final String id;
  final String name;
  final String? description;
  final int memberCount;
  final bool isOwner;
  final int completedQuests;
  final int weeklyGrowth;
  final int ranking;
  final List<ActiveMember> activeMembers;

  const GroupItem({
    required this.id,
    required this.name,
    this.description,
    required this.memberCount,
    this.isOwner = false,
    this.completedQuests = 0,
    this.weeklyGrowth = 0,
    this.ranking = 0,
    this.activeMembers = const [],
  });
}

class ActiveMember {
  final String id;
  final String name;
  final String photoUrl;

  const ActiveMember({
    required this.id,
    required this.name,
    required this.photoUrl,
  });
}