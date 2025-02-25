import 'package:flutter/material.dart';
import 'dart:async';
import '../../widgets/quest/quest_list_widget.dart';
import '/data/models/quest_item_model.dart';

class QuestDetailScreen extends StatefulWidget {
  final QuestItemModel quest;

  const QuestDetailScreen({super.key, required this.quest});

  @override
  _QuestDetailScreenState createState() => _QuestDetailScreenState();
}

class _QuestDetailScreenState extends State<QuestDetailScreen> {
  late Timer _timer;
  int _elapsedSeconds = 0;
  bool _isRunning = true;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
      });
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

  double _getProgress() {
    if (widget.quest.deadline == null) return 0.0;
    final totalSeconds = widget.quest.deadline!.difference(widget.quest.createdAt).inSeconds;
    return totalSeconds > 0 ? (_elapsedSeconds / totalSeconds).clamp(0.0, 1.0) : 1.0;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalSeconds = widget.quest.deadline?.difference(widget.quest.createdAt).inSeconds ?? 1;
    final elapsedSeconds = _elapsedSeconds;

    String formatTime(int seconds) {
      final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
      final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
      final secs = (seconds % 60).toString().padLeft(2, '0');
      return "$hours:$minutes:$secs";
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.quest.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.quest.description, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 16),
            Text(
              "${formatTime(elapsedSeconds)} / ${formatTime(totalSeconds)}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: _getProgress(),
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _toggleTimer,
                child: _isRunning ?
                  Icon(
                    Icons.pause,
                    color: Colors.white,
                  ): Icon(
                    Icons.play_arrow,
                    color: Colors.white
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
