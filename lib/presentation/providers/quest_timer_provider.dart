// quest_timer_provider.dart
import 'dart:async';
import 'package:flutter/material.dart';

class QuestTimerProvider extends ChangeNotifier {
  final Map<String, _QuestTimerState> _timers = {}; // 🔄 Changed from int to String

  void initialize({
    required String questId,
    required int progressSeconds,
    required int totalSeconds,
  }) {
    if (_timers.containsKey(questId)) return;

    _timers[questId] = _QuestTimerState(
      elapsedSeconds: progressSeconds,
      completeSeconds: totalSeconds > 0 ? totalSeconds : 1,
    );
    notifyListeners();
  }

  void start(String questId, {VoidCallback? onComplete}) {
    final timer = _timers[questId];
    if (timer == null || timer.isRunning) return;

    timer.start(() {
      notifyListeners();
      if (isCompleted(questId)) {
        onComplete?.call(); // ✅ 퀘스트 완료 시 콜백 실행
      }
    });
  }

  void pause(String questId) {
    final timer = _timers[questId];
    timer?.pause();
    notifyListeners();
  }

  void reset(String questId) {
    final timer = _timers[questId];
    timer?.reset();
    notifyListeners();
  }

  int getElapsed(String questId) => _timers[questId]?.elapsedSeconds ?? 0;

  int getComplete(String questId) => _timers[questId]?.completeSeconds ?? 1;

  bool isRunning(String questId) => _timers[questId]?.isRunning ?? false;

  double getProgress(String questId) {
    final t = _timers[questId];
    if (t == null) return 0;
    return (t.elapsedSeconds / t.completeSeconds).clamp(0.0, 1.0);
  }

  bool isCompleted(String questId) {
    final t = _timers[questId];
    return t != null && t.elapsedSeconds >= t.completeSeconds;
  }

  @override
  void dispose() {
    for (final timer in _timers.values) {
      timer.dispose();
    }
    super.dispose();
  }
}

class _QuestTimerState {
  int elapsedSeconds;
  final int completeSeconds;
  bool isRunning = false;
  Timer? _timer;

  _QuestTimerState({
    required this.elapsedSeconds,
    required this.completeSeconds,
  });

  void start(VoidCallback onTick) {
    isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      elapsedSeconds++;
      if (elapsedSeconds >= completeSeconds) {
        pause();
      }
      onTick();
    });
  }

  void pause() {
    _timer?.cancel();
    isRunning = false;
  }

  void reset() {
    pause();
    elapsedSeconds = 0;
  }

  void dispose() {
    _timer?.cancel();
  }
}
