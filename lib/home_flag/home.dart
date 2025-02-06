import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../hero_quest/hero_quest_main.dart';
import '../daily_quest/daily_quest_main.dart';
import '../store/store_main.dart';

const String API_BASE_URL = 'http://127.0.0.1:8000'; // 실제 API URL로 변경해주세요
const String user = "user@example.com";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? profileImageUrl;
  final String _token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ1c2VyQGV4YW1wbGUuY29tIiwiZXhwIjoxNzM4ODIwNzU0fQ.wXVOMOK471J7yhukSp2ScDARzsKwYgn_QAWp537Rz5Q";

  @override
  void initState() {
    super.initState();
    _fetchProfileImage();
  }

  Future<void> _fetchProfileImage() async {
    try {
      final response = await http.get(
        Uri.parse('$API_BASE_URL/users/me/profile-image'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // 상대 경로를 전체 URL로 변환
        final fullImageUrl = '$API_BASE_URL/${data['profile_img']}';
        print('Full image URL: $fullImageUrl');  // 전체 URL 확인용

        setState(() {
          profileImageUrl = fullImageUrl;  // 전체 URL을 사용
        });
      }
    } catch (e) {
      print('Error fetching profile image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 40.0),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.grey,
                          backgroundImage: profileImageUrl != null
                              ? NetworkImage(profileImageUrl!)
                              : null,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'profile',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            decoration: TextDecoration.none,
                          ),
                        ),
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
                child: Text(
                  '게으른 강아지양',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),

            // 진행 상태 바
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '궁극의 경지',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: 0.7,
                    backgroundColor: Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
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
        child: Text(
          text,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}