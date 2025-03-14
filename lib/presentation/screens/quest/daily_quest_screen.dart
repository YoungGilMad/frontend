import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as legacy_provider;
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import '../../widgets/common/app_bar_widget.dart';
import '../../widgets/quest/quest_list_widget.dart';
import '/data/models/quest_item_model.dart';
import 'package:app_beh/presentation/providers/auth_provider.dart';
import 'package:app_beh/presentation/widgets/quest/quest_creation_dialog_widget.dart';

class DailyQuestScreen extends StatefulWidget {

  const DailyQuestScreen({super.key});

  @override
  State<DailyQuestScreen> createState() => _DailyQuestScreenState();
}

class _DailyQuestScreenState extends State<DailyQuestScreen> {
  late int userId; // ✅ userId 동적으로 설정
  late String authToken; // ✅ JWT 인증 토큰
  final String apiBaseUrl = "https://behero/quest"; // 🔹 백엔드 URL

  List<QuestItemModel> _quests = [];
  // List<Map<String, dynamic>> _quests = [];

  // final List<String> tags = [
  //   '운동 및 스포츠',
  //   '공부',
  //   '자기개발',
  //   '취미',
  //   '명상 및 스트레칭',
  //   '기타'
  // ];
  //
  // final List<String> _days = ['월', '화', '수', '목', '금', '토', '일'];
  // Map<String, bool> _selectedDays = {
  //   '월': false, '화': false, '수': false,
  //   '목': false, '금': false, '토': false, '일': false,
  // };


  @override
  void initState() {
    super.initState();
    _initializeUserData(); // ✅ userId 및 토큰 설정 후 퀘스트 가져오기
  }

  /// ✅ `userId`와 `authToken` 설정
  void _initializeUserData() {
    final authProvider = legacy_provider.Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.user != null) {
      userId = authProvider.user!.id;
      authToken = authProvider.token ?? ''; // 토큰이 없을 경우 빈 문자열 처리
      _fetchQuests(); // ✅ 데이터 가져오기
    } else {
      print("❌ 유저 정보 없음, 로그인 필요");
    }
  }

  /// 퀘스트 생성 다이얼로그 호출
  void _showQuestCreationDialog() {
    showDialog(
      context: context,
      builder: (context) => QuestCreationDialog(
        onQuestCreated: _addQuest, // ✅ 생성된 퀘스트를 리스트에 추가하는 콜백 함수 전달
      ),
    );
  }

  /// ✅ [GET] 사용자 퀘스트 가져오기
  Future<void> _fetchQuests() async {
    try {
      final response = await http.get(
        Uri.parse('$apiBaseUrl/list/$userId'), // 🔹 {user_id}를 실제 유저 ID로 변경해야 함
        headers: {'Authorization': 'Bearer $authToken'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _quests = data.map((json) => QuestItemModel.fromJson(json)).toList();
        });
      } else {
        print("퀘스트 불러오기 실패: ${response.statusCode}, 응답: ${response.body}");
      }
    } catch (error) {
      print("퀘스트 불러오는 중 오류 발생: $error");
    }
  }

  /// ✅ [POST] 퀘스트 생성
  Future<void> _addQuest(QuestItemModel quest) async {
    try {
      final response = await http.post(
        Uri.parse('$apiBaseUrl/self-gen/$userId'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(quest.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newQuest = QuestItemModel.fromJson(data['quest']);
        setState(() {
          _quests.insert(0, newQuest);
        });
      } else {
        print("퀘스트 생성 실패: ${response.statusCode}, 응답: ${response.body}");
      }
    } catch (error) {
      print("퀘스트 생성 중 오류 발생: $error");
    }
  }

  /// ✅ [PUT] 퀘스트 완료 처리
  Future<void> _completeQuest(QuestItemModel quest) async {
    try {
      final response = await http.put(
        Uri.parse('$apiBaseUrl/self-clear/${quest.id}'),
        headers: {'Authorization': 'Bearer $authToken'},
      );

      if (response.statusCode == 200) {
        setState(() {
          _quests.removeWhere((q) => q.id == quest.id);
        });
      } else {
        print("퀘스트 완료 처리 실패: ${response.statusCode}, 응답: ${response.body}");
      }
    } catch (error) {
      print("퀘스트 완료 처리 중 오류 발생: $error");
    }
  }

  /// ✅ [DELETE] 퀘스트 삭제
  Future<void> _deleteQuest(QuestItemModel quest) async {
    try {
      final response = await http.delete(
        Uri.parse('$apiBaseUrl/remove/${quest.id}'),
        headers: {'Authorization': 'Bearer $authToken'},
      );

      if (response.statusCode == 200) {
        setState(() {
          _quests.removeWhere((q) => q.id == quest.id);
        });
      } else {
        print("퀘스트 삭제 실패: ${response.statusCode}, 응답: ${response.body}");
      }
    } catch (error) {
      print("퀘스트 삭제 중 오류 발생: $error");
    }
  }

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

  void _editQuest(QuestItemModel quest) {
    // TODO: 퀘스트 수정 구현
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