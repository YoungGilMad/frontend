import 'package:flutter/material.dart';

class QuestGenScreen extends StatefulWidget {
  const QuestGenScreen({super.key});

  @override
  _QuestGenScreenState createState() => _QuestGenScreenState();
}

class _QuestGenScreenState extends State<QuestGenScreen> {

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final List<String> _days = ['월', '화', '수', '목', '금', '토', '일'];
  final Map<String, bool> _selectedDays = {
    '월': false,
    '화': false,
    '수': false,
    '목': false,
    '금': false,
    '토': false,
    '일': false,
  };

  // 목표시간
  int _selectedHour = 1; // 초기 선택값
  int _selectedMinute = 0; // 초기 선택값
  final List<int> minuteOptions = [0, 15, 30, 45]; // 0, 2, 4, 6
  // 태그 값 변수
  String? selectedTag;
  // 요일 선택
  Widget _buildDayButton(String day) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDays[day] = !_selectedDays[day]!;
        });
      },
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: _selectedDays[day]! ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          day,
          style: TextStyle(
            color: _selectedDays[day]! ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('퀘스트 생성'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('제목', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextField(controller: _titleController),
            SizedBox(height: 16),
            Text('내용', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            TextField(
              controller: _contentController,
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Text('목표시간', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Row(
              children: [
                // 시간 선택 드롭다운
                DropdownButton<int>(
                  value: _selectedHour,
                  items: List.generate(6, (index) { // 0~6 시간 범위
                    return DropdownMenuItem(
                      value: index + 1,
                      child: Text('${index + 1} 시간'),
                    );
                  }),
                  onChanged: (value) {
                    setState(() {
                      _selectedHour = value!;
                    });
                  },
                ),
                SizedBox(width: 8),
                // 분 선택 드롭다운
                DropdownButton<int>(
                  value: _selectedMinute,
                  items: minuteOptions.map((value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text('$value 분'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedMinute = value!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Text('태그', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: selectedTag,
              hint: Text('태그를 선택하세요'),
              items: [
                DropdownMenuItem(value: 'exercise or sports', child: Text('운동 및 스포츠')),
                DropdownMenuItem(value: 'study', child: Text('공부')),
                DropdownMenuItem(value: 'self development', child: Text('자기개발')),
                DropdownMenuItem(value: 'hobby', child: Text('취미')),
                DropdownMenuItem(value: 'meditation and stretching', child: Text('명상 및 스트레칭')),
                DropdownMenuItem(value: 'other', child: Text('기타')),
              ],
              onChanged: (value) {
                setState(() {
                  selectedTag = value;
                });
              },
            ),
            SizedBox(height: 16),
            Text('요일', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Wrap(
              children: _days.map((day) => _buildDayButton(day)).toList(),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // ai 퀘스트 자동 생성 로직 -> 빈칸 채우기
              },
              child: Text('AI 퀘스트 자동 생성'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // 퀘스트 생성 로직 (db업데이트 -> servies/quest.dart)
              },
              child: Text('자기주도 퀘스트 생성하기!'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent, // 버튼 배경색
                foregroundColor: Colors.white, // 텍스트 색상
                minimumSize: Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
