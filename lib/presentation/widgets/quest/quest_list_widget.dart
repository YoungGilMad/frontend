import 'package:flutter/material.dart';

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

class QuestListWidget extends StatelessWidget {
  final List<QuestItem> quests;
  final Function(QuestItem)? onQuestTap;
  final Function(QuestItem)? onQuestComplete;
  final Function(QuestItem)? onQuestDelete;

  const QuestListWidget({
    super.key,
    required this.quests,
    this.onQuestTap,
    this.onQuestComplete,
    this.onQuestDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (quests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              '아직 등록된 퀘스트가 없습니다',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              '새로운 퀘스트를 추가해보세요!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: quests.length,
      itemBuilder: (context, index) {
        final quest = quests[index];
        return Dismissible(
          key: Key(quest.id),
          background: Container(
            color: Colors.green,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Icon(Icons.check_circle, color: Colors.white),
          ),
          secondaryBackground: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (direction) {
            if (direction == DismissDirection.startToEnd) {
              onQuestComplete?.call(quest);
            } else {
              onQuestDelete?.call(quest);
            }
          },
          child: Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: ListTile(
              onTap: () => onQuestTap?.call(quest),
              leading: Icon(
                quest.isCompleted
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color: quest.isCompleted ? Colors.green : Colors.grey,
              ),
              title: Text(
                quest.title,
                style: TextStyle(
                  decoration:
                      quest.isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(quest.description),
                  if (quest.deadline != null)
                    Text(
                      '마감: ${_formatDeadline(quest.deadline!)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: _isDeadlineNear(quest.deadline!)
                                ? Colors.red
                                : Colors.grey,
                          ),
                    ),
                ],
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getDifficultyColor(quest.difficulty).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  quest.difficulty,
                  style: TextStyle(
                    color: _getDifficultyColor(quest.difficulty),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDeadline(DateTime deadline) {
    final now = DateTime.now();
    final difference = deadline.difference(now);

    if (difference.inDays > 0) {
      return '${difference.inDays}일 남음';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}시간 남음';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}분 남음';
    } else {
      return '마감 임박';
    }
  }

  bool _isDeadlineNear(DateTime deadline) {
    final now = DateTime.now();
    final difference = deadline.difference(now);
    return difference.inHours < 24 && difference.isNegative == false;
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}