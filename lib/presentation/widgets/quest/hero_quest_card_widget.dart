import 'package:flutter/material.dart';
import '../../screens/quest/quest_detail_screen.dart';
import '/data/models/quest_item_model.dart';

class HeroQuestList extends StatelessWidget {
  final List<QuestItemModel> quests;

  const HeroQuestList({super.key, required this.quests});

  @override
  Widget build(BuildContext context) {
    // ✅ 진행중 & 완료된 퀘스트 분리
    final ongoingQuests = quests.where((quest) => !quest.isCompleted).toList();
    final completedQuests = quests.where((quest) => quest.isCompleted).toList();

    // ✅ 진행중 퀘스트가 먼저, 완료된 퀘스트가 나중에 표시
    final sortedQuests = [...ongoingQuests, ...completedQuests];

    return sortedQuests.isNotEmpty
        ? ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: sortedQuests.length,
      itemBuilder: (context, index) {
        final quest = sortedQuests[index];
        final isCompleted = quest.isCompleted;

        return Opacity(
          opacity: isCompleted ? 0.5 : 1.0, // ✅ 완료된 퀘스트는 투명도 조정
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuestDetailScreen(quest: quest),
                  ),
                );
              },
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              quest.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              quest.description,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isCompleted ? "완료!" : "진행중",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isCompleted ? Colors.green : Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    )
        : const Center(
      child: Text(
        '퀘스트가 없습니다.',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }
}

