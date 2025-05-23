import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void showCelebrationDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) => AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 10.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 중앙 정렬된 타이틀
          const Text(
            '퀘스트 완료!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Lottie.asset('assets/animations/confetti.json', repeat: true),
          const SizedBox(height: 20),
          const Text(
            '축하합니다! 퀘스트를 완료했습니다.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 24),

          // 중앙 정렬된 버튼
          Center(
            child: ElevatedButton(
              onPressed: () async {
                // await deleteQuest();       // 1. 퀘스트 삭제
                // await giveReward();        // 2. 보상 지급
                Navigator.pop(context);    // 다이얼로그 닫기
              },
              child: const Text('보상받기'),
            ),
          ),
        ],
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );
}