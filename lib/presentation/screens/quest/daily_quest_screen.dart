import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../widgets/common/app_bar_widget.dart';
import '../../widgets/quest/quest_list_widget.dart';
import '/data/models/quest_item_model.dart';

class DailyQuestScreen extends StatefulWidget {
  // final int userId; // 사용자 ID

  // const DailyQuestScreen({super.key, required this.userId});

  const DailyQuestScreen({super.key});

  @override
  State<DailyQuestScreen> createState() => _DailyQuestScreenState();
}

class _DailyQuestScreenState extends State<DailyQuestScreen> {

  final List<QuestItemModel> _quests = [];
  // List<Map<String, dynamic>> _quests = [];

  final List<String> tags = [
    '운동 및 스포츠',
    '공부',
    '자기개발',
    '취미',
    '명상 및 스트레칭',
    '기타'
  ];

  final List<String> _days = ['월', '화', '수', '목', '금', '토', '일'];
  Map<String, bool> _selectedDays = {
    '월': false, '화': false, '수': false,
    '목': false, '금': false, '토': false, '일': false,
  };

  // @override
  // void initState() {
  //   super.initState();
  //   _fetchQuests(); // 앱 실행 시 퀘스트 불러오기
  // }

  // /// 백엔드 통신 함수 (HTTP)
  // // ✅ 퀘스트 리스트 조회 (GET 요청)
  // Future<void> _fetchQuests() async {
  //   final url = Uri.parse('https://localhost:8080/quest/info/${widget.userId}');
  //   final response = await http.get(url);
  //
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       _quests = List<Map<String, dynamic>>.from(json.decode(response.body));
  //     });
  //   } else {
  //     print("Error fetching quests: ${response.body}");
  //   }
  // }
  //
  // /// ✅ 새로운 퀘스트 생성 (POST 요청)
  // Future<void> _createQuest(String todo) async {
  //   final url = Uri.parse('https://localhost:8080/quest/self-gen/${widget.userId}');
  //   final response = await http.post(
  //     url,
  //     headers: {"Content-Type": "application/json"},
  //     body: json.encode({"todo": todo}),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     _fetchQuests(); // ✅ 퀘스트 다시 불러오기
  //   } else {
  //     print("Error creating quest: ${response.body}");
  //   }
  // }
  //
  // /// ✅ 퀘스트 완료 처리 (POST 요청)
  // Future<void> _completeQuest(int questId) async {
  //   final url = Uri.parse('https://localhost:8080/quest/self-clear/$questId');
  //   final response = await http.post(url);
  //
  //   if (response.statusCode == 200) {
  //     _fetchQuests(); // ✅ 완료 후 퀘스트 목록 갱신
  //   } else {
  //     print("Error completing quest: ${response.body}");
  //   }
  // }
  //
  // /// ✅ 퀘스트 삭제 (DELETE 요청)
  // Future<void> _deleteQuest(int questId) async {
  //   final url = Uri.parse('https://localhost:8080/quest/remove/$questId');
  //   final response = await http.delete(url);
  //
  //   if (response.statusCode == 200) {
  //     _fetchQuests(); // ✅ 삭제 후 퀘스트 목록 갱신
  //   } else {
  //     print("Error deleting quest: ${response.body}");
  //   }
  // }

  // 난이도
  String getDifficulty(int selectedHours) {
    if (selectedHours >= 0 && selectedHours < 2) {
      return 'easy'; // 0, 1
    } else if (selectedHours > 1 && selectedHours < 5) {
      return 'medium'; // 2, 3, 4
    } else if (selectedHours > 4 && selectedHours < 7) {
      return 'hard'; // 5, 6
    } else {
      return 'UNKNOWN'; // 범위를 벗어난 경우 기본값
    }
  }

  // 퀘스트 생성 다이얼로그
  void _showQuestCreationDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController contentController = TextEditingController();
    String? selectedTag = tags.first;
    int selectedHours = 1;
    int selectedMinutes = 0;

    showDialog(
      context: context, builder: (context) => StatefulBuilder(  // StatefulBuilder 추가
      builder: (context, setDialogState) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '퀘스트 생성',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                
                // 제목 입력
                Text(
                  "제목",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: '퀘스트 제목을 입력하세요.',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                
                // 내용 입력
                Text(
                  "내용",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: contentController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: '퀘스트 내용을 입력하세요',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 24),
                
                // 목표 시간 설정
                Text(
                  '목표 시간',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: selectedHours,
                        decoration: const InputDecoration(
                          labelText: '시간',
                          border: OutlineInputBorder(),
                        ),
                        items: List.generate(6, (i) => i + 1)
                            .map((h) => DropdownMenuItem(
                                  value: h,
                                  child: Text('$h시간'),
                                ))
                            .toList(),
                        onChanged: (value) => selectedHours = value!,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: selectedMinutes,
                        decoration: const InputDecoration(
                          labelText: '분',
                          border: OutlineInputBorder(),
                        ),
                        items: [0, 15, 30, 45]
                            .map((m) => DropdownMenuItem(
                                  value: m,
                                  child: Text('$m분'),
                                ))
                            .toList(),
                        onChanged: (value) => selectedMinutes = value!,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 태그 선택
                Text(
                  '태그',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedTag,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  items: tags
                      .map((tag) => DropdownMenuItem(
                            value: tag,
                            child: Text(tag),
                          ))
                      .toList(),
                  onChanged: (value) => selectedTag = value,
                ),
                const SizedBox(height: 24),

                // 요일 선택
                Text(
                  '반복 요일',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Wrap(
                  // key: ValueKey(_selectedDays.hashCode), // 강제 리빌드 -> 색상 초기화
                  spacing: 8,
                  children: _days.map((day) {
                    return GestureDetector(
                      onTap: () {
                        setDialogState(() {
                          _selectedDays[day] = !_selectedDays[day]!; // ✅ 클릭 시 즉시 상태 변경
                          // 디버깅 코드
                          print("선택된 요일: $_selectedDays");
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        decoration: BoxDecoration(
                          color: _selectedDays[day]! ? Theme.of(context).colorScheme.primary : Colors.grey[300], // ✅ 선택 시 색상 변경
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          day,
                          style: TextStyle(
                            color: _selectedDays[day]! ? Colors.white : Colors.black, // ✅ 선택 여부에 따라 텍스트 색 변경
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32),

                // 버튼
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('취소'),
                    ),
                    FilledButton.icon(
                      onPressed: () async {
                        await _generateAIQuest(
                          titleController,
                          contentController,
                              (tag) {
                            setState(() {
                              selectedTag = tag;
                            });
                          },
                              (h) {
                            setState(() {
                              selectedHours = h;
                            });
                          },
                              (m) {
                            setState(() {
                              selectedMinutes = m;
                            });
                          },
                        );
                      },
                      icon: const Icon(Icons.auto_awesome),
                      label: const Text('AI 추천'),
                    ),
                    FilledButton(
                      onPressed: () {
                        if (titleController.text.isEmpty) return;
                        
                        final newQuest = QuestItemModel(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          title: titleController.text,
                          description: contentController.text,
                          difficulty: getDifficulty(selectedHours),
                          deadline: null,
                          createdAt: DateTime.now(),
                        );

                        _selectedDays = {
                          '월': false, '화': false, '수': false,
                          '목': false, '금': false, '토': false, '일': false,
                        };

                        setState(() {
                          _addQuest(newQuest);
                          // 요일 리셋
                        });

                        Navigator.pop(context);
                      },
                      child: const Text('생성'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }

  // AI 퀘스트 생성 로직
  Future<void> _generateAIQuest(
      TextEditingController titleController,
      TextEditingController contentController,
      Function(String) onTagSelected,
      Function(int) onHoursSelected,
      Function(int) onMinutesSelected,
      ) async {
    const apiKey = 'YOUR_OPENAI_API_KEY'; // OpenAI API 키 입력
    const endpoint = 'https://api.openai.com/v1/chat/completions';

    final prompt = """
    사용자가 자기 계발을 위해 수행할 수 있는 퀘스트를 생성해줘.
    1. 정해진 리스트 내에서 태그를 랜덤으로 선택하고 태그가 선택되어 있으면 해당 태그값으로 지정,
    2. 지정된 태그에 맞는 제목과 내용을 너가 작성해주고,
    3. 작성한 내용에 적합한 목표 시간을 설정해줘.
    응답 형식은 JSON으로 다음 정보를 포함해야 해.
    {
      "title": "퀘스트 제목",
      "content": "퀘스트 설명",
      "hours": 목표 시간 (1~6),
      "minutes": 목표 분 단위 (0, 15, 30, 45 중 선택),
      "tag": "운동 및 스포츠 / 공부 / 자기개발 / 취미 / 명상 및 스트레칭 / 기타 중 하나"
    }
  """;

    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "model": "gpt-4",
          "messages": [
            {"role": "system", "content": "너는 사용자의 성장을 돕고 자기계발에 맞는 퀘스트를 작성하는 assistant야."},
            {"role": "user", "content": prompt}
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final generatedData = jsonDecode(data['choices'][0]['message']['content']);

        // API 응답을 안전하게 적용
        if (generatedData != null && generatedData is Map<String, dynamic>) {
          if (mounted) {
            setState(() {
              titleController.text = generatedData['title'] ?? '생성된 퀘스트';
              contentController.text = generatedData['content'] ?? '퀘스트 설명 없음';
            });

            // 콜백을 통해 값 업데이트
            onTagSelected(generatedData['tag'] ?? '기타');
            onHoursSelected(generatedData['hours'] ?? 1);
            onMinutesSelected(generatedData['minutes'] ?? 0);
          }
        }
      } else {
        print("API 요청 실패: ${response.statusCode}, 응답: ${response.body}");
      }
    } catch (error) {
      print("AI 퀘스트 생성 중 오류 발생: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget(
        title: '자기주도 퀘스트',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '자기주도 성장을 위한,\n내가 만드는 오늘의 퀘스트',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _showQuestCreationDialog,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text('자기주도 퀘스트 생성하기'),
                ),
              ],
            ),
          ),
          Expanded(
            child: QuestListWidget(
              quests: _quests,
              onQuestTap: _editQuest,
              onQuestComplete: _completeQuest,
              onQuestDelete: _deleteQuest,
            ),
          ),
        ],
      ),
    );
  }

  void _addQuest(QuestItemModel quest) {
    setState(() {
      _quests.insert(0, quest);
    });
  }

  void _editQuest(QuestItemModel quest) {
    // TODO: 퀘스트 수정 구현
  }

  void _completeQuest(QuestItemModel quest) {
    // ui
    setState(() {
      final index = _quests.indexWhere((q) => q.id == quest.id);
      if (index != -1) {
        _quests.removeAt(index);
      }
    });
  }

  void _deleteQuest(QuestItemModel quest) {
    // ui
    setState(() {
      _quests.removeWhere((q) => q.id == quest.id);
    });
  }
}

/**
 * 할 일
 * 1. 퀘스트 쌓이는 순서 위로 쌓이게 변경 v
 * - 생성하는 창 다시 키면 요일 다시 false로 v
 * 2. 클릭하면 퀘스트 상세정보창으로 넘어가게 변경
 * - 일단 ui는 구현 완료
 * 3. 난이도 관련 이슈 해결 -> 시간에 따라 정해지게 알고리즘
 * -
 * 4. 백엔드에 퀘스트 데이터 만들어지도록 설정
 * 5. 퀘스트 수정 및 삭제 기능 구현
 * - 악용 방지를 위해 퀘스트를 수정 시..?
 */