import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../../widgets/quest/quest_clear_dialog_widget.dart';
import '/data/models/quest_item_model.dart';
import 'package:app_beh/presentation/providers/auth_provider.dart';

class QuestDetailScreen extends StatefulWidget {
  final QuestItemModel quest;
  const QuestDetailScreen({super.key, required this.quest});

  @override
  _QuestDetailScreenState createState() => _QuestDetailScreenState();
}

class _QuestDetailScreenState extends State<QuestDetailScreen> {
  late Timer _timer;
  late int _elapsedSeconds; // 진행 시간 (초)
  late int _completeSeconds;   // 완료 시간 (초)
  bool _isRunning = true;

  @override
  void initState() {
    super.initState();
    _elapsedSeconds = widget.quest.progressTime.inSeconds; // ✅ quest에서 진행시간 가져오기
    _completeSeconds = widget.quest.completeTime.inSeconds > 0 ? widget.quest.completeTime.inSeconds : 1; // ✅ 완료시간 가져오기
    _startTimer();
  }

  void _onQuestComplete() {
    // 팝업 or 애니메이션 or 서버 전송 등
    showCelebrationDialog(context); // 예: 빵빠레 팝업
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_elapsedSeconds < _completeSeconds) {
        setState(() => _elapsedSeconds++);
      } else {
        _timer.cancel(); // 완료 시 타이머 중지
        _onQuestComplete();
      }
    });
  }

  void _toggleTimer() {
    setState(() {
      if (_isRunning) {
        _timer.cancel();
      } else {
        _startTimer();
      }
      _isRunning = !_isRunning;
    });
  }

  double _getProgress() => (_elapsedSeconds / _completeSeconds).clamp(0.0, 1.0);

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String formatTime(int seconds) {
    final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$secs";
  }

  String formatDuration(Duration duration) {
    final h = duration.inHours.toString().padLeft(2, '0');
    final m = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.quest.questType == 'hero'? "영웅 퀘스트" : "자기주도 퀘스트")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ 퀘스트 제목
            Text(
              widget.quest.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // ✅ 퀘스트 설명
            Text(widget.quest.description, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 16),

            // ✅ 진행 시간 / 완료 시간 표시
            Text(
              "${formatDuration(Duration(seconds: _elapsedSeconds))} / ${formatDuration(widget.quest.completeTime)}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // ✅ 진행률 표시
            LinearProgressIndicator(
              value: _getProgress(),
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            const SizedBox(height: 16),

            // ✅ 타이머 제어 버튼
            Center(
              child: ElevatedButton(
                onPressed: _toggleTimer,
                child: Icon(
                  _isRunning ? Icons.pause : Icons.play_arrow,
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

/*
- 간단한 구조
제목
내용
현재 진행 시간 / 목표 시간
시간을 보여주는 프로그레스바
일시정지 버튼(클릭 시 재생 버튼으로 바뀜)

기능 1.
퀘스트 리스트 중 하나를 클릭하면 이 창이 시작됨.
이 창이 시작되면, 타이머 및 프로그레스바가 진행됨.

기능 2.
일시정지 버튼을 누르면 타이머와 프로그레스바가 멈추고 버튼이 재생 버튼으로 바뀜

기능 3.
퀘스트 완료 시 보상 기능 구현
 */
