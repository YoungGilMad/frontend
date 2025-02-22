import 'package:flutter/material.dart';

class JoinGroupWidget extends StatelessWidget {
  const JoinGroupWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('스터디 그룹 참여'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 검색 필드
            SearchBar(
              hintText: '그룹 이름으로 검색',
              leading: const Icon(Icons.search),
            ),
            const SizedBox(height: 16),
            // 추천 그룹 목록
            Expanded(
              child: ListView.builder(
                itemCount: 0, // TODO: 추천 그룹 목록 추가
                itemBuilder: (context, index) {
                  return const SizedBox(); // TODO: 그룹 카드 위젯 추가
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}