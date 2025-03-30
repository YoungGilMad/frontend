import 'package:flutter/material.dart';

class StoryWatchScreen extends StatefulWidget {
  final String friendName;
  final String? storyImageUrl; // 스토리 이미지 URL

  const StoryWatchScreen({
    super.key,
    required this.friendName,
    required this.storyImageUrl,
  });

  @override
  State<StoryWatchScreen> createState() => _StoryWatchScreenState();
}

class _StoryWatchScreenState extends State<StoryWatchScreen> {
  static const int storyDuration = 7; // 스토리 지속 시간 (7초)
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _startStoryTimer();
  }

  void _startStoryTimer() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() => _progress = 1.0);
      }
    });

    Future.delayed(Duration(seconds: storyDuration), () {
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.pop(context), // 화면 탭하면 닫힘
        child: Stack(
          children: [
            // 스토리 이미지
            Center(
              child: widget.storyImageUrl != null
                  ? Image.network(widget.storyImageUrl!,
                  width: double.infinity, height: double.infinity, fit: BoxFit.cover)
                  : const Icon(Icons.image, size: 100, color: Colors.white),
            ),

            // 상단 진행 바 & 프로필 정보 위치 조정
            Positioned(
              top: 60, // 기존보다 20px 아래로 조정
              left: 10,
              right: 10,
              child: Column(
                children: [
                  // ✅ 7초 동안 왼쪽에서 오른쪽으로 진행되는 바
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[700],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      AnimatedContainer(
                        duration: Duration(seconds: storyDuration),
                        curve: Curves.linear,
                        width: MediaQuery.of(context).size.width * _progress,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15), // 기존보다 살짝 더 아래로 조정

                  // 프로필 정보 & 닫기 버튼
                  Row(
                    children: [
                      const SizedBox(width: 12),
                      CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        widget.friendName,
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
