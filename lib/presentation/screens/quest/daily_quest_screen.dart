// lib/presentation/screens/quest/daily_quest_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../widgets/common/app_bar_widget.dart';
import '../../widgets/quest/quest_list_widget.dart';
import '/data/models/quest_item_model.dart';
import '/presentation/providers/auth_provider.dart';
import '/presentation/providers/daily_quest_provider.dart';
import '/presentation/widgets/quest/quest_creation_dialog_widget.dart';

class DailyQuestScreen extends StatelessWidget {
  const DailyQuestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    if (user == null) {
      return Scaffold(body: Center(child: Text("로그인이 필요합니다.")));
    }

    return ChangeNotifierProvider(
      create: (_) => DailyQuestProvider(
        userId: user.id,
        authToken: authProvider.token ?? '',
      ),
      child: const _DailyQuestContent(),
    );
  }
}

class _DailyQuestContent extends StatelessWidget {
  const _DailyQuestContent({super.key});

  @override
  Widget build(BuildContext context) {
    final questProvider = Provider.of<DailyQuestProvider>(context);

    return Scaffold(
      appBar: AppBarWidget(title: '자기주도 퀘스트'),
      body: Column(
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
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => QuestCreationDialog(
                        onQuestCreated: (quest) => questProvider.addQuest(quest),
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text(
                      '자기주도 퀘스트 생성하기',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: QuestListWidget(
              quests: questProvider.quests,
              onQuestTap: (quest) => {}, // 수정 기능 예정
              onQuestComplete: questProvider.completeQuest,
              onQuestDelete: questProvider.deleteQuest,
            ),
          ),
        ],
      ),
    );
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