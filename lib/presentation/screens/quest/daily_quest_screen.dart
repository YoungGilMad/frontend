import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../widgets/common/app_bar_widget.dart';
import '../../widgets/quest/quest_list_widget.dart';

class DailyQuestScreen extends StatefulWidget {
  const DailyQuestScreen({super.key});

  @override
  State<DailyQuestScreen> createState() => _DailyQuestScreenState();
}

class _DailyQuestScreenState extends State<DailyQuestScreen> {
  final List<QuestItem> _quests = [];
  final List<String> tags = [
    '운동 및 스포츠',
    '공부',
    '자기개발',
    '취미',
    '명상 및 스트레칭',
    '기타'
  ];

  final List<String> _days = ['월', '화', '수', '목', '금', '토', '일'];
  final Map<String, bool> _selectedDays = {
    '월': false, '화': false, '수': false,
    '목': false, '금': false, '토': false, '일': false,
  };

  void _showQuestCreationDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController contentController = TextEditingController();
    String? selectedTag = tags.first;
    int selectedHours = 1;
    int selectedMinutes = 0;

    showDialog(
      context: context,
      builder: (context) => Dialog(
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
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: '제목',
                    hintText: '퀘스트 제목을 입력하세요',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                
                // 내용 입력
                TextField(
                  controller: contentController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: '내용',
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
                  spacing: 8,
                  children: _days.map((day) {
                    return FilterChip(
                      label: Text(day),
                      selected: _selectedDays[day]!,
                      onSelected: (bool selected) {
                        setState(() {
                          _selectedDays[day] = selected;
                        });
                      },
                      selectedColor: Theme.of(context).colorScheme.primary,
                      checkmarkColor: Colors.white,
                      labelStyle: TextStyle(
                        color: _selectedDays[day]!
                            ? Colors.white
                            : Theme.of(context).textTheme.bodyMedium?.color,
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
                        
                        final newQuest = QuestItem(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          title: titleController.text,
                          description: contentController.text,
                          difficulty: 'medium',
                          deadline: null,
                          createdAt: DateTime.now(),
                        );

                        setState(() {
                          _quests.add(newQuest);
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

  void _editQuest(QuestItem quest) {
    // TODO: 퀘스트 수정 구현
  }

  void _completeQuest(QuestItem quest) {
    setState(() {
      final index = _quests.indexWhere((q) => q.id == quest.id);
      if (index != -1) {
        _quests.removeAt(index);
      }
    });
  }

  void _deleteQuest(QuestItem quest) {
    setState(() {
      _quests.removeWhere((q) => q.id == quest.id);
    });
  }
}
