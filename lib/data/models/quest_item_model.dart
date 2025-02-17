
class QuestItem {
  final String id;
  final String title;
  final String description;
  final DateTime? deadline;
  final bool isCompleted;
  final String difficulty;
  final DateTime createdAt;

  QuestItem({
    required this.id,
    required this.title,
    required this.description,
    this.deadline,
    this.isCompleted = false,
    required this.difficulty,
    required this.createdAt,
  });
}