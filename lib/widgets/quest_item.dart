// widgets/quest_item.dart
import 'package:flutter/material.dart';
import '../models/quest.dart';

class QuestItem extends StatelessWidget {
  final Quest quest;

  const QuestItem({required this.quest, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: quest.completed ? Colors.black : Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                quest.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: quest.completed ? Colors.white : Colors.black,
                ),
              ),
              Switch(
                value: quest.completed,
                onChanged: (value) {},
              ),
            ],
          ),
          if (quest.time != null)
            Text(
              quest.time!,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: quest.completed ? Colors.white : Colors.black,
              ),
            ),
          if (quest.details != null)
            Text(
              quest.details!,
              style: const TextStyle(color: Colors.black),
            ),
        ],
      ),
    );
  }
}