// quest_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/quest/quest_clear_dialog_widget.dart';
import '/data/models/quest_item_model.dart';
import 'package:app_beh/presentation/providers/quest_timer_provider.dart';

class QuestDetailScreen extends StatefulWidget {
  final QuestItemModel quest;
  const QuestDetailScreen({super.key, required this.quest});

  @override
  State<QuestDetailScreen> createState() => _QuestDetailScreenState();
}

class _QuestDetailScreenState extends State<QuestDetailScreen> {
  @override
  void initState() {
    super.initState();
    final timerProvider = Provider.of<QuestTimerProvider>(context, listen: false);
    final questId = widget.quest.id;

    timerProvider.initialize(
      questId: questId,
      progressSeconds: widget.quest.progressTime.inSeconds,
      totalSeconds: widget.quest.completeTime.inSeconds > 0
          ? widget.quest.completeTime.inSeconds
          : 1,
    );

    if (!timerProvider.isRunning(questId)) {
      timerProvider.start(questId, onComplete: () {
        showCelebrationDialog(context); // ✅ 완료 시 축하 팝업
        // TODO: 퀘스트 완료에 따른 데이터 변경 (예: 서버 통신, 상태 업데이트)
      });
    }
  }

  String formatDuration(Duration duration) {
    final h = duration.inHours.toString().padLeft(2, '0');
    final m = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final timer = context.watch<QuestTimerProvider>();
    final questId = widget.quest.id;

    final clampedElapsedSeconds = timer.getElapsed(questId).clamp(0, timer.getComplete(questId));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quest.questType == 'hero' ? "영웅 퀘스트" : "자기주도 퀘스트"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.quest.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Text(widget.quest.description, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 16),

            Text(
              "${formatDuration(Duration(seconds: clampedElapsedSeconds))} / "
                  "${formatDuration(Duration(seconds: timer.getComplete(questId)))}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            LinearProgressIndicator(
              value: timer.getProgress(questId),
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            const SizedBox(height: 16),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  timer.isRunning(questId)
                      ? timer.pause(questId)
                      : timer.start(questId);
                },
                child: Icon(
                  timer.isRunning(questId) ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
