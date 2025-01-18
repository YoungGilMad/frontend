// home_tab/home.dart
import 'package:flutter/material.dart';
import '../hero_quest/hero_quest_main.dart';
import '../daily_quest/daily_quest_main.dart';
import '../store/store_main.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            // 상단 프로필 영역

            Container(
              margin: const EdgeInsets.only(top: 40.0),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,  // 상단 정렬을 위해 추가
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          // 여기에 이미지 url 넣으면 됨
                          radius: 15,
                          backgroundColor: Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text('profile', style: TextStyle(fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            decoration: TextDecoration.none)),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const HeroQuestMainScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.stars),
                          color: Colors.black,
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const DailyQuestMainScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.calendar_today),
                          color: Colors.black,
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const StoreMainScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.store),
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 캐릭터 이미지 영역
            Container(
              height: 200,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: const Center(
                child: Text('게으른 강아지양',
                    style: TextStyle(fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                        decoration: TextDecoration.none)
                ),
              ),
            ),

            // 진행 상태 바
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('궁극의 경지', style: TextStyle(fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      decoration: TextDecoration.none)),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: 0.7,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ],
              ),
            ),

            // 그래프 영역
            Container(
              height: 200,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
            ),

            // 텍스트 영역
            Container(
              height: 200,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
            ),

            // 하단 버튼들
            Container(
              height: 200,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
            ),

            const SizedBox(height: 32), // 하단 여백
          ],
        ),
      ),
    );
  }

  Widget _buildBar(double height, {bool isHighlighted = false}) {
    return Container(
      width: 30,
      height: 150 * height,
      decoration: BoxDecoration(
        color: isHighlighted ? Colors.blue : Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildButton(String text, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(text,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}