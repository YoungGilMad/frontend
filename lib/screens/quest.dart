// screens/quest.dart
import 'package:flutter/material.dart';
import 'quest_generator.dart';
import '../models/quest.dart';
import '../widgets/quest_item.dart';

class QuestScreen extends StatelessWidget {
  const QuestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Quest> quests = [
      Quest(title: '약 먹기', completed: true),
      Quest(title: '공부 2시간 하기', completed: true, time: '2:00:00 / 2:00:00'),
      Quest(title: '운동 2시간 하기', completed: false, time: '2:00:00 / 1:06:45', details: '어깨, 가슴 운동'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('퀘스트 목록')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '‘자기주도’ 성장을 위한,\n내가 만드는 오늘의 퀘스트 목록',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 32,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const QuestGenScreen()),
                    );
                  },
                  child: const Text('자기주도 퀘스트 생성하기!'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            ...quests.map((quest) => QuestItem(quest: quest)).toList(),
          ],
        ),
      ),
    );
  }
}