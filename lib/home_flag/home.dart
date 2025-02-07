import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../hero_quest/hero_quest_main.dart';
import '../daily_quest/daily_quest_main.dart';
import '../store/store_main.dart';

const String API_BASE_URL = 'http://127.0.0.1:8000'; // 애뮬레이터: 10.0.2.2
const String user = "user@example.com"; // 임시 유저 정보

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userId;
  String? profileImageUrl;
  String? profileName; // 프로필 이름 저장 변수
  int heroLevel = 1;
  int expPoints = 0;
  final String _token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ1c2VyQGV4YW1wbGUuY29tIiwiZXhwIjoxNzM4ODM3NDY5fQ.ybqidlupBtPyTGeWr7gy7VjQwkHM-F4Y4zJxL1EVG_g";

  // 캘린더 관련 변수
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _fetchProfileImage();
    _fetchProfileName();
    _fetchHeroLevel();
    _selectedDay = _focusedDay;
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
        final fullImageUrl = '$API_BASE_URL/${data['profile_img']}';

        setState(() {
          profileImageUrl = fullImageUrl;
        });
      }
    } catch (e) {
      print('Error fetching profile image: $e');
    }
  }

  Future<void> _fetchProfileName() async {
    try {
      final response = await http.get(
        Uri.parse('$API_BASE_URL/users/me/user-name'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final utf8Decoded = utf8.decode(response.bodyBytes);
        final data = jsonDecode(utf8Decoded);
        setState(() {
          profileName = data['name'];
        });
      }
    } catch (e) {
      print('Error fetching profile name: $e');
    }
  }

  Future<void> _fetchHeroLevel() async {
    try {
      final parts = _token.split('.');
      if (parts.length == 3) {
        final payload = parts[1];
        final normalized = base64Url.normalize(payload);
        final resp = utf8.decode(base64Url.decode(normalized));
        final payloadMap = json.decode(resp);

        if (payloadMap.containsKey('user_id')) {
          setState(() {
            userId = payloadMap['user_id'].toString();
          });
        }
      }
      final response = await http.get(
        Uri.parse('$API_BASE_URL/hero/level/$userId'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          heroLevel = data['current_level'];
          // 현재 레벨에서의 경험치를 100으로 나눈 나머지를 저장
          expPoints = data['total_exp_gained'] % 100;
        });
      }
    } catch (e) {
      print('Error fetching hero level: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            _buildProfileHeader(),
            _buildCharacterSection(),
            _buildProgressBar(),
            _buildGrayContainer1(), // ✅ 첫 번째 회색 컨테이너 추가
            _buildGrayContainer2(), // ✅ 두 번째 회색 컨테이너 추가
            _buildCalendarContainer(), // ✅ 캘린더 추가
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
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
                  backgroundImage: profileImageUrl != null ? NetworkImage(profileImageUrl!) : null,
                ),
                const SizedBox(width: 8),
                Text(
                  profileName ?? 'Loading...',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
            Column(
              children: [
                _buildIconButton(Icons.stars, () => _navigateTo(const HeroQuestMainScreen())),
                _buildIconButton(Icons.calendar_today, () => _navigateTo(const DailyQuestMainScreen())),
                _buildIconButton(Icons.store, () => _navigateTo(const StoreMainScreen())),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      color: Colors.black,
    );
  }

  void _navigateTo(Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen));
  }



  Widget _buildCharacterSection() {
    return Container(
      height: 200,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: const Center(
        child: Text(
          '게으른 강아지양',
          style: TextStyle(fontSize: 15, color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '궁극의 경지',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                ),
              ),
              Text(
                'Lv.$heroLevel',  // 레벨 표시
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinearProgressIndicator(
                value: expPoints / 100,  // 경험치를 백분율로 변환
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                minHeight: 10,  // 프로그레스 바 높이 조정
              ),
              const SizedBox(height: 4),
              Text(
                '$expPoints/100 EXP',  // 경험치 수치 표시
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 첫 번째 회색 컨테이너
  Widget _buildGrayContainer1() {
    return Container(
      height: 150,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

// 두 번째 회색 컨테이너
  Widget _buildGrayContainer2() {
    return Container(
      height: 150,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  // ✅ 캘린더 컨테이너
  Widget _buildCalendarContainer() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            spreadRadius: 2,
          ),
        ],
      ),
      child: _buildCalendar(),
    );
  }

  // ✅ TableCalendar 적용
  Widget _buildCalendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2023, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
      calendarStyle: CalendarStyle(
        selectedDecoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color: Colors.orange,
          shape: BoxShape.circle,
        ),
      ),
      headerStyle: HeaderStyle(
        formatButtonVisible: true,
        titleCentered: true,
      ),
    );
  }
}
