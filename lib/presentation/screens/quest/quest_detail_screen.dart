import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../../widgets/quest/quest_clear_dialog_widget.dart';
import '/data/models/quest_item_model.dart';
import 'package:app_beh/presentation/providers/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestDetailScreen extends StatefulWidget {
  final QuestItemModel quest;
  const QuestDetailScreen({super.key, required this.quest});

  @override
  _QuestDetailScreenState createState() => _QuestDetailScreenState();
}

class _QuestDetailScreenState extends State<QuestDetailScreen> with WidgetsBindingObserver {
  late Timer _timer;
  late int _elapsedSeconds; // 진행 시간 (초)
  late int _completeSeconds;   // 완료 시간 (초)
  bool _isRunning = true;
  bool _isInitialized = false;

  String get _elapsedKey => 'quest_${widget.quest.id}_elapsed';
  String get _pausedAtKey => 'quest_${widget.quest.id}_paused_at';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // 앱 생명주기 감지
    _loadTimerState().then((_) {
      setState(() => _isInitialized = true);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // 앱이 백그라운드로 가거나 돌아올 때 처리
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _persistTimerState();
    }
  }

  // 창을 나갔다가 올 때 시간을 추가하기 위한 누적 시간 저장
  Future<void> _persistTimerState() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('quest_${widget.quest.id}_elapsed', _elapsedSeconds);
    prefs.setInt('quest_${widget.quest.id}_paused_at', DateTime.now().millisecondsSinceEpoch);
  }

  // init시 타이머 상태를 불러오기
  Future<void> _loadTimerState() async {
    final prefs = await SharedPreferences.getInstance();
    final savedElapsed = prefs.getInt(_elapsedKey) ?? widget.quest.progressTime.inSeconds;
    final pausedAt = prefs.getInt(_pausedAtKey);
    final now = DateTime.now().millisecondsSinceEpoch;

    if (pausedAt != null) {
      final diff = ((now - pausedAt) / 1000).floor();
      _elapsedSeconds = savedElapsed + diff;
    } else {
      _elapsedSeconds = savedElapsed;
    }

    _completeSeconds = widget.quest.completeTime.inSeconds > 0
        ? widget.quest.completeTime.inSeconds
        : 1;

    if (mounted) {
      _startTimer();
    }
  }

  Future<void> _clearSavedTimerState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_elapsedKey);
    await prefs.remove(_pausedAtKey);
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
        _timer.cancel();
        _clearSavedTimerState();
        _onQuestComplete();
      }
    });
  }

  void _toggleTimer() {
    setState(() {
      if (_isRunning) {
        _timer.cancel();
        _persistTimerState();
      } else {
        _startTimer();
      }
      _isRunning = !_isRunning;
    });
  }

  double _getProgress() => (_elapsedSeconds / _completeSeconds).clamp(0.0, 1.0);

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
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
