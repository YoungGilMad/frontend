import 'package:flutter/material.dart';
import '../../widgets/common/app_bar_widget.dart';
import '/data/models/quest_item_model.dart'; // ✅ 퀘스트 모델 import
import '../../widgets/quest/hero_quest_card_widget.dart';

class HeroQuestScreen extends StatefulWidget {
  const HeroQuestScreen({super.key});

  @override
  State<HeroQuestScreen> createState() => _HeroQuestScreenState();
}

class _HeroQuestScreenState extends State<HeroQuestScreen> {

  // ✅ 임시 퀘스트 데이터 리스트
  final List<QuestItemModel> _heroQuests = [
    QuestItemModel(
      id: '1',
      title: '내 전공에 맞는 공부',
      description: '내 전공에 맞는 공부를 2시간동안 진행하세요! 공부를 하고 나면 당신은 더욱 지적인 영웅이 되어 있을 거예요!',
      difficulty: 'hero',
      deadline: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 59), // 당일 자정
      createdAt: DateTime.now(),
      progressTime: Duration(hours: 1, minutes: 20, seconds: 11),
      totalTime: Duration(hours: 3),
      isCompleted: false,
      isHero: true,
    ),
    QuestItemModel(
      id: '2',
      title: '2시간 동안 운동',
      description: '운동을 2시간 동안 진행하세요! 운동을 하고 나면 당신은 더욱 강력한 영웅이 되어 있을 거예요!',
      difficulty: 'hero',
      deadline: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 59),
      createdAt: DateTime.now(),
      progressTime: Duration(hours: 3),
      totalTime: Duration(hours: 3),
      isCompleted: true,
      isHero: true,
    ),
    QuestItemModel(
      id: '3',
      title: '1시간 동안 명상',
      description: '명상을 2시간 동안 진행하세요! 명상을 하고 나면 당신은 더욱 현명한 영웅이 되어 있을 거예요!',
      difficulty: 'hero',
      deadline: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 59),
      createdAt: DateTime.now(),
      progressTime: Duration(hours: 3),
      totalTime: Duration(hours: 3),
      isCompleted: false,
      isHero: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBarWidget(
        title: '영웅 퀘스트',
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Text(
              "스승님께 받은 오늘의 영웅 퀘스트 목록",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              "지금 도전하고 영웅이 되어보세요!",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 4),
            // 퀘스트 리스트
            Expanded(
              child: HeroQuestList(quests: _heroQuests),
            ),
          ],
        ),
      ),
    );
  }

}

/**
 * 1. 새로고침
 */